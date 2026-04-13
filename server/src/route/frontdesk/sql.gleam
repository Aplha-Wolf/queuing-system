//// This module contains the code to run the sql queries defined in
//// `./src/route/frontdesk/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_frontdesk_by_code` query
/// defined in `./src/route/frontdesk/sql/get_frontdesk_by_code.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetFrontdeskByCodeRow {
  GetFrontdeskByCodeRow(
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

/// Runs the `get_frontdesk_by_code` query
/// defined in `./src/route/frontdesk/sql/get_frontdesk_by_code.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_frontdesk_by_code(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(GetFrontdeskByCodeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use create_at <- decode.field(1, decode.string)
    use code <- decode.field(2, decode.string)
    use name <- decode.field(3, decode.string)
    use active <- decode.field(4, decode.bool)
    use title_fontsize <- decode.field(5, decode.int)
    use option_fontsize <- decode.field(6, decode.int)
    use icon_height <- decode.field(7, decode.int)
    use icon_width <- decode.field(8, decode.int)
    use priority_cols <- decode.field(9, decode.int)
    use priority_rows <- decode.field(10, decode.int)
    use transaction_cols <- decode.field(11, decode.int)
    use transaction_rows <- decode.field(12, decode.int)
    decode.success(GetFrontdeskByCodeRow(
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

  "SELECT
    id, CAST(create_at AS TEXT) AS create_at, code, name, active,
    title_fontsize, option_fontsize, icon_height, icon_width,
    priority_cols, priority_rows, transaction_cols, transaction_rows
FROM
    frontdesk
WHERE
    code LIKE $1
ORDER BY
    create_at DESC
LIMIT 1;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_all_frontdesk` query
/// defined in `./src/route/frontdesk/sql/list_all_frontdesk.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListAllFrontdeskRow {
  ListAllFrontdeskRow(
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

/// Runs the `list_all_frontdesk` query
/// defined in `./src/route/frontdesk/sql/list_all_frontdesk.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_all_frontdesk(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(ListAllFrontdeskRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use create_at <- decode.field(1, decode.string)
    use code <- decode.field(2, decode.string)
    use name <- decode.field(3, decode.string)
    use active <- decode.field(4, decode.bool)
    use title_fontsize <- decode.field(5, decode.int)
    use option_fontsize <- decode.field(6, decode.int)
    use icon_height <- decode.field(7, decode.int)
    use icon_width <- decode.field(8, decode.int)
    use priority_cols <- decode.field(9, decode.int)
    use priority_rows <- decode.field(10, decode.int)
    use transaction_cols <- decode.field(11, decode.int)
    use transaction_rows <- decode.field(12, decode.int)
    decode.success(ListAllFrontdeskRow(
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

  "SELECT
    id, CAST(create_at AS TEXT) AS create_at, code, name, active, title_fontsize, option_fontsize,
    icon_height, icon_width, priority_cols, priority_rows, transaction_cols,
    transaction_rows
FROM frontdesk
LIMIT $1
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
