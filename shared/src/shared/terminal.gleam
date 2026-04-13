import gleam/dynamic/decode
import gleam/json

pub type Terminal {
  Terminal(
    id: Int,
    created_at: String,
    code: String,
    name: String,
    active: Bool,
  )
}

pub fn decoder() -> decode.Decoder(Terminal) {
  use id <- decode.field("id", decode.int)
  use created_at <- decode.field("created_at", decode.string)
  use code <- decode.field("code", decode.string)
  use name <- decode.field("name", decode.string)
  use active <- decode.field("active", decode.bool)
  decode.success(Terminal(id:, created_at:, code:, name:, active:))
}

pub fn to_json(terminal: Terminal) -> json.Json {
  let Terminal(id:, created_at:, code:, name:, active:) = terminal
  json.object([
    #("id", json.int(id)),
    #("created_at", json.string(created_at)),
    #("code", json.string(code)),
    #("name", json.string(name)),
    #("active", json.bool(active)),
  ])
}

pub fn list_decoder() -> decode.Decoder(List(Terminal)) {
  use terminals <- decode.field("terminals", decode.list(decoder()))
  decode.success(terminals)
}
