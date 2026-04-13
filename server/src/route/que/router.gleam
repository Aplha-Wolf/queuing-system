import gleam/dict
import gleam/http.{Get}
import gleam/int
import gleam/json
import pog
import route/que/service as que_service
import route/web
import shared/queue as shared_queue
import wisp.{type Request, type Response}

pub type TerminalQueue {
  TerminalQueue(id: Int, name: String)
}

pub fn handle_queue_request(req: Request, ctx: web.Context) -> Response {
  case wisp.path_segments(req) {
    ["api", "queues", "terminals"] -> handle_terminal_queues(req, ctx)
    ["api", "queues", "terminals", "next"] ->
      handle_next_terminal_queues(req, ctx)
    ["api", "queues", "terminals", "recall"] ->
      handle_recall_terminal_queues(req, ctx)
    ["api", "queues", "terminals", "onqueues"] ->
      handle_terminal_onqueues(req, ctx)
    ["api", "queues", "terminals", "current"] ->
      handle_terminal_current(req, ctx)
    _ -> wisp.not_found()
  }
}

fn handle_terminal_queues(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> show_terminal_info(req, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_terminal_onqueues(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> show_terminal_onquesues(req, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_terminal_current(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> show_terminal_current(req, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_next_terminal_queues(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> next_queue(req, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_recall_terminal_queues(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> recall_queue(req, ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn recall_queue(req: Request, db: pog.Connection) -> Response {
  let query =
    wisp.get_query(req)
    |> get_terminal_id_from_query()

  case query {
    Ok(id) -> {
      case que_service.get_terminal_queue_by_id(id, db) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(json.to_string(shared_queue.to_json(x)))
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(que_service.que_error_to_json(y)))
        }
      }
    }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([#("current", json.string("Error with id value"))]),
        ),
      )
  }
}

fn show_terminal_info(req: Request, db: pog.Connection) -> Response {
  let query =
    wisp.get_query(req)
    |> get_terminal_code_from_query()

  case query {
    Ok(code) -> {
      case que_service.show_terminal_info(code, db) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(
            json.to_string(que_service.terminal_info_to_json(x)),
          )
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(que_service.que_error_to_json(y)))
        }
      }
    }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([#("current", json.string("Error with code value"))]),
        ),
      )
  }
}

fn show_terminal_onquesues(req: Request, db: pog.Connection) -> Response {
  let query =
    wisp.get_query(req)
    |> get_terminal_code_from_query()

  case query {
    Ok(code) -> {
      case que_service.get_terminal_queues_by_code(code, db) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(json.to_string(que_service.que_list_to_json(x)))
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(que_service.que_error_to_json(y)))
        }
      }
    }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([#("current", json.string("Error with code value"))]),
        ),
      )
  }
}

fn show_terminal_current(req: Request, db: pog.Connection) -> Response {
  let query =
    wisp.get_query(req)
    |> get_terminal_code_from_query()

  case query {
    Ok(code) -> {
      case que_service.get_terminal_queue_by_code(code, db) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(json.to_string(shared_queue.to_json(x)))
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(que_service.que_error_to_json(y)))
        }
      }
    }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([#("current", json.string("Error with code value"))]),
        ),
      )
  }
}

fn get_terminal_code_from_query(
  query: List(#(String, String)),
) -> Result(String, Nil) {
  let res =
    dict.from_list(query)
    |> dict.get("code")

  res
}

fn next_queue(req: Request, db: pog.Connection) -> Response {
  let query =
    wisp.get_query(req)
    |> get_terminal_id_from_query()

  case query {
    Ok(id) -> {
      case que_service.next_queue(id, db) {
        Ok(x) -> {
          wisp.ok()
          |> wisp.json_body(json.to_string(shared_queue.to_json(x)))
        }
        Error(y) -> {
          wisp.not_found()
          |> wisp.json_body(json.to_string(que_service.que_error_to_json(y)))
        }
      }
    }
    Error(_) ->
      wisp.unprocessable_content()
      |> wisp.json_body(
        json.to_string(
          json.object([#("current", json.string("Error with id value"))]),
        ),
      )
  }
}

fn get_terminal_id_from_query(
  query: List(#(String, String)),
) -> Result(Int, Nil) {
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
