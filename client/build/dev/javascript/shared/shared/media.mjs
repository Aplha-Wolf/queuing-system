import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Media extends $CustomType {
  constructor(id, create_at, name, is_ads, media_type, filename, active) {
    super();
    this.id = id;
    this.create_at = create_at;
    this.name = name;
    this.is_ads = is_ads;
    this.media_type = media_type;
    this.filename = filename;
    this.active = active;
  }
}
export const Media$Media = (id, create_at, name, is_ads, media_type, filename, active) =>
  new Media(id, create_at, name, is_ads, media_type, filename, active);
export const Media$isMedia = (value) => value instanceof Media;
export const Media$Media$id = (value) => value.id;
export const Media$Media$0 = (value) => value.id;
export const Media$Media$create_at = (value) => value.create_at;
export const Media$Media$1 = (value) => value.create_at;
export const Media$Media$name = (value) => value.name;
export const Media$Media$2 = (value) => value.name;
export const Media$Media$is_ads = (value) => value.is_ads;
export const Media$Media$3 = (value) => value.is_ads;
export const Media$Media$media_type = (value) => value.media_type;
export const Media$Media$4 = (value) => value.media_type;
export const Media$Media$filename = (value) => value.filename;
export const Media$Media$5 = (value) => value.filename;
export const Media$Media$active = (value) => value.active;
export const Media$Media$6 = (value) => value.active;

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
                "is_ads",
                $decode.bool,
                (is_ads) => {
                  return $decode.field(
                    "media_type",
                    $decode.int,
                    (media_type) => {
                      return $decode.field(
                        "filename",
                        $decode.string,
                        (filename) => {
                          return $decode.field(
                            "active",
                            $decode.bool,
                            (active) => {
                              return $decode.success(
                                new Media(
                                  id,
                                  create_at,
                                  name,
                                  is_ads,
                                  media_type,
                                  filename,
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

export function to_json(media) {
  let id;
  let create_at;
  let name;
  let is_ads;
  let media_type;
  let filename;
  let active;
  id = media.id;
  create_at = media.create_at;
  name = media.name;
  is_ads = media.is_ads;
  media_type = media.media_type;
  filename = media.filename;
  active = media.active;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["create_at", $json.string(create_at)],
      ["name", $json.string(name)],
      ["is_ads", $json.bool(is_ads)],
      ["media_type", $json.int(media_type)],
      ["filename", $json.string(filename)],
      ["active", $json.bool(active)],
    ]),
  );
}
