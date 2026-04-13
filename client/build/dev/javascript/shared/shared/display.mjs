import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Display extends $CustomType {
  constructor(id, code, name, active, created_at, now_serving_size, media_width, terminal_div_width, cols, rows, name_size, que_label_size, que_no_size, date_time_size) {
    super();
    this.id = id;
    this.code = code;
    this.name = name;
    this.active = active;
    this.created_at = created_at;
    this.now_serving_size = now_serving_size;
    this.media_width = media_width;
    this.terminal_div_width = terminal_div_width;
    this.cols = cols;
    this.rows = rows;
    this.name_size = name_size;
    this.que_label_size = que_label_size;
    this.que_no_size = que_no_size;
    this.date_time_size = date_time_size;
  }
}
export const Display$Display = (id, code, name, active, created_at, now_serving_size, media_width, terminal_div_width, cols, rows, name_size, que_label_size, que_no_size, date_time_size) =>
  new Display(id,
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
  date_time_size);
export const Display$isDisplay = (value) => value instanceof Display;
export const Display$Display$id = (value) => value.id;
export const Display$Display$0 = (value) => value.id;
export const Display$Display$code = (value) => value.code;
export const Display$Display$1 = (value) => value.code;
export const Display$Display$name = (value) => value.name;
export const Display$Display$2 = (value) => value.name;
export const Display$Display$active = (value) => value.active;
export const Display$Display$3 = (value) => value.active;
export const Display$Display$created_at = (value) => value.created_at;
export const Display$Display$4 = (value) => value.created_at;
export const Display$Display$now_serving_size = (value) =>
  value.now_serving_size;
export const Display$Display$5 = (value) => value.now_serving_size;
export const Display$Display$media_width = (value) => value.media_width;
export const Display$Display$6 = (value) => value.media_width;
export const Display$Display$terminal_div_width = (value) =>
  value.terminal_div_width;
export const Display$Display$7 = (value) => value.terminal_div_width;
export const Display$Display$cols = (value) => value.cols;
export const Display$Display$8 = (value) => value.cols;
export const Display$Display$rows = (value) => value.rows;
export const Display$Display$9 = (value) => value.rows;
export const Display$Display$name_size = (value) => value.name_size;
export const Display$Display$10 = (value) => value.name_size;
export const Display$Display$que_label_size = (value) => value.que_label_size;
export const Display$Display$11 = (value) => value.que_label_size;
export const Display$Display$que_no_size = (value) => value.que_no_size;
export const Display$Display$12 = (value) => value.que_no_size;
export const Display$Display$date_time_size = (value) => value.date_time_size;
export const Display$Display$13 = (value) => value.date_time_size;

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
                                                            new Display(
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

export function to_json(display) {
  let id;
  let code;
  let name;
  let active;
  let created_at;
  let now_serving_size;
  let media_width;
  let terminal_div_width;
  let cols;
  let rows;
  let name_size;
  let que_label_size;
  let que_no_size;
  let date_time_size;
  id = display.id;
  code = display.code;
  name = display.name;
  active = display.active;
  created_at = display.created_at;
  now_serving_size = display.now_serving_size;
  media_width = display.media_width;
  terminal_div_width = display.terminal_div_width;
  cols = display.cols;
  rows = display.rows;
  name_size = display.name_size;
  que_label_size = display.que_label_size;
  que_no_size = display.que_no_size;
  date_time_size = display.date_time_size;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["code", $json.string(code)],
      ["name", $json.string(name)],
      ["active", $json.bool(active)],
      ["created_at", $json.string(created_at)],
      ["now_serving_size", $json.int(now_serving_size)],
      ["media_width", $json.int(media_width)],
      ["terminal_div_width", $json.int(terminal_div_width)],
      ["cols", $json.int(cols)],
      ["rows", $json.int(rows)],
      ["name_size", $json.int(name_size)],
      ["que_label_size", $json.int(que_label_size)],
      ["que_no_size", $json.int(que_no_size)],
      ["date_time_size", $json.int(date_time_size)],
    ]),
  );
}
