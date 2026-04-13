import api
import gleam/http/response.{type Response}
import gleam/json
import lustre/effect.{type Effect, none}
import rsvp
import ui/theme/theme
import ui/theme/types as theme_types

pub type ThemeMsg {
  LoadedColors(Result(Response(String), rsvp.Error))
  UpdateColor(String, String)
  SavedColors(Result(Response(String), rsvp.Error))
}

pub fn load_theme_colors() -> #(theme_types.ThemeState, Effect(ThemeMsg)) {
  #(
    theme_types.ThemeState(
      colors: theme.default_component_colors(),
      is_loading: True,
    ),
    fetch_colors(),
  )
}

pub fn update(
  state: theme_types.ThemeState,
  msg: ThemeMsg,
) -> #(theme_types.ThemeState, Effect(ThemeMsg)) {
  case msg {
    LoadedColors(Ok(response)) -> {
      case json.parse(response.body, using: theme.component_colors_decoder()) {
        Ok(colors) -> {
          apply_css_variables(colors)
          #(theme_types.ThemeState(colors: colors, is_loading: False), none())
        }
        Error(_) -> #(
          theme_types.ThemeState(
            colors: theme.default_component_colors(),
            is_loading: False,
          ),
          none(),
        )
      }
    }
    LoadedColors(Error(_)) -> #(
      theme_types.ThemeState(
        colors: theme.default_component_colors(),
        is_loading: False,
      ),
      none(),
    )
    UpdateColor(key, value) -> {
      let new_colors = update_color_field(state.colors, key, value)
      apply_css_variables(new_colors)
      #(
        theme_types.ThemeState(colors: new_colors, is_loading: state.is_loading),
        save_colors(new_colors),
      )
    }
    SavedColors(Ok(_response)) -> #(state, none())
    SavedColors(Error(_)) -> #(state, none())
  }
}

fn update_color_field(
  colors: theme_types.ComponentColors,
  key: String,
  value: String,
) -> theme_types.ComponentColors {
  case key {
    "background" -> theme_types.ComponentColors(..colors, background: value)
    "text_primary" -> theme_types.ComponentColors(..colors, text_primary: value)
    "text_secondary" ->
      theme_types.ComponentColors(..colors, text_secondary: value)
    "card_background" ->
      theme_types.ComponentColors(..colors, card_background: value)
    "card_border" -> theme_types.ComponentColors(..colors, card_border: value)
    "card_text" -> theme_types.ComponentColors(..colors, card_text: value)
    "button_primary" ->
      theme_types.ComponentColors(..colors, button_primary: value)
    "button_secondary" ->
      theme_types.ComponentColors(..colors, button_secondary: value)
    "input_background" ->
      theme_types.ComponentColors(..colors, input_background: value)
    "input_border" -> theme_types.ComponentColors(..colors, input_border: value)
    "input_text" -> theme_types.ComponentColors(..colors, input_text: value)
    "header_background" ->
      theme_types.ComponentColors(..colors, header_background: value)
    "header_text" -> theme_types.ComponentColors(..colors, header_text: value)
    "border" -> theme_types.ComponentColors(..colors, border: value)
    "success" -> theme_types.ComponentColors(..colors, success: value)
    "danger" -> theme_types.ComponentColors(..colors, danger: value)
    "warning" -> theme_types.ComponentColors(..colors, warning: value)
    _ -> colors
  }
}

@external(javascript, "../../lib/theme_ffi.ffi.js", "set_css_var")
fn set_css_var(name: String, value: String) -> Nil

fn apply_css_variables(colors: theme_types.ComponentColors) -> Nil {
  set_css_var("--background", colors.background)
  set_css_var("--text-primary", colors.text_primary)
  set_css_var("--text-secondary", colors.text_secondary)
  set_css_var("--card-background", colors.card_background)
  set_css_var("--card-border", colors.card_border)
  set_css_var("--card-text", colors.card_text)
  set_css_var("--button-primary", colors.button_primary)
  set_css_var("--button-secondary", colors.button_secondary)
  set_css_var("--input-background", colors.input_background)
  set_css_var("--input-border", colors.input_border)
  set_css_var("--input-text", colors.input_text)
  set_css_var("--header-background", colors.header_background)
  set_css_var("--header-text", colors.header_text)
  set_css_var("--border", colors.border)
  set_css_var("--success", colors.success)
  set_css_var("--danger", colors.danger)
  set_css_var("--warning", colors.warning)
  Nil
}

fn fetch_colors() -> Effect(ThemeMsg) {
  api.get("/api/settings/colors", rsvp.expect_ok_response(LoadedColors))
}

fn save_colors(colors: theme_types.ComponentColors) -> Effect(ThemeMsg) {
  api.put(
    "/api/settings/colors",
    theme.component_colors_to_json(colors),
    rsvp.expect_ok_response(SavedColors),
  )
}
