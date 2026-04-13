import * as $response from "../../gleam_http/gleam/http/response.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import { none } from "../../lustre/lustre/effect.mjs";
import * as $lustre_elem from "../../lustre/lustre/element.mjs";
import * as $rsvp from "../../rsvp/rsvp.mjs";
import * as $sququeue from "../../shared/shared/queue.mjs";
import * as $api from "../api.mjs";
import { Ok, toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $device from "../lib/device.mjs";
import * as $ui_badge from "../ui/badge.mjs";
import * as $card from "../ui/card.mjs";
import * as $kit from "../ui/kit.mjs";
import { div, text } from "../ui/kit.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Success } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(queues, code, loading, error, device) {
    super();
    this.queues = queues;
    this.code = code;
    this.loading = loading;
    this.error = error;
    this.device = device;
  }
}
export const Model$Model = (queues, code, loading, error, device) =>
  new Model(queues, code, loading, error, device);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$queues = (value) => value.queues;
export const Model$Model$0 = (value) => value.queues;
export const Model$Model$code = (value) => value.code;
export const Model$Model$1 = (value) => value.code;
export const Model$Model$loading = (value) => value.loading;
export const Model$Model$2 = (value) => value.loading;
export const Model$Model$error = (value) => value.error;
export const Model$Model$3 = (value) => value.error;
export const Model$Model$device = (value) => value.device;
export const Model$Model$4 = (value) => value.device;

export class LoadedQueues extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$LoadedQueues = ($0) => new LoadedQueues($0);
export const Msg$isLoadedQueues = (value) => value instanceof LoadedQueues;
export const Msg$LoadedQueues$0 = (value) => value[0];

function header(model) {
  let _block;
  let _pipe = $list.length(model.queues);
  _block = $int.to_string(_pipe);
  let queue_count = _block;
  return div(
    "flex text-xl text-white font-extrabold h-[20%] bg-green-800 p-4 justify-between items-center",
    toList([
      text(("FRONTDESK (" + model.code) + ")"),
      $ui_badge.badge(queue_count + " queues", new Success()),
    ]),
  );
}

function body(_) {
  return div(
    "flex h-[80%] items-center justify-center p-8",
    toList([
      $card.card_elevated(
        "Frontdesk Operations",
        toList([text("Queue management interface")]),
      ),
    ]),
  );
}

export function view(model) {
  return div(
    "flex flex-col h-screen bg-gray-900",
    toList([header(model), body(model)]),
  );
}

function fetch_queues(code) {
  return $api.get(
    "/api/queues/" + code,
    $rsvp.expect_ok_response((var0) => { return new LoadedQueues(var0); }),
  );
}

export function init(code) {
  return [
    new Model(
      toList([]),
      code,
      true,
      new $option.None(),
      $device.detect_device(),
    ),
    fetch_queues(code),
  ];
}

function queue_decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "que_label",
        $decode.string,
        (que_label) => {
          return $decode.success(new $sququeue.Queue(id, que_label));
        },
      );
    },
  );
}

function queue_list_decoder() {
  return $decode.list(queue_decoder());
}

export function update(model, msg) {
  let $ = msg[0];
  if ($ instanceof Ok) {
    let response = $[0];
    let $1 = $json.parse(response.body, queue_list_decoder());
    if ($1 instanceof Ok) {
      let queues = $1[0];
      return [
        new Model(queues, model.code, false, model.error, model.device),
        none(),
      ];
    } else {
      return [
        new Model(
          model.queues,
          model.code,
          false,
          new $option.Some("Parse error"),
          model.device,
        ),
        none(),
      ];
    }
  } else {
    return [
      new Model(
        model.queues,
        model.code,
        false,
        new $option.Some("Failed to load queues"),
        model.device,
      ),
      none(),
    ];
  }
}
