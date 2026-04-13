//// This module contains the code to run the sql queries defined in
//// `./src/route/priority/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_all_active_priority` query
/// defined in `./src/route/priority/sql/get_all_active_priority.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetAllActivePriorityRow {
  GetAllActivePriorityRow(
    id: Int,
    create_at: String,
    name: String,
    icon: String,
    prefix: String,
    level: Int,
    active: Bool,
  )
}

/// Runs the `get_all_active_priority` query
/// defined in `./src/route/priority/sql/get_all_active_priority.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_all_active_priority(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
) -> Result(pog.Returned(GetAllActivePriorityRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use create_at <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use icon <- decode.field(3, decode.string)
    use prefix <- decode.field(4, decode.string)
    use level <- decode.field(5, decode.int)
    use active <- decode.field(6, decode.bool)
    decode.success(GetAllActivePriorityRow(
      id:,
      create_at:,
      name:,
      icon:,
      prefix:,
      level:,
      active:,
    ))
  }

  "SELECT
    id, CAST(create_at AS TEXT) AS create_at, name, icon, prefix, level, active
FROM
    priority
WHERE
    active = TRUE
ORDER BY level ASC
LIMIT $1
OFFSET $2
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_no_of_active_priority` query
/// defined in `./src/route/priority/sql/get_no_of_active_priority.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetNoOfActivePriorityRow {
  GetNoOfActivePriorityRow(total_count: Int)
}

/// Runs the `get_no_of_active_priority` query
/// defined in `./src/route/priority/sql/get_no_of_active_priority.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_no_of_active_priority(
  db: pog.Connection,
) -> Result(pog.Returned(GetNoOfActivePriorityRow), pog.QueryError) {
  let decoder = {
    use total_count <- decode.field(0, decode.int)
    decode.success(GetNoOfActivePriorityRow(total_count:))
  }

  "SELECT
    COALESCE(COUNT(id), 0) AS total_count
FROM
    priority
WHERE
    active = TRUE;
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}
