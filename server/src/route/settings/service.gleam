import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/settings/sql as settings_sql
import shared/route_settings as shared_settings

pub type SettingsError {
  DatabaseError(json.Json)
  NotFound
}

pub fn get_settings(
  db: pog.Connection,
) -> Result(shared_settings.Settings, SettingsError) {
  case settings_sql.get_settings(db) {
    Ok(x) -> {
      case list.first(x.rows) {
        Ok(row) -> {
          Ok(shared_settings.Settings(
            background: row.background,
            text_primary: row.text_primary,
            text_secondary: row.text_secondary,
            card_background: row.card_background,
            card_border: row.card_border,
            card_text: row.card_text,
            button_primary: row.button_primary,
            button_secondary: row.button_secondary,
            input_background: row.input_background,
            input_border: row.input_border,
            input_text: row.input_text,
            header_background: row.header_background,
            header_text: row.header_text,
            border: row.border,
            success: row.success,
            danger: row.danger,
            warning: row.warning,
          ))
        }
        Error(_) -> Error(NotFound)
      }
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn update_settings(
  db: pog.Connection,
  settings: shared_settings.Settings,
) -> Result(shared_settings.Settings, SettingsError) {
  case
    settings_sql.update_settings(
      db,
      settings.background,
      settings.text_primary,
      settings.text_secondary,
      settings.card_background,
      settings.card_border,
      settings.card_text,
      settings.button_primary,
      settings.button_secondary,
      settings.input_background,
      settings.input_border,
      settings.input_text,
      settings.header_background,
      settings.header_text,
      settings.border,
      settings.success,
      settings.danger,
      settings.warning,
    )
  {
    Ok(_) -> get_settings(db)
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn settings_to_json(settings: shared_settings.Settings) -> json.Json {
  json.object([
    #("background", json.string(settings.background)),
    #("text_primary", json.string(settings.text_primary)),
    #("text_secondary", json.string(settings.text_secondary)),
    #("card_background", json.string(settings.card_background)),
    #("card_border", json.string(settings.card_border)),
    #("card_text", json.string(settings.card_text)),
    #("button_primary", json.string(settings.button_primary)),
    #("button_secondary", json.string(settings.button_secondary)),
    #("input_background", json.string(settings.input_background)),
    #("input_border", json.string(settings.input_border)),
    #("input_text", json.string(settings.input_text)),
    #("header_background", json.string(settings.header_background)),
    #("header_text", json.string(settings.header_text)),
    #("border", json.string(settings.border)),
    #("success", json.string(settings.success)),
    #("danger", json.string(settings.danger)),
    #("warning", json.string(settings.warning)),
  ])
}

pub fn settings_error_to_json(error: SettingsError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    NotFound -> json.object([#("message", json.string("Settings not found"))])
  }
}
