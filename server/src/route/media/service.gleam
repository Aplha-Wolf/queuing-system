import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/media/sql as media_sql
import shared/media as shared_media

pub type MediaError {
  DatabaseError(json.Json)
  NotFound
}

pub fn get_new_media(
  db: pog.Connection,
) -> Result(shared_media.Media, MediaError) {
  case media_sql.get_new_media(db) {
    Ok(x) if x.count == 1 -> Ok(getnewmediarow_to_media(x.rows))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
    _ -> Error(NotFound)
  }
}

fn getnewmediarow_to_media(
  media: List(media_sql.GetNewMediaRow),
) -> shared_media.Media {
  let assert Ok(row) = list.first(media)

  shared_media.Media(
    id: row.id,
    create_at: row.create_at,
    name: row.name,
    is_ads: row.is_ads,
    media_type: row.media_type,
    filename: row.filename,
    active: row.active,
  )
}

pub fn media_error_to_json(error: MediaError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    NotFound -> json.object([#("error", json.string("Media not found"))])
  }
}
