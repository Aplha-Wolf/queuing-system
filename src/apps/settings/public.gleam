import gleam/list
import pog
import repository/settings/sql as settings_sql
import ui/theme/types.{type ComponentColors, ComponentColors, default_component_colors}

pub type SettingsService {
  SettingsService(db: pog.Connection)
}

pub fn settings_service(db: pog.Connection) -> SettingsService {
  SettingsService(db:)
}

pub fn get_colors(service: SettingsService) -> ComponentColors {
  case settings_sql.get_settings(service.db) {
    Ok(result) -> case list.first(result.rows) {
      Ok(row) -> ComponentColors(
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
      )
      _ -> default_component_colors()
    }
    _ -> default_component_colors()
  }
}

pub fn save_colors(service: SettingsService, colors: ComponentColors) -> Nil {
  let _ = settings_sql.update_settings(
    service.db,
    colors.background,
    colors.text_primary,
    colors.text_secondary,
    colors.card_background,
    colors.card_border,
    colors.card_text,
    colors.button_primary,
    colors.button_secondary,
    colors.input_background,
    colors.input_border,
    colors.input_text,
    colors.header_background,
    colors.header_text,
    colors.border,
    colors.success,
    colors.danger,
    colors.warning,
  )
  Nil
}
