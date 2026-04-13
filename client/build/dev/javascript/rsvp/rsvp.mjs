import * as $fetch from "../gleam_fetch/gleam/fetch.mjs";
import * as $http from "../gleam_http/gleam/http.mjs";
import * as $request from "../gleam_http/gleam/http/request.mjs";
import * as $response from "../gleam_http/gleam/http/response.mjs";
import * as $promise from "../gleam_javascript/gleam/javascript/promise.mjs";
import * as $json from "../gleam_json/gleam/json.mjs";
import * as $decode from "../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $result from "../gleam_stdlib/gleam/result.mjs";
import * as $uri from "../gleam_stdlib/gleam/uri.mjs";
import * as $lustre_simulate from "../lustre/lustre/dev/simulate.mjs";
import * as $effect from "../lustre/lustre/effect.mjs";
import { Ok, Error, CustomType as $CustomType } from "./gleam.mjs";
import { from_relative_url as parse_relative_uri } from "./rsvp.ffi.mjs";

export { parse_relative_uri };

export class BadBody extends $CustomType {}
export const Error$BadBody = () => new BadBody();
export const Error$isBadBody = (value) => value instanceof BadBody;

/**
 * This error can happen when the URL string provided to the [`get`](#get) or
 * [`post`](#post) helpers is not well-formed.
 */
export class BadUrl extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Error$BadUrl = ($0) => new BadUrl($0);
export const Error$isBadUrl = (value) => value instanceof BadUrl;
export const Error$BadUrl$0 = (value) => value[0];

/**
 * This error can happen when the HTTP response status code is not in the `2xx`
 * range but a handler expected it to be.
 */
export class HttpError extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Error$HttpError = ($0) => new HttpError($0);
export const Error$isHttpError = (value) => value instanceof HttpError;
export const Error$HttpError$0 = (value) => value[0];

/**
 * This error is returned when decoding a JSON response body fails.
 */
export class JsonError extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Error$JsonError = ($0) => new JsonError($0);
export const Error$isJsonError = (value) => value instanceof JsonError;
export const Error$JsonError$0 = (value) => value[0];

export class NetworkError extends $CustomType {}
export const Error$NetworkError = () => new NetworkError();
export const Error$isNetworkError = (value) => value instanceof NetworkError;

/**
 * This error can be returned by a handler when it does not know how to handle
 * a response. For example, the [`expect_json`](#expect_json) handler will return
 * this error if the response content-type is not `"application/json"`.
 */
export class UnhandledResponse extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Error$UnhandledResponse = ($0) => new UnhandledResponse($0);
export const Error$isUnhandledResponse = (value) =>
  value instanceof UnhandledResponse;
export const Error$UnhandledResponse$0 = (value) => value[0];

class Handler extends $CustomType {
  constructor(run) {
    super();
    this.run = run;
  }
}

/**
 * Handle any response with a `2xx` status code. This handler will return an
 * `Error` if the response status code is not in the `2xx` range. The specific
 * error will depend on the status code:
 *
 * - `4xx` and `5xx` status codes will return `HttpError`
 *
 * - Other non `2xx` status codes will return `UnhandledResponse`
 *
 * **Note**: if you need to handle HTTP responses with different status codes,
 * you should use the more-general [`expect_any_response`](#expect_any_response)
 * handler.
 */
export function expect_ok_response(handler) {
  return new Handler(
    (result) => {
      return handler(
        $result.try$(
          result,
          (response) => {
            let $ = response.status;
            let code = $;
            if ((code >= 200) && (code < 300)) {
              return new Ok(response);
            } else {
              let code = $;
              if ((code >= 400) && (code < 600)) {
                return new Error(new HttpError(response));
              } else {
                return new Error(new UnhandledResponse(response));
              }
            }
          },
        ),
      );
    },
  );
}

function expect_json_response(handler) {
  return expect_ok_response(
    (result) => {
      return handler(
        $result.try$(
          result,
          (response) => {
            let $ = $response.get_header(response, "content-type");
            if ($ instanceof Ok) {
              let $1 = $[0];
              if ($1 === "application/json") {
                return new Ok(response);
              } else if ($1.startsWith("application/json;")) {
                return new Ok(response);
              } else {
                return new Error(new UnhandledResponse(response));
              }
            } else {
              return new Error(new UnhandledResponse(response));
            }
          },
        ),
      );
    },
  );
}

function expect_text_response(handler) {
  return expect_ok_response(
    (result) => {
      return handler(
        $result.try$(
          result,
          (response) => {
            let $ = $response.get_header(response, "content-type");
            if ($ instanceof Ok) {
              let $1 = $[0];
              if ($1.startsWith("text/")) {
                return new Ok(response);
              } else {
                return new Error(new UnhandledResponse(response));
              }
            } else {
              return new Error(new UnhandledResponse(response));
            }
          },
        ),
      );
    },
  );
}

/**
 * Handle the body of a plain text response. This handler will check the
 * following conditions:
 *
 * - The response status code is `2xx`.
 *
 * - The response content-type specifies `"text/"` such as `"text/plain"` or
 *   `"text/html"`.
 *
 * If any of these conditions are not met, an `Error` will be returned instead.
 * The specific error will depend on which condition failed:
 *
 * - `4xx` and `5xx` status codes will return `HttpError`
 *
 * - Other non `2xx` status codes will return `UnhandledResponse`
 *
 * - A missing or incorrect `content-type` header will return `UnhandledResponse`
 *
 * **Note**: if you need more advanced handling of the request body directly, you
 * should use the more-general [`expect_ok_response`](#expect_ok_response) or
 * [`expect_any_response`](#expect_any_response) handlers.
 */
export function expect_text(handler) {
  return expect_text_response(
    (result) => {
      let _pipe = result;
      let _pipe$1 = $result.map(_pipe, (response) => { return response.body; });
      return handler(_pipe$1);
    },
  );
}

/**
 * Handle any HTTP response, regardless of status code. Your custom handler will
 * still have to handle potential errors such as network errors or malformed
 * responses.
 *
 * It is uncommon to need a handler this low-level, instead you can consider the
 * following more-specific handlers:
 *
 * - [`expect_ok_response`](#expect_ok_response) to handle any response with a
 *   `2xx` status code.
 *
 * - [`expect_json`](#expect_json) to handle responses from JSON apis
 */
export function expect_any_response(handler) {
  return new Handler(handler);
}

function do_send(request, handler) {
  return $effect.from(
    (dispatch) => {
      let _pipe = $fetch.send(request);
      let _pipe$1 = $promise.try_await(_pipe, $fetch.read_text_body);
      let _pipe$2 = $promise.map(
        _pipe$1,
        (_capture) => {
          return $result.map_error(
            _capture,
            (error) => {
              if (error instanceof $fetch.NetworkError) {
                return new NetworkError();
              } else if (error instanceof $fetch.UnableToReadBody) {
                return new BadBody();
              } else {
                return new BadBody();
              }
            },
          );
        },
      );
      let _pipe$3 = $promise.map(_pipe$2, handler.run);
      $promise.tap(_pipe$3, dispatch)
      return undefined;
    },
  );
}

/**
 * Send a [`Request`](https://hexdocs.pm/gleam_http/gleam/http/request.html#Request)
 * and dispatch a message back to your `update` function when the response is
 * handled.
 *
 * For simple requests, you can use the more-convenient [`get`](#get) and
 * [`post`](#post) functions instead.
 *
 * **Note**: On the **JavaScript** target this will use the `fetch` API. Make
 * sure you have a polyfill for it if you need to support older browsers or
 * server-side runtimes that don't have it.
 *
 * **Note**: On the **Erlang** target this will use the `httpc` module. Each
 * request will start a new linked process to make and handle the request.
 */
export function send(request, handler) {
  return do_send(request, handler);
}

function do_send_bits(request, handler) {
  return $effect.from(
    (dispatch) => {
      let _pipe = $fetch.send_bits(request);
      let _pipe$1 = $promise.try_await(_pipe, $fetch.read_text_body);
      let _pipe$2 = $promise.map(
        _pipe$1,
        (_capture) => {
          return $result.map_error(
            _capture,
            (error) => {
              if (error instanceof $fetch.NetworkError) {
                return new NetworkError();
              } else if (error instanceof $fetch.UnableToReadBody) {
                return new BadBody();
              } else {
                return new BadBody();
              }
            },
          );
        },
      );
      let _pipe$3 = $promise.map(_pipe$2, handler.run);
      $promise.tap(_pipe$3, dispatch)
      return undefined;
    },
  );
}

/**
 * Send a [`Request`](https://hexdocs.pm/gleam_http/gleam/http/request.html#Request)
 * with a `BitArray` body and dispatch a message back to your `update` function
 * when the response is handled.
 *
 * Rsvp requires all responses to be UTF-8 encoded strings, and `BitArray`
 * responses that cannot be decoded as UTF-8 will return a `BadBody` error.
 */
export function send_bits(request, handler) {
  return do_send_bits(request, handler);
}

/**
 * Simulate a response in a simulated application. This runs the provided handler
 * against the response and dispatches the message to your simulated application.
 */
export function simulate(simulation, response, handler) {
  return $lustre_simulate.message(simulation, handler.run(new Ok(response)));
}

function reject(err, handler) {
  return $effect.from(
    (dispatch) => {
      let _pipe = new Error(err);
      let _pipe$1 = handler.run(_pipe);
      return dispatch(_pipe$1);
    },
  );
}

function decode_json_body(response, decoder) {
  let _pipe = response.body;
  let _pipe$1 = $json.parse(_pipe, decoder);
  return $result.map_error(_pipe$1, (var0) => { return new JsonError(var0); });
}

/**
 * A handler that runs a JSON decoder on a response body and returns the result
 * as a message. This handler will check the following conditions:
 *
 * - The response status code is `2xx`.
 *
 * - The response content-type is `"application/json"`
 *
 * - The response body can be decoded using the provided JSON decoder
 *
 * If any of these conditions are not met, an `Error` will be returned instead.
 * The specific error will depend on which condition failed:
 *
 * - `4xx` and `5xx` status codes will return `HttpError`
 *
 * - Other non `2xx` status codes will return `UnhandledResponse`
 *
 * - A missing or incorrect `content-type` header will return `UnhandledResponse`
 *
 * - A JSON decoding error will return `JsonError`
 *
 * **Note**: if you need more advanced handling of the request body directly, you
 * should use the more-general [`expect_ok_response`](#expect_ok_response) or
 * [`expect_any_response`](#expect_any_response) handlers.
 */
export function expect_json(decoder, handler) {
  return expect_json_response(
    (result) => {
      let _pipe = result;
      let _pipe$1 = $result.try$(
        _pipe,
        (_capture) => { return decode_json_body(_capture, decoder); },
      );
      return handler(_pipe$1);
    },
  );
}

function to_uri(uri_string) {
  let _block;
  if (uri_string.startsWith("./")) {
    _block = parse_relative_uri(uri_string);
  } else if (uri_string.startsWith("/")) {
    _block = parse_relative_uri(uri_string);
  } else {
    _block = $uri.parse(uri_string);
  }
  let _pipe = _block;
  return $result.replace_error(_pipe, new BadUrl(uri_string));
}

/**
 * A convenience function to send a `GET` request to a URL and handle the response
 * using a [`Handler`](#Handler).
 *
 * **Note**: if you need more control over the kind of request being sent, for
 * example to set additional headers or use a different HTTP method, you should
 * use the more-general [`send`](#send) function instead.
 *
 * **Note**: On the **JavaScript** target this will use the `fetch` API. Make
 * sure you have a polyfill for it if you need to support older browsers or
 * server-side runtimes that don't have it.
 *
 * **Note**: On the **Erlang** target this will use the `httpc` module. Each
 * request will start a new linked process to make and handle the request.
 */
export function get(url, handler) {
  let $ = to_uri(url);
  if ($ instanceof Ok) {
    let uri = $[0];
    let $1 = $request.from_uri(uri);
    if ($1 instanceof Ok) {
      let request = $1[0];
      return send(request, handler);
    } else {
      return reject(new BadUrl(url), handler);
    }
  } else {
    let err = $[0];
    return reject(err, handler);
  }
}

/**
 * A convenience function for sending a POST request with a JSON body and handle
 * the response with a handler function. This will automatically set the
 * `content-type` header to `application/json` and handle requests to relative
 * URLs if this effect is running in a browser.
 *
 * **Note**: if you need more control over the kind of request being sent, for
 * example to set additional headers or use a different HTTP method, you should
 * use the more-general [`send`](#send) function instead.
 *
 * **Note**: On the **JavaScript** target this will use the `fetch` API. Make
 * sure you have a polyfill for it if you need to support older browsers or
 * server-side runtimes that don't have it.
 *
 * **Note**: On the **Erlang** target this will use the `httpc` module. Each
 * request will start a new linked process to make and handle the request.
 */
export function post(url, body, handler) {
  let $ = to_uri(url);
  if ($ instanceof Ok) {
    let uri = $[0];
    let $1 = $request.from_uri(uri);
    if ($1 instanceof Ok) {
      let request = $1[0];
      let _pipe = request;
      let _pipe$1 = $request.set_method(_pipe, new $http.Post());
      let _pipe$2 = $request.set_header(
        _pipe$1,
        "content-type",
        "application/json",
      );
      let _pipe$3 = $request.set_body(_pipe$2, $json.to_string(body));
      return send(_pipe$3, handler);
    } else {
      return reject(new BadUrl(url), handler);
    }
  } else {
    let err = $[0];
    return reject(err, handler);
  }
}

/**
 * A convenience function for sending a PUT request with a JSON body and handle
 * the response with a handler function. This will automatically set the
 * `content-type` header to `application/json` and handle requests to relative
 * URLs if this effect is running in a browser.
 *
 * **Note**: if you need more control over the kind of request being sent, for
 * example to set additional headers or use a different HTTP method, you should
 * use the more-general [`send`](#send) function instead.
 *
 * **Note**: On the **JavaScript** target this will use the `fetch` API. Make
 * sure you have a polyfill for it if you need to support older browsers or
 * server-side runtimes that don't have it.
 *
 * **Note**: On the **Erlang** target this will use the `httpc` module. Each
 * request will start a new linked process to make and handle the request.
 */
export function put(url, body, handler) {
  let $ = to_uri(url);
  if ($ instanceof Ok) {
    let uri = $[0];
    let $1 = $request.from_uri(uri);
    if ($1 instanceof Ok) {
      let request = $1[0];
      let _pipe = request;
      let _pipe$1 = $request.set_method(_pipe, new $http.Put());
      let _pipe$2 = $request.set_header(
        _pipe$1,
        "content-type",
        "application/json",
      );
      let _pipe$3 = $request.set_body(_pipe$2, $json.to_string(body));
      return send(_pipe$3, handler);
    } else {
      return reject(new BadUrl(url), handler);
    }
  } else {
    let err = $[0];
    return reject(err, handler);
  }
}

/**
 * A convenience function for sending a PATCH request with a JSON body and handle
 * the response with a handler function. This will automatically set the
 * `content-type` header to `application/json` and handle requests to relative
 * URLs if this effect is running in a browser.
 *
 * **Note**: if you need more control over the kind of request being sent, for
 * example to set additional headers or use a different HTTP method, you should
 * use the more-general [`send`](#send) function instead.
 *
 * **Note**: On the **JavaScript** target this will use the `fetch` API. Make
 * sure you have a polyfill for it if you need to support older browsers or
 * server-side runtimes that don't have it.
 *
 * **Note**: On the **Erlang** target this will use the `httpc` module. Each
 * request will start a new linked process to make and handle the request.
 */
export function patch(url, body, handler) {
  let $ = to_uri(url);
  if ($ instanceof Ok) {
    let uri = $[0];
    let $1 = $request.from_uri(uri);
    if ($1 instanceof Ok) {
      let request = $1[0];
      let _pipe = request;
      let _pipe$1 = $request.set_method(_pipe, new $http.Patch());
      let _pipe$2 = $request.set_header(
        _pipe$1,
        "content-type",
        "application/json",
      );
      let _pipe$3 = $request.set_body(_pipe$2, $json.to_string(body));
      return send(_pipe$3, handler);
    } else {
      return reject(new BadUrl(url), handler);
    }
  } else {
    let err = $[0];
    return reject(err, handler);
  }
}

/**
 * A convenience function for sending a DELETE request with a JSON body and handle
 * the response with a handler function. This will automatically set the
 * `content-type` header to `application/json` and handle requests to relative
 * URLs if this effect is running in a browser.
 *
 * **Note**: if you need more control over the kind of request being sent, for
 * example to set additional headers or use a different HTTP method, you should
 * use the more-general [`send`](#send) function instead.
 *
 * **Note**: On the **JavaScript** target this will use the `fetch` API. Make
 * sure you have a polyfill for it if you need to support older browsers or
 * server-side runtimes that don't have it.
 *
 * **Note**: On the **Erlang** target this will use the `httpc` module. Each
 * request will start a new linked process to make and handle the request.
 */
export function delete$(url, body, handler) {
  let $ = to_uri(url);
  if ($ instanceof Ok) {
    let uri = $[0];
    let $1 = $request.from_uri(uri);
    if ($1 instanceof Ok) {
      let request = $1[0];
      let _pipe = request;
      let _pipe$1 = $request.set_method(_pipe, new $http.Delete());
      let _pipe$2 = $request.set_header(
        _pipe$1,
        "content-type",
        "application/json",
      );
      let _pipe$3 = $request.set_body(_pipe$2, $json.to_string(body));
      return send(_pipe$3, handler);
    } else {
      return reject(new BadUrl(url), handler);
    }
  } else {
    let err = $[0];
    return reject(err, handler);
  }
}
