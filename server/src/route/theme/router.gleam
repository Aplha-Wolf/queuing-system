import gleam/http.{Get, Put}
import gleam/int
import gleam/json
import pog
import route/theme/service as theme_service
import route/web
import wisp.{type Response}

pub fn handle_theme_request(
  method: http.Method,
  path_segments: List(String),
  ctx: web.Context,
) -> Response {
  case path_segments {
    [] -> handle_list_themes(method, ctx)
    ["active"] -> handle_active_theme(method, ctx)
    [id] -> handle_theme_by_id(method, id, ctx)
    [id, "activate"] -> handle_activate_theme(method, id, ctx)
    _ -> wisp.not_found()
  }
}

fn handle_list_themes(method: http.Method, ctx: web.Context) -> Response {
  case method {
    Get -> list_themes(ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_active_theme(method: http.Method, ctx: web.Context) -> Response {
  case method {
    Get -> get_active_theme(ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_theme_by_id(
  method: http.Method,
  id: String,
  ctx: web.Context,
) -> Response {
  case method {
    Get -> get_theme_by_id(ctx.db, id)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn handle_activate_theme(
  method: http.Method,
  id: String,
  ctx: web.Context,
) -> Response {
  case method {
    Put -> activate_theme(ctx.db, id)
    _ -> wisp.method_not_allowed([Put])
  }
}

fn list_themes(db: pog.Connection) -> Response {
  case theme_service.list_all_themes(db) {
    Ok(result) -> {
      wisp.ok()
      |> wisp.json_body(
        json.to_string(theme_service.theme_list_to_json(result)),
      )
    }
    Error(err) -> {
      wisp.internal_server_error()
      |> wisp.json_body(json.to_string(theme_service.theme_error_to_json(err)))
    }
  }
}

fn get_active_theme(db: pog.Connection) -> Response {
  case theme_service.get_active_theme(db) {
    Ok(result) -> {
      wisp.ok()
      |> wisp.json_body(
        json.to_string(theme_service.theme_with_colors_to_json(result)),
      )
    }
    Error(err) -> {
      case err {
        theme_service.NotFound -> {
          wisp.not_found()
          |> wisp.json_body(
            json.to_string(theme_service.theme_error_to_json(err)),
          )
        }
        _ -> {
          wisp.internal_server_error()
          |> wisp.json_body(
            json.to_string(theme_service.theme_error_to_json(err)),
          )
        }
      }
    }
  }
}

fn get_theme_by_id(db: pog.Connection, id: String) -> Response {
  case int.parse(id) {
    Ok(parsed_id) -> {
      case theme_service.get_theme_by_id(db, parsed_id) {
        Ok(result) -> {
          wisp.ok()
          |> wisp.json_body(
            json.to_string(theme_service.theme_with_colors_to_json(result)),
          )
        }
        Error(err) -> {
          case err {
            theme_service.NotFound -> {
              wisp.not_found()
              |> wisp.json_body(
                json.to_string(theme_service.theme_error_to_json(err)),
              )
            }
            _ -> {
              wisp.internal_server_error()
              |> wisp.json_body(
                json.to_string(theme_service.theme_error_to_json(err)),
              )
            }
          }
        }
      }
    }
    Error(_) -> wisp.unprocessable_content()
  }
}

fn activate_theme(db: pog.Connection, id: String) -> Response {
  case int.parse(id) {
    Ok(parsed_id) -> {
      case theme_service.activate_theme(db, parsed_id) {
        Ok(result) -> {
          wisp.ok()
          |> wisp.json_body(
            json.to_string(theme_service.activate_result_to_json(result)),
          )
        }
        Error(err) -> {
          case err {
            theme_service.NotFound -> {
              wisp.not_found()
              |> wisp.json_body(
                json.to_string(theme_service.theme_error_to_json(err)),
              )
            }
            _ -> {
              wisp.internal_server_error()
              |> wisp.json_body(
                json.to_string(theme_service.theme_error_to_json(err)),
              )
            }
          }
        }
      }
    }
    Error(_) -> wisp.unprocessable_content()
  }
}
