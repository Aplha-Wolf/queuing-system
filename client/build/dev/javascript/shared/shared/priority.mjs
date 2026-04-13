import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Priority extends $CustomType {
  constructor(id, create_at, name, icon, level, prefix, active) {
    super();
    this.id = id;
    this.create_at = create_at;
    this.name = name;
    this.icon = icon;
    this.level = level;
    this.prefix = prefix;
    this.active = active;
  }
}
export const Priority$Priority = (id, create_at, name, icon, level, prefix, active) =>
  new Priority(id, create_at, name, icon, level, prefix, active);
export const Priority$isPriority = (value) => value instanceof Priority;
export const Priority$Priority$id = (value) => value.id;
export const Priority$Priority$0 = (value) => value.id;
export const Priority$Priority$create_at = (value) => value.create_at;
export const Priority$Priority$1 = (value) => value.create_at;
export const Priority$Priority$name = (value) => value.name;
export const Priority$Priority$2 = (value) => value.name;
export const Priority$Priority$icon = (value) => value.icon;
export const Priority$Priority$3 = (value) => value.icon;
export const Priority$Priority$level = (value) => value.level;
export const Priority$Priority$4 = (value) => value.level;
export const Priority$Priority$prefix = (value) => value.prefix;
export const Priority$Priority$5 = (value) => value.prefix;
export const Priority$Priority$active = (value) => value.active;
export const Priority$Priority$6 = (value) => value.active;

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
            "name",
            $decode.string,
            (name) => {
              return $decode.field(
                "icon",
                $decode.string,
                (icon) => {
                  return $decode.field(
                    "level",
                    $decode.int,
                    (level) => {
                      return $decode.field(
                        "prefix",
                        $decode.string,
                        (prefix) => {
                          return $decode.field(
                            "active",
                            $decode.bool,
                            (active) => {
                              return $decode.success(
                                new Priority(
                                  id,
                                  create_at,
                                  name,
                                  icon,
                                  level,
                                  prefix,
                                  active,
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
}

export function to_json(priority) {
  let id;
  let create_at;
  let name;
  let icon;
  let level;
  let prefix;
  let active;
  id = priority.id;
  create_at = priority.create_at;
  name = priority.name;
  icon = priority.icon;
  level = priority.level;
  prefix = priority.prefix;
  active = priority.active;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["create_at", $json.string(create_at)],
      ["name", $json.string(name)],
      ["icon", $json.string(icon)],
      ["level", $json.int(level)],
      ["prefix", $json.string(prefix)],
      ["active", $json.bool(active)],
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
