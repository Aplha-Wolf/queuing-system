import gleam/http
import gleam/http/request
import gleam/json

import lustre/effect.{type Effect}
import rsvp

const base_url = "http://127.0.0.1:3001"

pub fn get(url: String, handler: rsvp.Handler(msg)) -> Effect(msg) {
  case request.to(base_url <> url) {
    Ok(req) -> rsvp.send(req, handler)
    Error(_) -> rsvp.send(request.new(), handler)
  }
}

pub fn post(
  url: String,
  body: json.Json,
  handler: rsvp.Handler(msg),
) -> Effect(msg) {
  case request.to(base_url <> url) {
    Ok(req) ->
      req
      |> request.set_body(json.to_string(body))
      |> request.prepend_header("content-type", "application/json")
      |> rsvp.send(handler)
    Error(_) -> rsvp.send(request.new(), handler)
  }
}

pub fn put(
  url: String,
  body: json.Json,
  handler: rsvp.Handler(msg),
) -> Effect(msg) {
  case request.to(base_url <> url) {
    Ok(req) ->
      req
      |> request.set_method(http.Put)
      |> request.set_body(json.to_string(body))
      |> request.prepend_header("content-type", "application/json")
      |> rsvp.send(handler)
    Error(_) -> rsvp.send(request.new(), handler)
  }
}

pub fn patch(
  url: String,
  body: json.Json,
  handler: rsvp.Handler(msg),
) -> Effect(msg) {
  case request.to(base_url <> url) {
    Ok(req) ->
      req
      |> request.set_method(http.Patch)
      |> request.set_body(json.to_string(body))
      |> request.prepend_header("content-type", "application/json")
      |> rsvp.send(handler)
    Error(_) -> rsvp.send(request.new(), handler)
  }
}

pub fn delete(
  url: String,
  body: json.Json,
  handler: rsvp.Handler(msg),
) -> Effect(msg) {
  case request.to(base_url <> url) {
    Ok(req) ->
      req
      |> request.set_method(http.Delete)
      |> request.set_body(json.to_string(body))
      |> request.prepend_header("content-type", "application/json")
      |> rsvp.send(handler)
    Error(_) -> rsvp.send(request.new(), handler)
  }
}
