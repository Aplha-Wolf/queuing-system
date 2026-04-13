import gleam/http.{Get}
import gleam/string_tree
import route/display/router as display_router
import route/display_terminal/router
import route/frontdesk/router as frontdesk_router
import route/media/router as media_router
import route/priority/router as priority_router
import route/que/router as que_router
import route/quetype/router as quetype_router
import route/settings/router as settings_router
import route/terminal/router as terminal_router
import route/theme/router as theme_router
import route/web
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: web.Context) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home_page(req)
    ["api", "medias", ..] -> media_router.handle_media_request(req, ctx)
    ["api", "terminals", ..] ->
      terminal_router.handle_terminal_request(req, ctx)
    ["api", "queues", "terminals", ..] ->
      que_router.handle_queue_request(req, ctx)
    ["api", "display-terminals", ..path_segment] ->
      router.handle_display_terminal_request(
        req.method,
        path_segment,
        wisp.get_query(req),
        ctx,
      )
    ["api", "displays", ..path_segment] ->
      display_router.handle_display_request(
        req.method,
        path_segment,
        wisp.get_query(req),
        ctx,
      )
    ["api", "frontdesk", ..path_segment] ->
      frontdesk_router.handle_frontdesk_request(
        req.method,
        path_segment,
        wisp.get_query(req),
        ctx,
      )
    ["api", "priority", ..path_segment] ->
      priority_router.handle_priority_request(
        req.method,
        path_segment,
        wisp.get_query(req),
        ctx,
      )
    ["api", "quetype", ..path_segment] ->
      quetype_router.handle_priority_request(
        req.method,
        path_segment,
        wisp.get_query(req),
        ctx,
      )
    ["api", "themes", ..path_segment] ->
      theme_router.handle_theme_request(req.method, path_segment, ctx)
    ["api", "settings", ..path_segment] ->
      settings_router.handle_settings_request(req.method, path_segment, ctx)
    _ -> wisp.not_found()
  }
}

fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("Queuing System API!")
  wisp.ok()
  |> wisp.html_body(string_tree.to_string(html))
}
