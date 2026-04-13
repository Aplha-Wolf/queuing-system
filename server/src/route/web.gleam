import gleam/http
import gleam/list
import pog
import wisp

pub type Context {
  Context(db: pog.Connection)
}

fn cors(req: wisp.Request, res: wisp.Response) -> wisp.Response {
  let origin = case list.find(req.headers, fn(h) { h.0 == "origin" }) {
    Ok(#(_, origin)) -> origin
    Error(_) -> "*"
  }
  res
  |> wisp.set_header("access-control-allow-origin", origin)
  |> wisp.set_header(
    "access-control-allow-methods",
    "GET, POST, PUT, PATCH, DELETE, OPTIONS",
  )
  |> wisp.set_header(
    "access-control-allow-headers",
    "content-type, authorization, accept",
  )
  |> wisp.set_header("access-control-max-age", "86400")
}

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let assert Ok(priv_directory) = wisp.priv_directory("server")
  let req = wisp.method_override(req)
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- wisp.serve_static(req, under: "/", from: priv_directory)

  case req.method {
    http.Options -> cors(req, wisp.no_content())
    _ -> handle_request(req) |> cors(req, _)
  }
}
