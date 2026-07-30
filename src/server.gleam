import app/composer.{type App}
import apps/display/page as page_display
import apps/frontdesk/page as page_frontdesk
import apps/settings/page as page_settings
import apps/terminal/page as page_terminal
import gleam/bit_array
import gleam/bytes_tree
import gleam/erlang/process
import gleam/http/request as http_req
import gleam/http/response as http_resp
import gleam/json
import gleam/list
import gleam/option
import gleam/string
import lustre
import lustre/server_component
import mist

type Route {
  TerminalRoute
  DisplayRoute
  FrontdeskRoute
  SettingsRoute
  NotFound
}

fn parse_route(path: String) -> #(Route, String) {
  case string.split(path, "/") {
    [_, "terminal", code, ..] -> #(TerminalRoute, code)
    [_, "display", code, ..] -> #(DisplayRoute, code)
    [_, "frontdesk", code, ..] -> #(FrontdeskRoute, code)
    [_, "settings"] -> #(SettingsRoute, "")
    _ -> #(NotFound, "")
  }
}

pub fn main() {
  let app = composer.bootstrap()

  let handle = fn(req: http_req.Request(mist.Connection)) -> http_resp.Response(
    mist.ResponseData,
  ) {
    let #(route, code) = parse_route(req.path)
    case route {
      TerminalRoute -> handle_terminal(req, code, app)
      DisplayRoute -> handle_display(req, code, app)
      FrontdeskRoute -> handle_frontdesk(req, code, app)
      SettingsRoute -> handle_settings(req, app)
      NotFound -> serve_static_file(req.path)
    }
  }

  let assert Ok(_) =
    handle
    |> mist.new
    |> mist.port(3001)
    |> mist.start

  process.sleep_forever()
}

fn ext(path: String) -> String {
  case list.last(string.split(path, ".")) {
    Ok(ext) -> ext
    Error(_) -> ""
  }
}

fn serve_static_file(path: String) -> http_resp.Response(mist.ResponseData) {
  let file_path = "./priv" <> path
  case mist.send_file(file_path, offset: 0, limit: option.None) {
    Ok(body) -> {
      let content_type = case ext(path) {
        "css" -> "text/css; charset=utf-8"
        "js" -> "application/javascript; charset=utf-8"
        "mjs" -> "application/javascript; charset=utf-8"
        "html" -> "text/html; charset=utf-8"
        "png" -> "image/png"
        "svg" -> "image/svg+xml"
        "ico" -> "image/x-icon"
        "json" -> "application/json; charset=utf-8"
        "woff2" -> "font/woff2"
        _ -> "application/octet-stream"
      }
      http_resp.new(200)
      |> http_resp.set_header("content-type", content_type)
      |> http_resp.set_body(body)
    }
    Error(_) ->
      http_resp.new(404)
      |> http_resp.set_body(mist.Bytes(bytes_tree.new()))
  }
}

fn is_websocket_upgrade(req: http_req.Request(mist.Connection)) -> Bool {
  list.any(req.headers, fn(h) { string.lowercase(h.0) == "sec-websocket-key" })
}

fn handle_terminal(
  req: http_req.Request(mist.Connection),
  code: String,
  app: App,
) -> http_resp.Response(mist.ResponseData) {
  case is_websocket_upgrade(req) {
    True -> {
      let comp =
        lustre.application(
          page_terminal.init,
          page_terminal.update,
          page_terminal.view,
        )
      let init =
        page_terminal.InitArgs(
          code:,
          terminal_service: app.terminal,
          notification_bus: app.notifications,
        )
      let assert Ok(runtime) = lustre.start_server_component(comp, init)
      start_websocket(req, server_component.subject(runtime))
    }
    False -> html_page_response("Terminal", "/terminal/" <> code)
  }
}

fn handle_display(
  req: http_req.Request(mist.Connection),
  code: String,
  app: App,
) -> http_resp.Response(mist.ResponseData) {
  case is_websocket_upgrade(req) {
    True -> {
      let comp =
        lustre.application(
          page_display.init,
          page_display.update,
          page_display.view,
        )
      let init =
        page_display.InitArgs(
          code:,
          display_service: app.display,
          notification_bus: app.notifications,
        )
      let assert Ok(runtime) = lustre.start_server_component(comp, init)
      start_websocket(req, server_component.subject(runtime))
    }
    False -> html_page_response("Display", "/display/" <> code)
  }
}

fn handle_frontdesk(
  req: http_req.Request(mist.Connection),
  code: String,
  app: App,
) -> http_resp.Response(mist.ResponseData) {
  case is_websocket_upgrade(req) {
    True -> {
      let comp =
        lustre.application(
          page_frontdesk.init,
          page_frontdesk.update,
          page_frontdesk.view,
        )
      let init =
        page_frontdesk.InitArgs(code:, frontdesk_service: app.frontdesk)
      let assert Ok(runtime) = lustre.start_server_component(comp, init)
      start_websocket(req, server_component.subject(runtime))
    }
    False -> html_page_response("Frontdesk", "/frontdesk/" <> code)
  }
}

fn handle_settings(
  req: http_req.Request(mist.Connection),
  app: App,
) -> http_resp.Response(mist.ResponseData) {
  case is_websocket_upgrade(req) {
    True -> {
      let comp =
        lustre.application(
          page_settings.init,
          page_settings.update,
          page_settings.view,
        )
      let init = page_settings.InitArgs(settings_service: app.settings)
      let assert Ok(runtime) = lustre.start_server_component(comp, init)
      start_websocket(req, server_component.subject(runtime))
    }
    False -> html_page_response("Settings", "/settings")
  }
}

fn start_websocket(
  req: http_req.Request(mist.Connection),
  comp_subject,
) -> http_resp.Response(mist.ResponseData) {
  mist.websocket(
    req,
    on_init: fn(_conn) {
      let ws_subject = process.new_subject()
      process.send(comp_subject, server_component.register_subject(ws_subject))
      let selector =
        process.new_selector()
        |> process.select(for: ws_subject)
      #(ws_subject, option.Some(selector))
    },
    handler: fn(subject, msg, conn) {
      case msg {
        mist.Text(data) -> {
          case
            json.parse(data, using: server_component.runtime_message_decoder())
          {
            Ok(runtime_msg) -> {
              process.send(comp_subject, runtime_msg)
              mist.continue(subject)
            }
            _ -> mist.continue(subject)
          }
        }
        mist.Closed -> mist.stop()
        mist.Binary(data) -> {
          case bit_array.to_string(data) {
            Ok(text) -> {
              case
                json.parse(
                  text,
                  using: server_component.runtime_message_decoder(),
                )
              {
                Ok(runtime_msg) -> {
                  process.send(comp_subject, runtime_msg)
                  mist.continue(subject)
                }
                _ -> mist.continue(subject)
              }
            }
            _ -> mist.continue(subject)
          }
        }
        mist.Custom(client_msg) -> {
          let j = server_component.client_message_to_json(client_msg)
          let _ = mist.send_text_frame(conn, json.to_string(j))
          mist.continue(subject)
        }
        mist.Shutdown -> mist.stop()
      }
    },
    on_close: fn(_) { Nil },
  )
}

fn html_page_response(
  title: String,
  route: String,
) -> http_resp.Response(mist.ResponseData) {
  let html = page_html(title, route)
  http_resp.new(200)
  |> http_resp.set_header("content-type", "text/html; charset=utf-8")
  |> http_resp.set_body(mist.Bytes(bytes_tree.from_string(html)))
}

fn page_html(title: String, route: String) -> String {
  "<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"UTF-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
  <link rel=\"stylesheet\" href=\"/styles.css\">
  <title>" <> title <> " - Queuing System</title>
</head>
<body>
  <div id=\"app\">
    <lustre-server-component route=\"" <> route <> "\" method=\"ws\"></lustre-server-component>
  </div>
  <script type=\"module\" src=\"/lustre-server-component.mjs\"></script>
</body>
</html>"
}
