import * as $response from "../../gleam_http/gleam/http/response.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { style } from "../../lustre/lustre/attribute.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import { none } from "../../lustre/lustre/effect.mjs";
import * as $lustre_elem from "../../lustre/lustre/element.mjs";
import * as $rsvp from "../../rsvp/rsvp.mjs";
import * as $sdisplay from "../../shared/shared/display.mjs";
import * as $api from "../api.mjs";
import { Ok, toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $device from "../lib/device.mjs";
import * as $kit from "../ui/kit.mjs";
import { div, div_with_attrs, text } from "../ui/kit.mjs";
import * as $section from "../ui/section.mjs";
import * as $types from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(display, code, loading, error, device) {
    super();
    this.display = display;
    this.code = code;
    this.loading = loading;
    this.error = error;
    this.device = device;
  }
}
export const Model$Model = (display, code, loading, error, device) =>
  new Model(display, code, loading, error, device);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$display = (value) => value.display;
export const Model$Model$0 = (value) => value.display;
export const Model$Model$code = (value) => value.code;
export const Model$Model$1 = (value) => value.code;
export const Model$Model$loading = (value) => value.loading;
export const Model$Model$2 = (value) => value.loading;
export const Model$Model$error = (value) => value.error;
export const Model$Model$3 = (value) => value.error;
export const Model$Model$device = (value) => value.device;
export const Model$Model$4 = (value) => value.device;

export class LoadedDisplay extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$LoadedDisplay = ($0) => new LoadedDisplay($0);
export const Msg$isLoadedDisplay = (value) => value instanceof LoadedDisplay;
export const Msg$LoadedDisplay$0 = (value) => value[0];

function media_section(model) {
  let _block;
  let $ = model.display;
  if ($ instanceof $option.Some) {
    let d = $[0];
    _block = $int.to_string(d.media_width) + "%";
  } else {
    _block = "50%";
  }
  let width = _block;
  return div(
    "flex h-full bg-black items-center justify-center",
    toList([
      div_with_attrs(
        toList([style("width", width)]),
        toList([
          div(
            "text-white text-4xl font-bold",
            toList([text("DISPLAY: " + model.code)]),
          ),
        ]),
      ),
    ]),
  );
}

function terminal_section() {
  return div(
    "flex h-full bg-black flex-col",
    toList([
      $section.section(
        "NOW SERVING",
        toList([
          div(
            "flex items-center justify-center h-32",
            toList([text("Waiting for queue...")]),
          ),
        ]),
      ),
    ]),
  );
}

export function view(model) {
  return div(
    "flex h-screen w-screen justify-between bg-black",
    toList([media_section(model), terminal_section()]),
  );
}

function fetch_display(code) {
  return $api.get(
    "/api/display/" + code,
    $rsvp.expect_ok_response((var0) => { return new LoadedDisplay(var0); }),
  );
}

export function init(code) {
  return [
    new Model(
      new $option.None(),
      code,
      true,
      new $option.None(),
      $device.detect_device(),
    ),
    fetch_display(code),
  ];
}

function display_decoder() {
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
                "active",
                $decode.bool,
                (active) => {
                  return $decode.field(
                    "created_at",
                    $decode.string,
                    (created_at) => {
                      return $decode.field(
                        "now_serving_size",
                        $decode.int,
                        (now_serving_size) => {
                          return $decode.field(
                            "media_width",
                            $decode.int,
                            (media_width) => {
                              return $decode.field(
                                "terminal_div_width",
                                $decode.int,
                                (terminal_div_width) => {
                                  return $decode.field(
                                    "cols",
                                    $decode.int,
                                    (cols) => {
                                      return $decode.field(
                                        "rows",
                                        $decode.int,
                                        (rows) => {
                                          return $decode.field(
                                            "name_size",
                                            $decode.int,
                                            (name_size) => {
                                              return $decode.field(
                                                "que_label_size",
                                                $decode.int,
                                                (que_label_size) => {
                                                  return $decode.field(
                                                    "que_no_size",
                                                    $decode.int,
                                                    (que_no_size) => {
                                                      return $decode.field(
                                                        "date_time_size",
                                                        $decode.int,
                                                        (date_time_size) => {
                                                          return $decode.success(
                                                            new $sdisplay.Display(
                                                              id,
                                                              code,
                                                              name,
                                                              active,
                                                              created_at,
                                                              now_serving_size,
                                                              media_width,
                                                              terminal_div_width,
                                                              cols,
                                                              rows,
                                                              name_size,
                                                              que_label_size,
                                                              que_no_size,
                                                              date_time_size,
                                                            ),
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
                },
              );
            },
          );
        },
      );
    },
  );
}

export function update(model, msg) {
  let $ = msg[0];
  if ($ instanceof Ok) {
    let response = $[0];
    let $1 = $json.parse(response.body, display_decoder());
    if ($1 instanceof Ok) {
      let display = $1[0];
      return [
        new Model(
          new $option.Some(display),
          model.code,
          false,
          model.error,
          model.device,
        ),
        none(),
      ];
    } else {
      return [
        new Model(
          model.display,
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
        model.display,
        model.code,
        false,
        new $option.Some("Failed to load display"),
        model.device,
      ),
      none(),
    ];
  }
}
