import gleam/dynamic/decode
import gleam/json

pub type Display {
  Display(
    id: Int,
    code: String,
    name: String,
    active: Bool,
    created_at: String,
    now_serving_size: Int,
    media_width: Int,
    terminal_div_width: Int,
    cols: Int,
    rows: Int,
    name_size: Int,
    que_label_size: Int,
    que_no_size: Int,
    date_time_size: Int,
  )
}

pub fn decoder() -> decode.Decoder(Display) {
  use id <- decode.field("id", decode.int)
  use code <- decode.field("code", decode.string)
  use name <- decode.field("name", decode.string)
  use active <- decode.field("active", decode.bool)
  use created_at <- decode.field("created_at", decode.string)
  use now_serving_size <- decode.field("now_serving_size", decode.int)
  use media_width <- decode.field("media_width", decode.int)
  use terminal_div_width <- decode.field("terminal_div_width", decode.int)
  use cols <- decode.field("cols", decode.int)
  use rows <- decode.field("rows", decode.int)
  use name_size <- decode.field("name_size", decode.int)
  use que_label_size <- decode.field("que_label_size", decode.int)
  use que_no_size <- decode.field("que_no_size", decode.int)
  use date_time_size <- decode.field("date_time_size", decode.int)
  decode.success(Display(
    id:,
    code:,
    name:,
    active:,
    created_at:,
    now_serving_size:,
    media_width:,
    terminal_div_width:,
    cols:,
    rows:,
    name_size:,
    que_label_size:,
    que_no_size:,
    date_time_size:,
  ))
}

pub fn to_json(display: Display) -> json.Json {
  let Display(
    id:,
    code:,
    name:,
    active:,
    created_at:,
    now_serving_size:,
    media_width:,
    terminal_div_width:,
    cols:,
    rows:,
    name_size:,
    que_label_size:,
    que_no_size:,
    date_time_size:,
  ) = display
  json.object([
    #("id", json.int(id)),
    #("code", json.string(code)),
    #("name", json.string(name)),
    #("active", json.bool(active)),
    #("created_at", json.string(created_at)),
    #("now_serving_size", json.int(now_serving_size)),
    #("media_width", json.int(media_width)),
    #("terminal_div_width", json.int(terminal_div_width)),
    #("cols", json.int(cols)),
    #("rows", json.int(rows)),
    #("name_size", json.int(name_size)),
    #("que_label_size", json.int(que_label_size)),
    #("que_no_size", json.int(que_no_size)),
    #("date_time_size", json.int(date_time_size)),
  ])
}
