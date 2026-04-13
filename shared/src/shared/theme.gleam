import gleam/dynamic/decode
import gleam/json
import gleam/list

pub type Theme {
  Theme(
    id: Int,
    name: String,
    display_name: String,
    description: String,
    is_active: Bool,
    is_dark: Bool,
  )
}

pub type ThemeColor {
  ThemeColor(token: String, light_value: String, dark_value: String)
}

pub type ThemeWithColors {
  ThemeWithColors(theme: Theme, colors: List(ThemeColor))
}

pub fn decoder() -> decode.Decoder(Theme) {
  use id <- decode.field("id", decode.int)
  use name <- decode.field("name", decode.string)
  use display_name <- decode.field("display_name", decode.string)
  use description <- decode.field("description", decode.string)
  use is_active <- decode.field("is_active", decode.bool)
  use is_dark <- decode.field("is_dark", decode.bool)
  decode.success(Theme(
    id:,
    name:,
    display_name:,
    description:,
    is_active:,
    is_dark:,
  ))
}

pub fn color_decoder() -> decode.Decoder(ThemeColor) {
  use token <- decode.field("token", decode.string)
  use light_value <- decode.field("light_value", decode.string)
  use dark_value <- decode.field("dark_value", decode.string)
  decode.success(ThemeColor(token:, light_value:, dark_value:))
}

pub fn theme_with_colors_decoder() -> decode.Decoder(ThemeWithColors) {
  use theme <- decode.field("theme", decoder())
  use colors <- decode.field("colors", decode.list(color_decoder()))
  decode.success(ThemeWithColors(theme:, colors:))
}

pub fn to_json(theme: Theme) -> json.Json {
  let Theme(id:, name:, display_name:, description:, is_active:, is_dark:) =
    theme
  json.object([
    #("id", json.int(id)),
    #("name", json.string(name)),
    #("display_name", json.string(display_name)),
    #("description", json.string(description)),
    #("is_active", json.bool(is_active)),
    #("is_dark", json.bool(is_dark)),
  ])
}

pub fn color_to_json(color: ThemeColor) -> json.Json {
  let ThemeColor(token:, light_value:, dark_value:) = color
  json.object([
    #("token", json.string(token)),
    #("light_value", json.string(light_value)),
    #("dark_value", json.string(dark_value)),
  ])
}

pub fn theme_with_colors_to_json(twc: ThemeWithColors) -> json.Json {
  let ThemeWithColors(theme:, colors:) = twc
  json.object([
    #("theme", to_json(theme)),
    #("colors", json.preprocessed_array(list.map(colors, color_to_json))),
  ])
}

pub type ListThemesResponse {
  ListThemesResponse(count: Int, themes: List(Theme))
}

pub fn list_themes_decoder() -> decode.Decoder(ListThemesResponse) {
  use count <- decode.field("count", decode.int)
  use themes <- decode.field("themes", decode.list(decoder()))
  decode.success(ListThemesResponse(count:, themes:))
}

pub type ActivateThemeResult {
  ActivateThemeResult(message: String)
}

pub fn activate_result_decoder() -> decode.Decoder(ActivateThemeResult) {
  use message <- decode.field("message", decode.string)
  decode.success(ActivateThemeResult(message:))
}
