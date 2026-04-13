//// This module contains the code to run the sql queries defined in
//// `./src/route/terminal/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `add_terminal` query
/// defined in `./src/route/terminal/sql/add_terminal.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type AddTerminalRow {
  AddTerminalRow(id: Int)
}

/// Runs the `add_terminal` query
/// defined in `./src/route/terminal/sql/add_terminal.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn add_terminal(
  db: pog.Connection,
  arg_1: String,
  arg_2: String,
) -> Result(pog.Returned(AddTerminalRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    decode.success(AddTerminalRow(id:))
  }

  "INSERT INTO terminal 
    (code, name) 
VALUES 
    ($1, $2)
RETURNING id;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `delete_terminal` query
/// defined in `./src/route/terminal/sql/delete_terminal.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn delete_terminal(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "DELETE FROM terminal 
WHERE 
    id = $1"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_terminal_by_code` query
/// defined in `./src/route/terminal/sql/find_terminal_by_code.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTerminalByCodeRow {
  FindTerminalByCodeRow(
    id: Int,
    code: String,
    name: String,
    active: Bool,
    create_at: String,
  )
}

/// Runs the `find_terminal_by_code` query
/// defined in `./src/route/terminal/sql/find_terminal_by_code.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_terminal_by_code(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(FindTerminalByCodeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use active <- decode.field(3, decode.bool)
    use create_at <- decode.field(4, decode.string)
    decode.success(FindTerminalByCodeRow(id:, code:, name:, active:, create_at:))
  }

  "SELECT
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM
    terminal
WHERE
    code LIKE $1
LIMIT 1
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_terminal_by_id` query
/// defined in `./src/route/terminal/sql/find_terminal_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTerminalByIdRow {
  FindTerminalByIdRow(
    id: Int,
    code: String,
    name: String,
    active: Bool,
    create_at: String,
  )
}

/// Runs the `find_terminal_by_id` query
/// defined in `./src/route/terminal/sql/find_terminal_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_terminal_by_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(FindTerminalByIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use active <- decode.field(3, decode.bool)
    use create_at <- decode.field(4, decode.string)
    decode.success(FindTerminalByIdRow(id:, code:, name:, active:, create_at:))
  }

  "SELECT
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM 
    terminal 
WHERE 
    id = $1
LIMIT 1"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_terminal_by_name` query
/// defined in `./src/route/terminal/sql/find_terminal_by_name.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindTerminalByNameRow {
  FindTerminalByNameRow(
    id: Int,
    code: String,
    name: String,
    active: Bool,
    create_at: String,
  )
}

/// Runs the `find_terminal_by_name` query
/// defined in `./src/route/terminal/sql/find_terminal_by_name.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_terminal_by_name(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(FindTerminalByNameRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use active <- decode.field(3, decode.bool)
    use create_at <- decode.field(4, decode.string)
    decode.success(FindTerminalByNameRow(id:, code:, name:, active:, create_at:))
  }

  "SELECT
  id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM
  terminal
WHERE
  name LIKE $1
LIMIT 1"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_all_terminals` query
/// defined in `./src/route/terminal/sql/list_all_terminals.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListAllTerminalsRow {
  ListAllTerminalsRow(
    id: Int,
    code: String,
    name: String,
    active: Bool,
    create_at: String,
  )
}

/// Runs the `list_all_terminals` query
/// defined in `./src/route/terminal/sql/list_all_terminals.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_all_terminals(
  db: pog.Connection,
) -> Result(pog.Returned(ListAllTerminalsRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use code <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use active <- decode.field(3, decode.bool)
    use create_at <- decode.field(4, decode.string)
    decode.success(ListAllTerminalsRow(id:, code:, name:, active:, create_at:))
  }

  "SELECT
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM
    terminal"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `update_teminal` query
/// defined in `./src/route/terminal/sql/update_teminal.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_teminal(
  db: pog.Connection,
  arg_1: String,
  arg_2: String,
  arg_3: Bool,
  arg_4: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "UPDATE terminal 
SET 
    code = $1, name = $2, active = $3
WHERE 
    id = $4"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.bool(arg_3))
  |> pog.parameter(pog.int(arg_4))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
