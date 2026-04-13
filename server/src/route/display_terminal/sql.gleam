//// This module contains the code to run the sql queries defined in
//// `./src/route/display_terminal/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_display_terminals` query
/// defined in `./src/route/display_terminal/sql/get_display_terminals.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetDisplayTerminalsRow {
  GetDisplayTerminalsRow(id: Int, code: String, name: String, que_label: String)
}

/// Runs the `get_display_terminals` query
/// defined in `./src/route/display_terminal/sql/get_display_terminals.sql`.
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
    use que_label <- decode.field(3, decode.string)
    decode.success(GetDisplayTerminalsRow(id:, code:, name:, que_label:))
  }

  "SELECT
    dt.terminal_id AS id, t.code AS code, t.name AS name, 
    COALESCE((SELECT
        p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0')
    FROM
        que AS q
            INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
                INNER JOIN priority AS p ON (p.id = q.priority_id)
            INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
    WHERE
        q.terminal_id = dt.terminal_id AND q.update_at is NULL
        AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
    ORDER BY
        q.update_at DESC
    LIMIT 1), '') AS que_label
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
