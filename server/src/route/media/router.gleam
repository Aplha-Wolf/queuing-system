import gleam/http.{Get, Post}
import gleam/json
import gleam/string_tree
import pog
import route/media/service as media_service
import route/web
import shared/media as shared_media
import wisp.{type Request, type Response}

pub fn handle_media_request(req: Request, ctx: web.Context) -> Response {
  case wisp.path_segments(req) {
    ["api", "medias"] -> show_medias(req)
    ["api", "medias", "new"] -> handle_get_new_media(req, ctx)
    ["api", "medias", id] -> show_media(req, id)
    _ -> wisp.not_found()
  }
}

fn show_medias(req: Request) -> Response {
  case req.method {
    Get -> identify_media_request()
    Post -> create_media(req)
    _ -> wisp.method_not_allowed([Get, Post])
  }
}

fn identify_media_request() -> Response {
  let html = string_tree.from_string("Media!")
  wisp.ok()
  |> wisp.html_body(string_tree.to_string(html))
}

fn create_media(_req: Request) -> Response {
  let html = string_tree.from_string("Created")
  wisp.created()
  |> wisp.html_body(string_tree.to_string(html))
}

fn show_media(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, Get)

  let html = string_tree.from_string("Comment with id " <> id)
  wisp.ok()
  |> wisp.html_body(string_tree.to_string(html))
}

fn handle_get_new_media(req: Request, ctx: web.Context) -> Response {
  case req.method {
    Get -> get_new_media(ctx.db)
    _ -> wisp.method_not_allowed([Get])
  }
}

fn get_new_media(db: pog.Connection) -> Response {
  case media_service.get_new_media(db) {
    Ok(x) -> {
      wisp.ok()
      |> wisp.json_body(json.to_string(shared_media.to_json(x)))
    }
    Error(err) ->
      wisp.not_found()
      |> wisp.json_body(json.to_string(media_service.media_error_to_json(err)))
  }
}
