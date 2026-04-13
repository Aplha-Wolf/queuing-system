//// This module contains the code to run the sql queries defined in
//// `./src/route/quetype/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `add_quetype` query
/// defined in `./src/route/quetype/sql/add_quetype.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type AddQuetypeRow {
  AddQuetypeRow(id: Int)
}

/// Runs the `add_quetype` query
/// defined in `./src/route/quetype/sql/add_quetype.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn add_quetype(
  db: pog.Connection,
  arg_1: String,
  arg_2: Bool,
  arg_3: String,
  arg_4: String,
) -> Result(pog.Returned(AddQuetypeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    decode.success(AddQuetypeRow(id:))
  }

  "INSERT INTO
    quetype
    (name, active, color, prefix)
VALUES
    ($1, $2, $3, $4)
RETURNING id;
"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.bool(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_no_of_active_quetype` query
/// defined in `./src/route/quetype/sql/get_no_of_active_quetype.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetNoOfActiveQuetypeRow {
  GetNoOfActiveQuetypeRow(total_count: Int)
}

/// Runs the `get_no_of_active_quetype` query
/// defined in `./src/route/quetype/sql/get_no_of_active_quetype.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_no_of_active_quetype(
  db: pog.Connection,
) -> Result(pog.Returned(GetNoOfActiveQuetypeRow), pog.QueryError) {
  let decoder = {
    use total_count <- decode.field(0, decode.int)
    decode.success(GetNoOfActiveQuetypeRow(total_count:))
  }

  "SELECT
    COALESCE(COUNT(id), 0) AS total_count
FROM
    quetype
WHERE
    active = TRUE;
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_quetype_with_limit_offset` query
/// defined in `./src/route/quetype/sql/get_quetype_with_limit_offset.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetQuetypeWithLimitOffsetRow {
  GetQuetypeWithLimitOffsetRow(
    id: Int,
    create_at: String,
    name: String,
    icon: String,
    prefix: String,
    active: Bool,
  )
}

/// Runs the `get_quetype_with_limit_offset` query
/// defined in `./src/route/quetype/sql/get_quetype_with_limit_offset.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_quetype_with_limit_offset(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
) -> Result(pog.Returned(GetQuetypeWithLimitOffsetRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use create_at <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use icon <- decode.field(3, decode.string)
    use prefix <- decode.field(4, decode.string)
    use active <- decode.field(5, decode.bool)
    decode.success(GetQuetypeWithLimitOffsetRow(
      id:,
      create_at:,
      name:,
      icon:,
      prefix:,
      active:,
    ))
  }

  "SELECT
    id, CAST(create_at AS TEXT) AS create_at, name,
    icon, prefix, active
FROM
    quetype
ORDER BY
    name ASC
LIMIT $1
OFFSET $2;
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
