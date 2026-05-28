//// This module contains the code to run the sql queries defined in
//// `./src/repository/display_terminal/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_display_terminals` query
/// defined in `./src/repository/display_terminal/sql/get_display_terminals.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetDisplayTerminalsRow {
  GetDisplayTerminalsRow(id: Int, code: String, name: String)
}

/// Runs the `get_display_terminals` query
/// defined in `./src/repository/display_terminal/sql/get_display_terminals.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_display_terminals(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
) -> Result(pog.Returned(GetDisplayTerminalsRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    decode.success(GetDisplayTerminalsRow(id:, code:, name:))
  }

  "SELECT
    dt.terminal_id AS id, t.code AS code, t.name AS name
FROM
    display_terminal AS dt
        INNER JOIN terminal AS t ON (t.id = dt.terminal_id)
WHERE
    dt.display_id = $1
ORDER BY
    dt.order ASC, dt.id ASC
LIMIT $2
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
