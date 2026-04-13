import gleam/json

pub fn page_to_json(count: Int, total: Int) -> json.Json {
  json.object([#("count", json.int(count)), #("total", json.int(total))])
}
