//// This module contains the code to run the sql queries defined in
//// `./src/route/terminal_quetype/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `add_terminal_quetype` query
/// defined in `./src/route/terminal_quetype/sql/add_terminal_quetype.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type AddTerminalQuetypeRow {
  AddTerminalQuetypeRow(id: Int)
}

/// Runs the `add_terminal_quetype` query
/// defined in `./src/route/terminal_quetype/sql/add_terminal_quetype.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn add_terminal_quetype(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
) -> Result(pog.Returned(AddTerminalQuetypeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    decode.success(AddTerminalQuetypeRow(id:))
  }

  "INSERT INTO
    terminal_quetype
    (terminal_id, quetype_id)
VALUES
    ($1, $2)
RETURNING id;"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `delete_terminal_quetype` query
/// defined in `./src/route/terminal_quetype/sql/delete_terminal_quetype.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn delete_terminal_quetype(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE
FROM
    terminal_quetype
WHERE
    id = $1;"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `list_delete_not_terminal_quetype` query
/// defined in `./src/route/terminal_quetype/sql/list_delete_not_terminal_quetype.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_delete_not_terminal_quetype(
  db: pog.Connection,
  arg_1: Int,
  arg_2: List(Int),
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE FROM
    terminal_quetype
WHERE
    terminal_id = $1
    AND quetype_id != ANY($2);"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.array(fn(value) { pog.int(value) }, arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `list_delete_terminal_quetype` query
/// defined in `./src/route/terminal_quetype/sql/list_delete_terminal_quetype.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_delete_terminal_quetype(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE FROM
    terminal_quetype
WHERE
    terminal_id = $1;"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
