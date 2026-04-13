import gleam/dynamic/decode
import gleam/json

pub type Media {
  Media(
    id: Int,
    create_at: String,
    name: String,
    is_ads: Bool,
    media_type: Int,
    filename: String,
    active: Bool,
  )
}

pub fn decoder() -> decode.Decoder(Media) {
  use id <- decode.field("id", decode.int)
  use create_at <- decode.field("create_at", decode.string)
  use name <- decode.field("name", decode.string)
  use is_ads <- decode.field("is_ads", decode.bool)
  use media_type <- decode.field("media_type", decode.int)
  use filename <- decode.field("filename", decode.string)
  use active <- decode.field("active", decode.bool)
  decode.success(Media(
    id:,
    create_at:,
    name:,
    is_ads:,
    media_type:,
    filename:,
    active:,
  ))
}

pub fn to_json(media: Media) -> json.Json {
  let Media(id:, create_at:, name:, is_ads:, media_type:, filename:, active:) =
    media
  json.object([
    #("id", json.int(id)),
    #("create_at", json.string(create_at)),
    #("name", json.string(name)),
    #("is_ads", json.bool(is_ads)),
    #("media_type", json.int(media_type)),
    #("filename", json.string(filename)),
    #("active", json.bool(active)),
  ])
}
