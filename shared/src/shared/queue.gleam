import gleam/dynamic/decode
import gleam/json

pub type Queue {
  Queue(id: Int, que_label: String)
}

pub fn decoder() -> decode.Decoder(Queue) {
  use id <- decode.field("id", decode.int)
  use que_label <- decode.field("que_label", decode.string)
  decode.success(Queue(id:, que_label:))
}

pub fn to_json(queue: Queue) -> json.Json {
  let Queue(id:, que_label:) = queue
  json.object([#("id", json.int(id)), #("que_label", json.string(que_label))])
}

pub fn empty() -> Queue {
  Queue(id: 0, que_label: "")
}
