import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/theme/sql as theme_sql
import shared/theme as shared_theme

pub type ThemeError {
  DatabaseError(json.Json)
  NotFound
  UpdateFailed
}

pub type ThemeWithColorsResult {
  ThemeWithColorsResult(
    id: Int,
    name: String,
    display_name: String,
    description: String,
    is_active: Bool,
    is_dark: Bool,
    colors: List(shared_theme.ThemeColor),
  )
}

pub type ThemeListResult {
  ThemeListResult(count: Int, themes: List(shared_theme.Theme))
}

pub type ActivateResult {
  ActivateResult(message: String)
}

pub fn list_all_themes(
  db: pog.Connection,
) -> Result(ThemeListResult, ThemeError) {
  case theme_sql.list_themes(db) {
    Ok(x) -> {
      Ok(ThemeListResult(
        count: list.length(x.rows),
        themes: list.map(x.rows, row_to_theme),
      ))
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn row_to_theme(row: theme_sql.ListThemesRow) -> shared_theme.Theme {
  shared_theme.Theme(
    id: row.id,
    name: row.name,
    display_name: row.display_name,
    description: row.description,
    is_active: row.is_active,
    is_dark: row.is_dark,
  )
}

pub fn get_theme_by_id(
  db: pog.Connection,
  id: Int,
) -> Result(ThemeWithColorsResult, ThemeError) {
  case theme_sql.get_theme_by_id(db, id) {
    Ok(x) if x.count == 1 -> {
      case theme_sql.get_theme_colors(db, id) {
        Ok(colors_result) -> {
          let assert Ok(row) = list.first(x.rows)
          Ok(ThemeWithColorsResult(
            id: row.id,
            name: row.name,
            display_name: row.display_name,
            description: row.description,
            is_active: row.is_active,
            is_dark: row.is_dark,
            colors: list.map(colors_result.rows, color_row_to_color),
          ))
        }
        Error(err) ->
          Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
      }
    }
    Ok(_) -> Error(NotFound)
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn get_active_theme(
  db: pog.Connection,
) -> Result(ThemeWithColorsResult, ThemeError) {
  case theme_sql.get_active_theme(db) {
    Ok(x) if x.count == 1 -> {
      let assert Ok(row) = list.first(x.rows)
      case theme_sql.get_theme_colors(db, row.id) {
        Ok(colors_result) -> {
          Ok(ThemeWithColorsResult(
            id: row.id,
            name: row.name,
            display_name: row.display_name,
            description: row.description,
            is_active: row.is_active,
            is_dark: row.is_dark,
            colors: list.map(colors_result.rows, color_row_to_color),
          ))
        }
        Error(err) ->
          Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
      }
    }
    Ok(_) -> Error(NotFound)
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn color_row_to_color(
  row: theme_sql.GetThemeColorsRow,
) -> shared_theme.ThemeColor {
  shared_theme.ThemeColor(
    token: row.token,
    light_value: row.light_value,
    dark_value: row.dark_value,
  )
}

pub fn activate_theme(
  db: pog.Connection,
  id: Int,
) -> Result(ActivateResult, ThemeError) {
  case theme_sql.get_theme_by_id(db, id) {
    Ok(x) if x.count == 1 -> {
      case theme_sql.deactivate_all_themes(db) {
        Ok(_) -> {
          case theme_sql.activate_theme(db, id) {
            Ok(_) -> Ok(ActivateResult(message: "Theme activated successfully"))
            Error(err) ->
              Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
          }
        }
        Error(err) ->
          Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
      }
    }
    Ok(_) -> Error(NotFound)
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn theme_error_to_json(error: ThemeError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    NotFound -> json.object([#("message", json.string("Theme not found"))])
    UpdateFailed ->
      json.object([#("message", json.string("Failed to update theme"))])
  }
}

pub fn theme_list_to_json(result: ThemeListResult) -> json.Json {
  json.object([
    #("count", json.int(result.count)),
    #(
      "themes",
      json.preprocessed_array(list.map(result.themes, shared_theme.to_json)),
    ),
  ])
}

pub fn theme_with_colors_to_json(result: ThemeWithColorsResult) -> json.Json {
  json.object([
    #("id", json.int(result.id)),
    #("name", json.string(result.name)),
    #("display_name", json.string(result.display_name)),
    #("description", json.string(result.description)),
    #("is_active", json.bool(result.is_active)),
    #("is_dark", json.bool(result.is_dark)),
    #(
      "colors",
      json.preprocessed_array(list.map(
        result.colors,
        shared_theme.color_to_json,
      )),
    ),
  ])
}

pub fn activate_result_to_json(result: ActivateResult) -> json.Json {
  json.object([#("message", json.string(result.message))])
}
