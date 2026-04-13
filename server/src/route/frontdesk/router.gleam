import gleam/http.{Get}
import gleam/json
import pog
import route/frontdesk/service as frontdesk_service
import route/web
import shared/frontdesk as shared_frontdesk
import wisp.{type Response}

pub fn handle_frontdesk_request(
  method: http.Method,
  path_segments: List(String),
  _query: List(#(String, String)),
  ctx: web.Context,
) -> Response {
  case path_segments {
    [] -> hanfle_list_add_frontdesk(method, ctx)
    [code] -> handle_update_delete_frontdesk(method, ctx, code)
    _ -> wisp.not_found()
  }
}

fn hanfle_list_add_frontdesk(method: http.Method, _ctx: web.Context) -> Response {
  case method {
    _ -> wisp.not_found()
  }
}

fn handle_update_delete_frontdesk(
  method: http.Method,
  ctx: web.Context,
  code: String,
) -> Response {
  case method {
    Get -> get_frontdesk(ctx.db, code)
    _ -> wisp.not_found()
  }
}

fn get_frontdesk(db: pog.Connection, code: String) -> Response {
  case frontdesk_service.get_frontdesk_by_code(code, db) {
    Ok(x) ->
      wisp.ok()
      |> wisp.json_body(json.to_string(shared_frontdesk.to_json(x)))
    Error(y) -> {
      wisp.ok()
      |> wisp.json_body(
        json.to_string(frontdesk_service.frontdesk_error_to_json(y)),
      )
    }
  }
}
