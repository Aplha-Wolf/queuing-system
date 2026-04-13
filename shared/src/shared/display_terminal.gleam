import gleam/dynamic/decode
import gleam/json

pub type DisplayTerminal {
  DisplayTerminal(id: Int, code: String, name: String, que_label: String)
}

pub fn decoder() -> decode.Decoder(DisplayTerminal) {
  use id <- decode.field("id", decode.int)
  use code <- decode.field("code", decode.string)
  use name <- decode.field("name", decode.string)
  use que_label <- decode.field("que_label", decode.string)
  decode.success(DisplayTerminal(id:, code:, name:, que_label:))
}

pub fn to_json(dt: DisplayTerminal) -> json.Json {
  let DisplayTerminal(id:, code:, name:, que_label:) = dt
  json.object([
    #("id", json.int(id)),
    #("code", json.string(code)),
    #("name", json.string(name)),
    #("que_label", json.string(que_label)),
  ])
}
