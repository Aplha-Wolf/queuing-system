import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class DisplayTerminal extends $CustomType {
  constructor(id, code, name, que_label) {
    super();
    this.id = id;
    this.code = code;
    this.name = name;
    this.que_label = que_label;
  }
}
export const DisplayTerminal$DisplayTerminal = (id, code, name, que_label) =>
  new DisplayTerminal(id, code, name, que_label);
export const DisplayTerminal$isDisplayTerminal = (value) =>
  value instanceof DisplayTerminal;
export const DisplayTerminal$DisplayTerminal$id = (value) => value.id;
export const DisplayTerminal$DisplayTerminal$0 = (value) => value.id;
export const DisplayTerminal$DisplayTerminal$code = (value) => value.code;
export const DisplayTerminal$DisplayTerminal$1 = (value) => value.code;
export const DisplayTerminal$DisplayTerminal$name = (value) => value.name;
export const DisplayTerminal$DisplayTerminal$2 = (value) => value.name;
export const DisplayTerminal$DisplayTerminal$que_label = (value) =>
  value.que_label;
export const DisplayTerminal$DisplayTerminal$3 = (value) => value.que_label;

export function decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "code",
        $decode.string,
        (code) => {
          return $decode.field(
            "name",
            $decode.string,
            (name) => {
              return $decode.field(
                "que_label",
                $decode.string,
                (que_label) => {
                  return $decode.success(
                    new DisplayTerminal(id, code, name, que_label),
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

export function to_json(dt) {
  let id;
  let code;
  let name;
  let que_label;
  id = dt.id;
  code = dt.code;
  name = dt.name;
  que_label = dt.que_label;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["code", $json.string(code)],
      ["name", $json.string(name)],
      ["que_label", $json.string(que_label)],
    ]),
  );
}
