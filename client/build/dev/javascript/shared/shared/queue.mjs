import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Queue extends $CustomType {
  constructor(id, que_label) {
    super();
    this.id = id;
    this.que_label = que_label;
  }
}
export const Queue$Queue = (id, que_label) => new Queue(id, que_label);
export const Queue$isQueue = (value) => value instanceof Queue;
export const Queue$Queue$id = (value) => value.id;
export const Queue$Queue$0 = (value) => value.id;
export const Queue$Queue$que_label = (value) => value.que_label;
export const Queue$Queue$1 = (value) => value.que_label;

export function decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "que_label",
        $decode.string,
        (que_label) => { return $decode.success(new Queue(id, que_label)); },
      );
    },
  );
}

export function to_json(queue) {
  let id;
  let que_label;
  id = queue.id;
  que_label = queue.que_label;
  return $json.object(
    toList([["id", $json.int(id)], ["que_label", $json.string(que_label)]]),
  );
}

export function empty() {
  return new Queue(0, "");
}
