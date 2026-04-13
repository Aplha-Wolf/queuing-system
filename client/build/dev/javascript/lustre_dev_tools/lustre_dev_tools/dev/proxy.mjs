import * as $filepath from "../../../filepath/filepath.mjs";
import * as $request from "../../../gleam_http/gleam/http/request.mjs";
import { Request } from "../../../gleam_http/gleam/http/request.mjs";
import * as $response from "../../../gleam_http/gleam/http/response.mjs";
import * as $httpc from "../../../gleam_httpc/gleam/httpc.mjs";
import * as $bytes_tree from "../../../gleam_stdlib/gleam/bytes_tree.mjs";
import * as $dict from "../../../gleam_stdlib/gleam/dict.mjs";
import * as $list from "../../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../../gleam_stdlib/gleam/option.mjs";
import { Some } from "../../../gleam_stdlib/gleam/option.mjs";
import * as $result from "../../../gleam_stdlib/gleam/result.mjs";
import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import * as $uri from "../../../gleam_stdlib/gleam/uri.mjs";
import * as $tom from "../../../tom/tom.mjs";
import * as $wisp from "../../../wisp/wisp.mjs";
import { Ok, Error, toList, CustomType as $CustomType } from "../../gleam.mjs";
import * as $error from "../../lustre_dev_tools/error.mjs";

export class Proxy extends $CustomType {
  constructor(from, to) {
    super();
    this.from = from;
    this.to = to;
  }
}
export const Proxy$Proxy = (from, to) => new Proxy(from, to);
export const Proxy$isProxy = (value) => value instanceof Proxy;
export const Proxy$Proxy$from = (value) => value.from;
export const Proxy$Proxy$0 = (value) => value.from;
export const Proxy$Proxy$to = (value) => value.to;
export const Proxy$Proxy$1 = (value) => value.to;

export function new$(from, to) {
  if (from === "") {
    if (to === "") {
      return new Error(new $error.ProxyMissingFromTo());
    } else {
      return new Error(new $error.ProxyMissingFrom());
    }
  } else if (from.startsWith("/")) {
    if (to === "") {
      return new Error(new $error.ProxyMissingTo());
    } else {
      let $ = $uri.parse(to);
      if ($ instanceof Ok) {
        let uri = $[0];
        return new Ok(new Proxy(from, uri));
      } else {
        return new Error(new $error.ProxyInvalidTo());
      }
    }
  } else if (to === "") {
    return new Error(new $error.ProxyMissingTo());
  } else {
    let $ = $uri.parse(to);
    if ($ instanceof Ok) {
      let uri = $[0];
      return new Ok(new Proxy("/" + from, uri));
    } else {
      return new Error(new $error.ProxyInvalidTo());
    }
  }
}

function parse_proxy(options) {
  return $result.try$(
    (() => {
      let _pipe = $tom.get_string(options, toList(["from"]));
      return $result.replace_error(_pipe, new $error.ProxyMissingFrom());
    })(),
    (from) => {
      return $result.try$(
        (() => {
          let _pipe = $tom.get_string(options, toList(["to"]));
          return $result.replace_error(_pipe, new $error.ProxyMissingTo());
        })(),
        (to) => { return new$(from, to); },
      );
    },
  );
}

export function get_proxies_from_config(config, path) {
  let $ = $tom.get(config, path);
  if ($ instanceof Ok) {
    let proxy_toml = $[0];
    if (proxy_toml instanceof $tom.Array) {
      let array = proxy_toml[0];
      let _pipe = array;
      let _pipe$1 = $list.map(
        _pipe,
        (table) => {
          if (table instanceof $tom.InlineTable) {
            let proxy = table[0];
            return parse_proxy(proxy);
          } else {
            return new Error(new $error.ProxyInvalidConfig());
          }
        },
      );
      return $result.all(_pipe$1);
    } else if (proxy_toml instanceof $tom.InlineTable) {
      let table = proxy_toml[0];
      let _pipe = table;
      let _pipe$1 = parse_proxy(_pipe);
      return $result.map(_pipe$1, $list.wrap);
    } else {
      return new Error(new $error.ProxyInvalidConfig());
    }
  } else {
    let e = $[0];
    if (e instanceof $tom.NotFound) {
      return new Ok(toList([]));
    } else {
      return new Error(new $error.ProxyInvalidConfig());
    }
  }
}
