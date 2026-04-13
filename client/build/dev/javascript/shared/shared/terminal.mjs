import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Terminal extends $CustomType {
  constructor(id, created_at, code, name, active) {
    super();
    this.id = id;
    this.created_at = created_at;
    this.code = code;
    this.name = name;
    this.active = active;
  }
}
export const Terminal$Terminal = (id, created_at, code, name, active) =>
  new Terminal(id, created_at, code, name, active);
export const Terminal$isTerminal = (value) => value instanceof Terminal;
export const Terminal$Terminal$id = (value) => value.id;
export const Terminal$Terminal$0 = (value) => value.id;
export const Terminal$Terminal$created_at = (value) => value.created_at;
export const Terminal$Terminal$1 = (value) => value.created_at;
export const Terminal$Terminal$code = (value) => value.code;
export const Terminal$Terminal$2 = (value) => value.code;
export const Terminal$Terminal$name = (value) => value.name;
export const Terminal$Terminal$3 = (value) => value.name;
export const Terminal$Terminal$active = (value) => value.active;
export const Terminal$Terminal$4 = (value) => value.active;

export function decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "created_at",
        $decode.string,
        (created_at) => {
          return $decode.field(
            "code",
            $decode.string,
            (code) => {
              return $decode.field(
                "name",
                $decode.string,
                (name) => {
                  return $decode.field(
                    "active",
                    $decode.bool,
                    (active) => {
                      return $decode.success(
                        new Terminal(id, created_at, code, name, active),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

export function to_json(terminal) {
  let id;
  let created_at;
  let code;
  let name;
  let active;
  id = terminal.id;
  created_at = terminal.created_at;
  code = terminal.code;
  name = terminal.name;
  active = terminal.active;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["created_at", $json.string(created_at)],
      ["code", $json.string(code)],
      ["name", $json.string(name)],
      ["active", $json.bool(active)],
    ]),
  );
}

export function list_decoder() {
  return $decode.field(
    "terminals",
    $decode.list(decoder()),
    (terminals) => { return $decode.success(terminals); },
  );
}
