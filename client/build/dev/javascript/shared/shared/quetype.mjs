import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class QueType extends $CustomType {
  constructor(id, create_at, name, icon, prefix, active) {
    super();
    this.id = id;
    this.create_at = create_at;
    this.name = name;
    this.icon = icon;
    this.prefix = prefix;
    this.active = active;
  }
}
export const QueType$QueType = (id, create_at, name, icon, prefix, active) =>
  new QueType(id, create_at, name, icon, prefix, active);
export const QueType$isQueType = (value) => value instanceof QueType;
export const QueType$QueType$id = (value) => value.id;
export const QueType$QueType$0 = (value) => value.id;
export const QueType$QueType$create_at = (value) => value.create_at;
export const QueType$QueType$1 = (value) => value.create_at;
export const QueType$QueType$name = (value) => value.name;
export const QueType$QueType$2 = (value) => value.name;
export const QueType$QueType$icon = (value) => value.icon;
export const QueType$QueType$3 = (value) => value.icon;
export const QueType$QueType$prefix = (value) => value.prefix;
export const QueType$QueType$4 = (value) => value.prefix;
export const QueType$QueType$active = (value) => value.active;
export const QueType$QueType$5 = (value) => value.active;

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
                    "prefix",
                    $decode.string,
                    (prefix) => {
                      return $decode.field(
                        "active",
                        $decode.bool,
                        (active) => {
                          return $decode.success(
                            new QueType(
                              id,
                              create_at,
                              name,
                              icon,
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
}

export function to_json(quetype) {
  let id;
  let create_at;
  let name;
  let icon;
  let prefix;
  let active;
  id = quetype.id;
  create_at = quetype.create_at;
  name = quetype.name;
  icon = quetype.icon;
  prefix = quetype.prefix;
  active = quetype.active;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["create_at", $json.string(create_at)],
      ["name", $json.string(name)],
      ["icon", $json.string(icon)],
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
