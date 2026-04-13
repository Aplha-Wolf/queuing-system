import gleam/dynamic/decode
import gleam/http.{Delete, Get, Post}
import gleam/int
import gleam/json
import pog
import route/terminal/service
import route/web
import shared/terminal as shared_terminal
import wisp.{type Request, type Response}

pub type Terminal {
  Terminal(
    id: Int,
    created_at: String,
    code: String,
    name: String,
    active: Bool,
  )
}

pub fn handle_terminal_request(req: Request, ctx: web.Context) -> Response {
  case wisp.path_segments(req) {
    ["api", "terminals"] -> handle_list_add_terminal(req, ctx)
    ["api", "terminals", id] -> handle_update_delete_terminal(req, ctx, id)
    _ -> wisp.not_found()
  }
}

fn handle_list_add_terminal(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> show_terminal(req, ctx.db)
    Post -> add_terminal(req, ctx.db)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn handle_update_delete_terminal(
  req: Request,
  ctx: web.Context,
  id: String,
) -> Response {
  case req.method {
    Get -> show_terminal(req, ctx.db)
    Post -> update_terminal(req, ctx.db, id)
    Delete -> delete_terminal(ctx.db, id)
    _ -> wisp.method_not_allowed([Get, Post, Delete])
  }
}

fn list_terminals(db: pog.Connection) -> Response {
  case service.list_all_terminals(db) {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(json.to_string(service.terminal_list_to_json(x)))
    }
    Error(y) -> {
      wisp.internal_server_error()
      |> wisp.json_body(json.to_string(service.terminal_error_to_json(y)))
    }
  }
}

fn add_terminal(req: Request, db: pog.Connection) -> Response {
  use req_body <- wisp.require_json(req)

  let decoder = {
    use code <- decode.field("code", decode.string)
    use name <- decode.field("name", decode.string)
    decode.success(Terminal(
      code: code,
      name: name,
      active: True,
      created_at: "",
      id: 0,
    ))
  }

  case decode.run(req_body, decoder) {
    Ok(json_body) -> {
      case service.add_terminal(db, json_body.code, json_body.name) {
        Ok(x) -> {
          wisp.created()
          |> wisp.json_body(
            json.to_string(service.add_terminal_result_to_json(x)),
          )
        }
        Error(y) -> {
          wisp.internal_server_error()
          |> wisp.json_body(json.to_string(service.terminal_error_to_json(y)))
        }
      }
    }
    Error(_) -> wisp.unprocessable_content()
  }
}

fn delete_terminal(db: pog.Connection, id: String) -> Response {
  case int.parse(id) {
    Ok(id) -> {
      case service.delete_terminal(db, id) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(
            json.to_string(service.delete_terminal_result_to_json(x)),
          )
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(service.terminal_error_to_json(y)))
        }
      }
    }
    Error(_) -> wisp.unprocessable_content()
  }
}

fn show_terminal(req: Request, db: pog.Connection) -> Response {
  let query = wisp.get_query(req)
  determine_show_query(query, db)
}

fn determine_show_query(
  query: List(#(String, String)),
  db: pog.Connection,
) -> Response {
  case query {
    [] -> list_terminals(db)
    [x, ..y] ->
      case x.0 {
        "id" -> show_terminal_by_id(db, x.1)
        "code" -> show_terminal_by_code(db, x.1)
        "name" -> show_terminal_by_name(db, x.1)
        _ -> determine_show_query(y, db)
      }
  }
}

fn show_terminal_by_id(db: pog.Connection, id: String) -> Response {
  case int.parse(id) {
    Ok(id) -> {
      case service.find_terminal_by_id(db, id) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(json.to_string(shared_terminal.to_json(x)))
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(service.terminal_error_to_json(y)))
        }
      }
    }
    Error(_) -> wisp.unprocessable_content()
  }
}

fn show_terminal_by_code(db: pog.Connection, code: String) -> Response {
  case service.find_terminal_by_code(db, code) {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(json.to_string(shared_terminal.to_json(x)))
    }
    Error(y) -> {
      wisp.not_found()
      |> wisp.json_body(json.to_string(service.terminal_error_to_json(y)))
    }
  }
}

fn show_terminal_by_name(db: pog.Connection, name: String) -> Response {
  case service.find_terminal_by_name(db, name) {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(json.to_string(shared_terminal.to_json(x)))
    }
    Error(y) -> {
      wisp.not_found()
      |> wisp.json_body(json.to_string(service.terminal_error_to_json(y)))
    }
  }
}

fn update_terminal(req: Request, db: pog.Connection, id: String) -> Response {
  case int.parse(id) {
    Ok(int_id) -> {
      use req_body <- wisp.require_json(req)

      let decoder = {
        use code <- decode.field("code", decode.string)
        use name <- decode.field("name", decode.string)
        use active <- decode.field("active", decode.bool)
        decode.success(Terminal(
          code: code,
          name: name,
          active: active,
          created_at: "",
          id: int_id,
        ))
      }

      case decode.run(req_body, decoder) {
        Ok(json_body) -> {
          case
            service.update_terminal(
              db,
              json_body.code,
              json_body.name,
              json_body.active,
              int_id,
            )
          {
            Ok(x) -> {
              wisp.ok()
              |> wisp.json_body(
                json.to_string(service.update_terminal_result_to_json(x)),
              )
            }
            Error(y) -> {
              wisp.internal_server_error()
              |> wisp.json_body(
                json.to_string(service.terminal_error_to_json(y)),
              )
            }
          }
        }
        Error(_) ->
          wisp.unprocessable_content()
          |> wisp.json_body(
            json.to_string(
              json.object([
                #("error", json.string("Unprocessable request's body")),
              ]),
            ),
          )
      }
    }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([
            #(
              "error",
              json.string("Unable to parse int value from request query"),
            ),
          ]),
        ),
      )
  }
}
