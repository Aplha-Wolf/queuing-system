//// This module contains the code to run the sql queries defined in
//// `./src/route/media/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `get_new_media` query
/// defined in `./src/route/media/sql/get_new_media.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetNewMediaRow {
  GetNewMediaRow(
    id: Int,
    create_at: String,
    name: String,
    is_ads: Bool,
    media_type: Int,
    filename: String,
    active: Bool,
  )
}

/// Runs the `get_new_media` query
/// defined in `./src/route/media/sql/get_new_media.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_new_media(
  db: pog.Connection,
) -> Result(pog.Returned(GetNewMediaRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use create_at <- decode.field(1, decode.string)
    use name <- decode.field(2, decode.string)
    use is_ads <- decode.field(3, decode.bool)
    use media_type <- decode.field(4, decode.int)
    use filename <- decode.field(5, decode.string)
    use active <- decode.field(6, decode.bool)
    decode.success(GetNewMediaRow(
      id:,
      create_at:,
      name:,
      is_ads:,
      media_type:,
      filename:,
      active:,
    ))
  }

  "SELECT
  id, TO_CHAR(create_at, 'YYYY-MM-DD HH24:MI:SS') AS create_at, name, is_ads, media_type, filename, active 
FROM
    media
WHERE id = (
    SELECT id
    FROM media
  WHERE active = TRUE AND is_ads = TRUE
    ORDER BY RANDOM() LIMIT 1
);
"
  |> pog.query
  |> pog.returning(decoder)
  |> pog.execute(db)
}
