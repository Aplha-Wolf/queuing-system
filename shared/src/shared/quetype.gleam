import gleam/dynamic/decode
import gleam/json

pub type QueType {
  QueType(
    id: Int,
    create_at: String,
    name: String,
    icon: String,
    prefix: String,
    active: Bool,
  )
}

pub fn decoder() -> decode.Decoder(QueType) {
  use id <- decode.field("id", decode.int)
  use create_at <- decode.field("create_at", decode.string)
  use name <- decode.field("name", decode.string)
  use icon <- decode.field("icon", decode.string)
  use prefix <- decode.field("prefix", decode.string)
  use active <- decode.field("active", decode.bool)
  decode.success(QueType(id:, create_at:, name:, icon:, prefix:, active:))
}

pub fn to_json(quetype: QueType) -> json.Json {
  let QueType(id:, create_at:, name:, icon:, prefix:, active:) = quetype
  json.object([
    #("id", json.int(id)),
    #("create_at", json.string(create_at)),
    #("name", json.string(name)),
    #("icon", json.string(icon)),
    #("prefix", json.string(prefix)),
    #("active", json.bool(active)),
  ])
}

pub type ListResponse {
  ListResponse(status: Int, message: String, page: Page, data: List(QueType))
}

pub type Page {
  Page(count: Int, total: Int)
}

pub fn page_decoder() -> decode.Decoder(Page) {
  use count <- decode.field("count", decode.int)
  use total <- decode.field("total", decode.int)
  decode.success(Page(count:, total:))
}

pub fn page_to_json(page: Page) -> json.Json {
  let Page(count:, total:) = page
  json.object([#("count", json.int(count)), #("total", json.int(total))])
}

pub fn list_response_decoder() -> decode.Decoder(ListResponse) {
  use status <- decode.field("status", decode.int)
  use message <- decode.field("message", decode.string)
  use page <- decode.field("page", page_decoder())
  use data <- decode.field("data", decode.list(decoder()))
  decode.success(ListResponse(status:, message:, page:, data:))
}
