import common/common
import gleam/http.{Get}
import gleam/json
import pog
import route/priority/service as priority_service
import route/web
import wisp.{type Response}

pub fn handle_priority_request(
  method: http.Method,
  path_segments: List(String),
  query: List(#(String, String)),
  ctx: web.Context,
) -> Response {
  case path_segments {
    [] -> handle_list_add_priority(method, ctx, query)
    [id] -> handle_update_delete_priority(method, ctx, id, query)
    _ -> wisp.not_found()
  }
}

fn handle_list_add_priority(
  method: http.Method,
  ctx: web.Context,
  query: List(#(String, String)),
) -> Response {
  case method {
    Get -> list_all_active_priority_with_limit_offset(ctx.db, query)
    _ -> wisp.not_found()
  }
}

fn handle_update_delete_priority(
  method: http.Method,
  _ctx: web.Context,
  _id: String,
  _query: List(#(String, String)),
) -> Response {
  case method {
    _ -> wisp.not_found()
  }
}

fn list_all_active_priority_with_limit_offset(
  db: pog.Connection,
  query: List(#(String, String)),
) -> Response {
  let limit = common.get_limit_from_query(query)
  let offset = common.get_offset_from_query(query)

  case
    priority_service.get_active_priority_with_limit_offset(db, limit, offset)
  {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(
        json.to_string(priority_service.priority_list_response_to_json(x)),
      )
    }
    Error(y) -> {
      wisp.ok()
      |> wisp.json_body(
        json.to_string(priority_service.priority_error_to_json(y)),
      )
    }
  }
}
