import gleam/dynamic/decode
import gleam/json

pub type FrontDesk {
  FrontDesk(
    id: Int,
    create_at: String,
    code: String,
    name: String,
    active: Bool,
    title_fontsize: Int,
    option_fontsize: Int,
    icon_height: Int,
    icon_width: Int,
    priority_cols: Int,
    priority_rows: Int,
    transaction_cols: Int,
    transaction_rows: Int,
  )
}

pub fn decoder() -> decode.Decoder(FrontDesk) {
  use id <- decode.field("id", decode.int)
  use create_at <- decode.field("create_at", decode.string)
  use code <- decode.field("code", decode.string)
  use name <- decode.field("name", decode.string)
  use active <- decode.field("active", decode.bool)
  use title_fontsize <- decode.field("title_fontsize", decode.int)
  use option_fontsize <- decode.field("option_fontsize", decode.int)
  use icon_height <- decode.field("icon_height", decode.int)
  use icon_width <- decode.field("icon_width", decode.int)
  use priority_cols <- decode.field("priority_cols", decode.int)
  use priority_rows <- decode.field("priority_rows", decode.int)
  use transaction_cols <- decode.field("transaction_cols", decode.int)
  use transaction_rows <- decode.field("transaction_rows", decode.int)
  decode.success(FrontDesk(
    id:,
    create_at:,
    code:,
    name:,
    active:,
    title_fontsize:,
    option_fontsize:,
    icon_height:,
    icon_width:,
    priority_cols:,
    priority_rows:,
    transaction_cols:,
    transaction_rows:,
  ))
}

pub fn to_json(frontdesk: FrontDesk) -> json.Json {
  let FrontDesk(
    id:,
    create_at:,
    code:,
    name:,
    active:,
    title_fontsize:,
    option_fontsize:,
    icon_height:,
    icon_width:,
    priority_cols:,
    priority_rows:,
    transaction_cols:,
    transaction_rows:,
  ) = frontdesk
  json.object([
    #("id", json.int(id)),
    #("create_at", json.string(create_at)),
    #("code", json.string(code)),
    #("name", json.string(name)),
    #("active", json.bool(active)),
    #("title_fontsize", json.int(title_fontsize)),
    #("option_fontsize", json.int(option_fontsize)),
    #("icon_height", json.int(icon_height)),
    #("icon_width", json.int(icon_width)),
    #("priority_cols", json.int(priority_cols)),
    #("priority_rows", json.int(priority_rows)),
    #("transaction_cols", json.int(transaction_cols)),
    #("transaction_rows", json.int(transaction_rows)),
  ])
}

pub type ListResponse {
  ListResponse(status: Int, message: String, page: Page, data: List(FrontDesk))
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
