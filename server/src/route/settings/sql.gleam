//// This module contains the code to run the sql queries defined in
//// `./src/route/settings/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_settings` query
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetSettingsRow {
  GetSettingsRow(
    id: Int,
    background: String,
    text_primary: String,
    text_secondary: String,
    card_background: String,
    card_border: String,
    card_text: String,
    button_primary: String,
    button_secondary: String,
    input_background: String,
    input_border: String,
    input_text: String,
    header_background: String,
    header_text: String,
    border: String,
    success: String,
    danger: String,
    warning: String,
  )
}

/// Get settings (single global entry)
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_settings(
  db: pog.Connection,
) -> Result(pog.Returned(GetSettingsRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use background <- decode.field(1, decode.string)
    use text_primary <- decode.field(2, decode.string)
    use text_secondary <- decode.field(3, decode.string)
    use card_background <- decode.field(4, decode.string)
    use card_border <- decode.field(5, decode.string)
    use card_text <- decode.field(6, decode.string)
    use button_primary <- decode.field(7, decode.string)
    use button_secondary <- decode.field(8, decode.string)
    use input_background <- decode.field(9, decode.string)
    use input_border <- decode.field(10, decode.string)
    use input_text <- decode.field(11, decode.string)
    use header_background <- decode.field(12, decode.string)
    use header_text <- decode.field(13, decode.string)
    use border <- decode.field(14, decode.string)
    use success <- decode.field(15, decode.string)
    use danger <- decode.field(16, decode.string)
    use warning <- decode.field(17, decode.string)
    decode.success(GetSettingsRow(
      id:,
      background:,
      text_primary:,
      text_secondary:,
      card_background:,
      card_border:,
      card_text:,
      button_primary:,
      button_secondary:,
      input_background:,
      input_border:,
      input_text:,
      header_background:,
      header_text:,
      border:,
      success:,
      danger:,
      warning:,
    ))
  }

  "-- Get settings (single global entry)
SELECT 
  id, background, text_primary, text_secondary,
  card_background, card_border, card_text,
  button_primary, button_secondary,
  input_background, input_border, input_text,
  header_background, header_text,
  border, success, danger, warning
FROM settings
WHERE id = 1"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Update settings
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn update_settings(
  db: pog.Connection,
  arg_1: String,
  arg_2: String,
  arg_3: String,
  arg_4: String,
  arg_5: String,
  arg_6: String,
  arg_7: String,
  arg_8: String,
  arg_9: String,
  arg_10: String,
  arg_11: String,
  arg_12: String,
  arg_13: String,
  arg_14: String,
  arg_15: String,
  arg_16: String,
  arg_17: String,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "-- Update settings
UPDATE settings SET
  background = $1,
  text_primary = $2,
  text_secondary = $3,
  card_background = $4,
  card_border = $5,
  card_text = $6,
  button_primary = $7,
  button_secondary = $8,
  input_background = $9,
  input_border = $10,
  input_text = $11,
  header_background = $12,
  header_text = $13,
  border = $14,
  success = $15,
  danger = $16,
  warning = $17,
  updated_at = CURRENT_TIMESTAMP
WHERE id = 1"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.parameter(pog.text(arg_4))
  |> pog.parameter(pog.text(arg_5))
  |> pog.parameter(pog.text(arg_6))
  |> pog.parameter(pog.text(arg_7))
  |> pog.parameter(pog.text(arg_8))
  |> pog.parameter(pog.text(arg_9))
  |> pog.parameter(pog.text(arg_10))
  |> pog.parameter(pog.text(arg_11))
  |> pog.parameter(pog.text(arg_12))
  |> pog.parameter(pog.text(arg_13))
  |> pog.parameter(pog.text(arg_14))
  |> pog.parameter(pog.text(arg_15))
  |> pog.parameter(pog.text(arg_16))
  |> pog.parameter(pog.text(arg_17))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
