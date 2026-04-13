import gleam/http.{Get, Put}
import gleam/json
import pog
import route/settings/service as settings_service
import route/web
import wisp.{type Response}

pub fn handle_settings_request(
  method: http.Method,
  path_segments: List(String),
  ctx: web.Context,
) -> Response {
  case path_segments {
    ["colors"] -> handle_colors_request(method, ctx)
    _ -> wisp.not_found()
  }
}

fn handle_colors_request(method: http.Method, ctx: web.Context) -> Response {
  case method {
    Get -> get_settings(ctx.db)
    Put -> update_settings(ctx.db)
    _ -> wisp.method_not_allowed([Get, Put])
  }
}

fn get_settings(db: pog.Connection) -> Response {
  case settings_service.get_settings(db) {
    Ok(settings) -> {
      wisp.ok()
      |> wisp.json_body(
        json.to_string(settings_service.settings_to_json(settings)),
      )
    }
    Error(err) -> {
      case err {
        settings_service.NotFound -> wisp.not_found()
        settings_service.DatabaseError(e) ->
          wisp.internal_server_error()
          |> wisp.json_body(json.to_string(e))
      }
    }
  }
}

fn update_settings(_db: pog.Connection) -> Response {
  wisp.ok()
}
