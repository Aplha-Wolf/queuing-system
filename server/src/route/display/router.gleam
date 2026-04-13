import gleam/dict
import gleam/http.{Get}
import gleam/int
import gleam/json
import pog
import route/display/service as display_service
import route/web
import shared/display as shared_display
import wisp.{type Response}

type QuetyTyoe {
  All
  Id(Int)
  Code(String)
}

pub fn handle_display_request(
  method: http.Method,
  path_segments: List(String),
  query: List(#(String, String)),
  ctx: web.Context,
) -> Response {
  case path_segments {
    [] ->
      case determine_display_request(query) {
        Id(id) -> handle_getdisplaybyid_request(method, id, ctx)
        Code(code) -> handle_getdisplaybycode_request(method, code, ctx)
        _ -> handle_getalldisplay_request(method, ctx)
      }
    _ -> wisp.not_found()
  }
}

fn determine_display_request(query: List(#(String, String))) -> QuetyTyoe {
  let id = get_id_from_query(query)
  let code = get_code_from_path(query)

  case id, code {
    Ok(id), _ -> Id(id)
    _, Ok(code) -> Code(code)
    _, _ -> All
  }
}

fn handle_getalldisplay_request(
  method: http.Method,
  ctx: web.Context,
) -> Response {
  case method {
    Get -> get_all_display(ctx)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_all_display(_ctx: web.Context) -> Response {
  wisp.not_found()
  |> wisp.json_body(
    json.to_string(
      json.object([#("message", json.string("Not implemented yet"))]),
    ),
  )
}

fn handle_getdisplaybycode_request(
  method: http.Method,
  code: String,
  ctx: web.Context,
) -> Response {
  case method {
    Get -> get_display_by_code(code, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_display_by_code(code: String, db: pog.Connection) -> Response {
  case display_service.get_display_by_code(db, code) {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(json.to_string(shared_display.to_json(x)))
    }
    Error(y) -> {
      wisp.not_found()
      |> wisp.json_body(
        json.to_string(display_service.display_error_to_json(y)),
      )
    }
  }
}

fn handle_getdisplaybyid_request(
  method: http.Method,
  id: Int,
  ctx: web.Context,
) -> Response {
  case method {
    Get -> get_display_by_id(id, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_display_by_id(id: Int, db: pog.Connection) -> Response {
  case display_service.get_display_by_id(db, id) {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(json.to_string(shared_display.to_json(x)))
    }
    Error(y) -> {
      wisp.not_found()
      |> wisp.json_body(
        json.to_string(display_service.display_error_to_json(y)),
      )
    }
  }
}

fn get_code_from_path(query: List(#(String, String))) -> Result(String, Nil) {
  let res =
    dict.from_list(query)
    |> dict.get("code")

  res
}

fn get_id_from_query(query: List(#(String, String))) -> Result(Int, Nil) {
  let res =
    dict.from_list(query)
    |> dict.get("id")
    |> fn(x) {
      case x {
        Ok(id) -> int.parse(id)
        Error(_) -> Error(Nil)
      }
    }
  res
}
