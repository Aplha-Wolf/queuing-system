//// This module contains the code to run the sql queries defined in
//// `./src/route/display/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_display_by_code` query
/// defined in `./src/route/display/sql/get_display_by_code.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetDisplayByCodeRow {
  GetDisplayByCodeRow(
    id: Int,
    code: String,
    create_at: String,
    name: String,
    active: Bool,
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

/// Runs the `get_display_by_code` query
/// defined in `./src/route/display/sql/get_display_by_code.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_display_by_code(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(GetDisplayByCodeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use create_at <- decode.field(2, decode.string)
    use name <- decode.field(3, decode.string)
    use active <- decode.field(4, decode.bool)
    use now_serving_size <- decode.field(5, decode.int)
    use media_width <- decode.field(6, decode.int)
    use terminal_div_width <- decode.field(7, decode.int)
    use cols <- decode.field(8, decode.int)
    use rows <- decode.field(9, decode.int)
    use name_size <- decode.field(10, decode.int)
    use que_label_size <- decode.field(11, decode.int)
    use que_no_size <- decode.field(12, decode.int)
    use date_time_size <- decode.field(13, decode.int)
    decode.success(GetDisplayByCodeRow(
      id:,
      code:,
      create_at:,
      name:,
      active:,
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

  "SELECT
    id, code, CAST(create_at AS TEXT) AS create_at, name, active, 
    now_serving_size, media_width, terminal_div_width, cols, rows, 
    name_size, que_label_size, que_no_size, date_time_size
FROM
    display
WHERE
    code = $1"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_display_by_id` query
/// defined in `./src/route/display/sql/get_display_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetDisplayByIdRow {
  GetDisplayByIdRow(
    id: Int,
    code: String,
    create_at: String,
    name: String,
    active: Bool,
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

/// Runs the `get_display_by_id` query
/// defined in `./src/route/display/sql/get_display_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_display_by_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetDisplayByIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use create_at <- decode.field(2, decode.string)
    use name <- decode.field(3, decode.string)
    use active <- decode.field(4, decode.bool)
    use now_serving_size <- decode.field(5, decode.int)
    use media_width <- decode.field(6, decode.int)
    use terminal_div_width <- decode.field(7, decode.int)
    use cols <- decode.field(8, decode.int)
    use rows <- decode.field(9, decode.int)
    use name_size <- decode.field(10, decode.int)
    use que_label_size <- decode.field(11, decode.int)
    use que_no_size <- decode.field(12, decode.int)
    use date_time_size <- decode.field(13, decode.int)
    decode.success(GetDisplayByIdRow(
      id:,
      code:,
      create_at:,
      name:,
      active:,
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

  "SELECT
    id, code, CAST(create_at AS TEXT) AS create_at, name, active, 
    now_serving_size, media_width, terminal_div_width, cols, rows, 
    name_size, que_label_size, que_no_size, date_time_size
FROM
    display
WHERE
    id = $1"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
