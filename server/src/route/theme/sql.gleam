//// This module contains the code to run the sql queries defined in
//// `./src/route/theme/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// Activate theme by ID
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn activate_theme(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "-- Activate theme by ID
UPDATE theme
SET is_active = true, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Deactivate all themes
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn deactivate_all_themes(
  db: pog.Connection,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "-- Deactivate all themes
UPDATE theme SET is_active = false
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_active_theme` query
/// defined in `./src/route/theme/sql/get_active_theme.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetActiveThemeRow {
  GetActiveThemeRow(
    id: Int,
    name: String,
    display_name: String,
    description: String,
    is_active: Bool,
    is_dark: Bool,
    created_at: String,
  )
}

/// Get active theme
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_active_theme(
  db: pog.Connection,
) -> Result(pog.Returned(GetActiveThemeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use display_name <- decode.field(2, decode.string)
    use description <- decode.field(3, decode.string)
    use is_active <- decode.field(4, decode.bool)
    use is_dark <- decode.field(5, decode.bool)
    use created_at <- decode.field(6, decode.string)
    decode.success(GetActiveThemeRow(
      id:,
      name:,
      display_name:,
      description:,
      is_active:,
      is_dark:,
      created_at:,
    ))
  }

  "-- Get active theme
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
WHERE is_active = true
LIMIT 1
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_theme_by_id` query
/// defined in `./src/route/theme/sql/get_theme_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetThemeByIdRow {
  GetThemeByIdRow(
    id: Int,
    name: String,
    display_name: String,
    description: String,
    is_active: Bool,
    is_dark: Bool,
    created_at: String,
  )
}

/// Get theme by ID
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_theme_by_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetThemeByIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use display_name <- decode.field(2, decode.string)
    use description <- decode.field(3, decode.string)
    use is_active <- decode.field(4, decode.bool)
    use is_dark <- decode.field(5, decode.bool)
    use created_at <- decode.field(6, decode.string)
    decode.success(GetThemeByIdRow(
      id:,
      name:,
      display_name:,
      description:,
      is_active:,
      is_dark:,
      created_at:,
    ))
  }

  "-- Get theme by ID
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
WHERE id = $1
LIMIT 1
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_theme_colors` query
/// defined in `./src/route/theme/sql/get_theme_colors.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetThemeColorsRow {
  GetThemeColorsRow(token: String, light_value: String, dark_value: String)
}

/// Get theme colors by theme_id
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_theme_colors(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetThemeColorsRow), pog.QueryError) {
  let decoder = {
    use token <- decode.field(0, decode.string)
    use light_value <- decode.field(1, decode.string)
    use dark_value <- decode.field(2, decode.string)
    decode.success(GetThemeColorsRow(token:, light_value:, dark_value:))
  }

  "-- Get theme colors by theme_id
SELECT token, light_value, dark_value
FROM theme_color
WHERE theme_id = $1
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `list_themes` query
/// defined in `./src/route/theme/sql/list_themes.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type ListThemesRow {
  ListThemesRow(
    id: Int,
    name: String,
    display_name: String,
    description: String,
    is_active: Bool,
    is_dark: Bool,
    created_at: String,
  )
}

/// List all themes
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn list_themes(
  db: pog.Connection,
) -> Result(pog.Returned(ListThemesRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use name <- decode.field(1, decode.string)
    use display_name <- decode.field(2, decode.string)
    use description <- decode.field(3, decode.string)
    use is_active <- decode.field(4, decode.bool)
    use is_dark <- decode.field(5, decode.bool)
    use created_at <- decode.field(6, decode.string)
    decode.success(ListThemesRow(
      id:,
      name:,
      display_name:,
      description:,
      is_active:,
      is_dark:,
      created_at:,
    ))
  }

  "-- List all themes
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
ORDER BY id ASC
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}
