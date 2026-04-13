import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class FrontDesk extends $CustomType {
  constructor(id, create_at, code, name, active, title_fontsize, option_fontsize, icon_height, icon_width, priority_cols, priority_rows, transaction_cols, transaction_rows) {
    super();
    this.id = id;
    this.create_at = create_at;
    this.code = code;
    this.name = name;
    this.active = active;
    this.title_fontsize = title_fontsize;
    this.option_fontsize = option_fontsize;
    this.icon_height = icon_height;
    this.icon_width = icon_width;
    this.priority_cols = priority_cols;
    this.priority_rows = priority_rows;
    this.transaction_cols = transaction_cols;
    this.transaction_rows = transaction_rows;
  }
}
export const FrontDesk$FrontDesk = (id, create_at, code, name, active, title_fontsize, option_fontsize, icon_height, icon_width, priority_cols, priority_rows, transaction_cols, transaction_rows) =>
  new FrontDesk(id,
  create_at,
  code,
  name,
  active,
  title_fontsize,
  option_fontsize,
  icon_height,
  icon_width,
  priority_cols,
  priority_rows,
  transaction_cols,
  transaction_rows);
export const FrontDesk$isFrontDesk = (value) => value instanceof FrontDesk;
export const FrontDesk$FrontDesk$id = (value) => value.id;
export const FrontDesk$FrontDesk$0 = (value) => value.id;
export const FrontDesk$FrontDesk$create_at = (value) => value.create_at;
export const FrontDesk$FrontDesk$1 = (value) => value.create_at;
export const FrontDesk$FrontDesk$code = (value) => value.code;
export const FrontDesk$FrontDesk$2 = (value) => value.code;
export const FrontDesk$FrontDesk$name = (value) => value.name;
export const FrontDesk$FrontDesk$3 = (value) => value.name;
export const FrontDesk$FrontDesk$active = (value) => value.active;
export const FrontDesk$FrontDesk$4 = (value) => value.active;
export const FrontDesk$FrontDesk$title_fontsize = (value) =>
  value.title_fontsize;
export const FrontDesk$FrontDesk$5 = (value) => value.title_fontsize;
export const FrontDesk$FrontDesk$option_fontsize = (value) =>
  value.option_fontsize;
export const FrontDesk$FrontDesk$6 = (value) => value.option_fontsize;
export const FrontDesk$FrontDesk$icon_height = (value) => value.icon_height;
export const FrontDesk$FrontDesk$7 = (value) => value.icon_height;
export const FrontDesk$FrontDesk$icon_width = (value) => value.icon_width;
export const FrontDesk$FrontDesk$8 = (value) => value.icon_width;
export const FrontDesk$FrontDesk$priority_cols = (value) => value.priority_cols;
export const FrontDesk$FrontDesk$9 = (value) => value.priority_cols;
export const FrontDesk$FrontDesk$priority_rows = (value) => value.priority_rows;
export const FrontDesk$FrontDesk$10 = (value) => value.priority_rows;
export const FrontDesk$FrontDesk$transaction_cols = (value) =>
  value.transaction_cols;
export const FrontDesk$FrontDesk$11 = (value) => value.transaction_cols;
export const FrontDesk$FrontDesk$transaction_rows = (value) =>
  value.transaction_rows;
export const FrontDesk$FrontDesk$12 = (value) => value.transaction_rows;

export class ListResponse extends $CustomType {
  constructor(status, message, page, data) {
    super();
    this.status = status;
    this.message = message;
    this.page = page;
    this.data = data;
  }
}
export const ListResponse$ListResponse = (status, message, page, data) =>
  new ListResponse(status, message, page, data);
export const ListResponse$isListResponse = (value) =>
  value instanceof ListResponse;
export const ListResponse$ListResponse$status = (value) => value.status;
export const ListResponse$ListResponse$0 = (value) => value.status;
export const ListResponse$ListResponse$message = (value) => value.message;
export const ListResponse$ListResponse$1 = (value) => value.message;
export const ListResponse$ListResponse$page = (value) => value.page;
export const ListResponse$ListResponse$2 = (value) => value.page;
export const ListResponse$ListResponse$data = (value) => value.data;
export const ListResponse$ListResponse$3 = (value) => value.data;

export class Page extends $CustomType {
  constructor(count, total) {
    super();
    this.count = count;
    this.total = total;
  }
}
export const Page$Page = (count, total) => new Page(count, total);
export const Page$isPage = (value) => value instanceof Page;
export const Page$Page$count = (value) => value.count;
export const Page$Page$0 = (value) => value.count;
export const Page$Page$total = (value) => value.total;
export const Page$Page$1 = (value) => value.total;

export function decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "create_at",
        $decode.string,
        (create_at) => {
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
                        "title_fontsize",
                        $decode.int,
                        (title_fontsize) => {
                          return $decode.field(
                            "option_fontsize",
                            $decode.int,
                            (option_fontsize) => {
                              return $decode.field(
                                "icon_height",
                                $decode.int,
                                (icon_height) => {
                                  return $decode.field(
                                    "icon_width",
                                    $decode.int,
                                    (icon_width) => {
                                      return $decode.field(
                                        "priority_cols",
                                        $decode.int,
                                        (priority_cols) => {
                                          return $decode.field(
                                            "priority_rows",
                                            $decode.int,
                                            (priority_rows) => {
                                              return $decode.field(
                                                "transaction_cols",
                                                $decode.int,
                                                (transaction_cols) => {
                                                  return $decode.field(
                                                    "transaction_rows",
                                                    $decode.int,
                                                    (transaction_rows) => {
                                                      return $decode.success(
                                                        new FrontDesk(
                                                          id,
                                                          create_at,
                                                          code,
                                                          name,
                                                          active,
                                                          title_fontsize,
                                                          option_fontsize,
                                                          icon_height,
                                                          icon_width,
                                                          priority_cols,
                                                          priority_rows,
                                                          transaction_cols,
                                                          transaction_rows,
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
}

export function to_json(frontdesk) {
  let id;
  let create_at;
  let code;
  let name;
  let active;
  let title_fontsize;
  let option_fontsize;
  let icon_height;
  let icon_width;
  let priority_cols;
  let priority_rows;
  let transaction_cols;
  let transaction_rows;
  id = frontdesk.id;
  create_at = frontdesk.create_at;
  code = frontdesk.code;
  name = frontdesk.name;
  active = frontdesk.active;
  title_fontsize = frontdesk.title_fontsize;
  option_fontsize = frontdesk.option_fontsize;
  icon_height = frontdesk.icon_height;
  icon_width = frontdesk.icon_width;
  priority_cols = frontdesk.priority_cols;
  priority_rows = frontdesk.priority_rows;
  transaction_cols = frontdesk.transaction_cols;
  transaction_rows = frontdesk.transaction_rows;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["create_at", $json.string(create_at)],
      ["code", $json.string(code)],
      ["name", $json.string(name)],
      ["active", $json.bool(active)],
      ["title_fontsize", $json.int(title_fontsize)],
      ["option_fontsize", $json.int(option_fontsize)],
      ["icon_height", $json.int(icon_height)],
      ["icon_width", $json.int(icon_width)],
      ["priority_cols", $json.int(priority_cols)],
      ["priority_rows", $json.int(priority_rows)],
      ["transaction_cols", $json.int(transaction_cols)],
      ["transaction_rows", $json.int(transaction_rows)],
    ]),
  );
}

export function page_decoder() {
  return $decode.field(
    "count",
    $decode.int,
    (count) => {
      return $decode.field(
        "total",
        $decode.int,
        (total) => { return $decode.success(new Page(count, total)); },
      );
    },
  );
}

export function page_to_json(page) {
  let count;
  let total;
  count = page.count;
  total = page.total;
  return $json.object(
    toList([["count", $json.int(count)], ["total", $json.int(total)]]),
  );
}

export function list_response_decoder() {
  return $decode.field(
    "status",
    $decode.int,
    (status) => {
      return $decode.field(
        "message",
        $decode.string,
        (message) => {
          return $decode.field(
            "page",
            page_decoder(),
            (page) => {
              return $decode.field(
                "data",
                $decode.list(decoder()),
                (data) => {
                  return $decode.success(
                    new ListResponse(status, message, page, data),
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
