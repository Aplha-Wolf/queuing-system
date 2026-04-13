import common/common
import gleam/http.{Get}
import gleam/json
import pog
import route/quetype/service as quetype_service
import route/web
import wisp.{type Response}

pub fn handle_priority_request(
  method: http.Method,
  path_segments: List(String),
  query: List(#(String, String)),
  ctx: web.Context,
) -> Response {
  case path_segments {
    [] -> handle_list_add_quetype(method, ctx, query)
    [id] -> handle_update_delete_quetype(method, ctx, id, query)
    _ -> wisp.not_found()
  }
}

fn handle_list_add_quetype(
  method: http.Method,
  ctx: web.Context,
  query: List(#(String, String)),
) -> Response {
  case method {
    Get -> list_all_active_quetype(ctx.db, query)
    _ -> wisp.not_found()
  }
}

fn handle_update_delete_quetype(
  method: http.Method,
  _ctx: web.Context,
  _id: String,
  _query: List(#(String, String)),
) -> Response {
  case method {
    _ -> wisp.not_found()
  }
}

fn list_all_active_quetype(db: pog.Connection, query) -> Response {
  case common.get_limit_result_from_query(query) {
    Ok(x) ->
      case common.get_offset_result_from_query(query) {
        Ok(y) ->
          case quetype_service.get_all_quetype_with_limit_offset(db, x, y) {
            Ok(z) ->
              wisp.ok()
              |> wisp.json_body(
                json.to_string(quetype_service.quetype_list_response_to_json(z)),
              )
            Error(err) ->
              wisp.ok()
              |> wisp.json_body(
                json.to_string(quetype_service.quetype_error_to_json(err)),
              )
          }
        Error(_) -> wisp.not_found()
      }
    Error(_) -> wisp.not_found()
  }
}
