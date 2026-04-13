import gleam/dict
import gleam/http.{Get}
import gleam/int
import gleam/json
import pog
import route/display_terminal/service as display_terminal_service
import route/web
import wisp.{type Response}

pub fn handle_display_terminal_request(
  method: http.Method,
  path_segments: List(String),
  query: List(#(String, String)),
  ctx: web.Context,
) -> Response {
  case path_segments {
    [id] -> handle_display_terminals(method, query, ctx, id)
    _ -> wisp.not_found()
  }
}

fn handle_display_terminals(
  method: http.Method,
  query: List(#(String, String)),
  ctx: web.Context,
  id: String,
) -> Response {
  case method {
    Get -> get_display_terminals(ctx.db, id, query)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_display_terminals(
  db: pog.Connection,
  id: String,
  query: List(#(String, String)),
) -> Response {
  case int.parse(id) {
    Ok(id) ->
      case get_limit_from_query(query) {
        Ok(limit) ->
          case display_terminal_service.get_display_terminals(db, id, limit) {
            Ok(x) -> {
              wisp.ok()
              |> wisp.json_body(
                json.to_string(
                  display_terminal_service.display_terminal_list_to_json(x),
                ),
              )
            }
            Error(y) -> {
              wisp.not_found()
              |> wisp.json_body(
                json.to_string(
                  display_terminal_service.display_terminal_error_to_json(y),
                ),
              )
            }
          }
        Error(_) ->
          wisp.unprocessable_content()
          |> wisp.json_body(
            json.to_string(
              json.object([#("error", json.string("Error with limit value"))]),
            ),
          )
      }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([#("error", json.string("Error with display id value"))]),
        ),
      )
  }
}

fn get_limit_from_query(query: List(#(String, String))) -> Result(Int, Nil) {
  let res =
    dict.from_list(query)
    |> dict.get("limit")
    |> fn(x) {
      case x {
        Ok(limit) -> int.parse(limit)
        Error(_) -> Error(Nil)
      }
    }

  res
}
