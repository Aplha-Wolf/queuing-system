import * as $http from "../gleam_http/gleam/http.mjs";
import * as $request from "../gleam_http/gleam/http/request.mjs";
import * as $json from "../gleam_json/gleam/json.mjs";
import * as $effect from "../lustre/lustre/effect.mjs";
import * as $rsvp from "../rsvp/rsvp.mjs";
import { Ok } from "./gleam.mjs";

const base_url = "http://127.0.0.1:3001";

export function get(url, handler) {
  let $ = $request.to(base_url + url);
  if ($ instanceof Ok) {
    let req = $[0];
    return $rsvp.send(req, handler);
  } else {
    return $rsvp.send($request.new$(), handler);
  }
}

export function post(url, body, handler) {
  let $ = $request.to(base_url + url);
  if ($ instanceof Ok) {
    let req = $[0];
    let _pipe = req;
    let _pipe$1 = $request.set_body(_pipe, $json.to_string(body));
    let _pipe$2 = $request.prepend_header(
      _pipe$1,
      "content-type",
      "application/json",
    );
    return $rsvp.send(_pipe$2, handler);
  } else {
    return $rsvp.send($request.new$(), handler);
  }
}

export function put(url, body, handler) {
  let $ = $request.to(base_url + url);
  if ($ instanceof Ok) {
    let req = $[0];
    let _pipe = req;
    let _pipe$1 = $request.set_method(_pipe, new $http.Put());
    let _pipe$2 = $request.set_body(_pipe$1, $json.to_string(body));
    let _pipe$3 = $request.prepend_header(
      _pipe$2,
      "content-type",
      "application/json",
    );
    return $rsvp.send(_pipe$3, handler);
  } else {
    return $rsvp.send($request.new$(), handler);
  }
}

export function patch(url, body, handler) {
  let $ = $request.to(base_url + url);
  if ($ instanceof Ok) {
    let req = $[0];
    let _pipe = req;
    let _pipe$1 = $request.set_method(_pipe, new $http.Patch());
    let _pipe$2 = $request.set_body(_pipe$1, $json.to_string(body));
    let _pipe$3 = $request.prepend_header(
      _pipe$2,
      "content-type",
      "application/json",
    );
    return $rsvp.send(_pipe$3, handler);
  } else {
    return $rsvp.send($request.new$(), handler);
  }
}

export function delete$(url, body, handler) {
  let $ = $request.to(base_url + url);
  if ($ instanceof Ok) {
    let req = $[0];
    let _pipe = req;
    let _pipe$1 = $request.set_method(_pipe, new $http.Delete());
    let _pipe$2 = $request.set_body(_pipe$1, $json.to_string(body));
    let _pipe$3 = $request.prepend_header(
      _pipe$2,
      "content-type",
      "application/json",
    );
    return $rsvp.send(_pipe$3, handler);
  } else {
    return $rsvp.send($request.new$(), handler);
  }
}
