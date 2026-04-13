import lustre/attribute.{class, type_}
import lustre/effect.{type Effect, map as effect_map}
import lustre/element as lustre_elem
import lustre/element/html
import lustre/event.{on_input}
import ui/theme/context as theme_context
import ui/theme/types as theme_types

pub type Model {
  Model(colors: theme_types.ComponentColors, is_loading: Bool, is_saving: Bool)
}

pub type Msg {
  ThemeMsg(theme_context.ThemeMsg)
  UpdateColor(String, String)
}

pub fn init() -> #(Model, Effect(Msg)) {
  let #(theme_state, effect) = theme_context.load_theme_colors()
  #(
    Model(
      colors: theme_state.colors,
      is_loading: theme_state.is_loading,
      is_saving: False,
    ),
    effect_map(effect, ThemeMsg),
  )
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    ThemeMsg(theme_msg) -> {
      let #(new_state, effect) =
        theme_context.update(
          theme_types.ThemeState(
            colors: model.colors,
            is_loading: model.is_loading,
          ),
          theme_msg,
        )
      #(
        Model(
          colors: new_state.colors,
          is_loading: new_state.is_loading,
          is_saving: model.is_saving,
        ),
        effect_map(effect, ThemeMsg),
      )
    }
    UpdateColor(key, value) -> {
      let update_result =
        theme_context.update(
          theme_types.ThemeState(colors: model.colors, is_loading: False),
          theme_context.UpdateColor(key, value),
        )
      #(
        Model(
          colors: update_color_field(model.colors, key, value),
          is_loading: model.is_loading,
          is_saving: True,
        ),
        effect_map(update_result.1, ThemeMsg),
      )
    }
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

pub fn view(model: Model) -> lustre_elem.Element(Msg) {
  let colors = model.colors
  html.div([class("p-6")], [
    html.h2([class("text-xl font-semibold mb-6 text-gray-900")], [
      lustre_elem.text("Theme Settings"),
    ]),
    html.div([class("grid grid-cols-1 md:grid-cols-2 gap-6")], [
      color_section("General", [
        color_field("Background", "background", colors.background),
        color_field("Text Primary", "text_primary", colors.text_primary),
        color_field("Text Secondary", "text_secondary", colors.text_secondary),
        color_field("Border", "border", colors.border),
      ]),
      color_section("Card", [
        color_field(
          "Card Background",
          "card_background",
          colors.card_background,
        ),
        color_field("Card Border", "card_border", colors.card_border),
        color_field("Card Text", "card_text", colors.card_text),
      ]),
      color_section("Button", [
        color_field("Button Primary", "button_primary", colors.button_primary),
        color_field(
          "Button Secondary",
          "button_secondary",
          colors.button_secondary,
        ),
      ]),
      color_section("Input", [
        color_field(
          "Input Background",
          "input_background",
          colors.input_background,
        ),
        color_field("Input Border", "input_border", colors.input_border),
        color_field("Input Text", "input_text", colors.input_text),
      ]),
      color_section("Header", [
        color_field(
          "Header Background",
          "header_background",
          colors.header_background,
        ),
        color_field("Header Text", "header_text", colors.header_text),
      ]),
      color_section("Status", [
        color_field("Success", "success", colors.success),
        color_field("Danger", "danger", colors.danger),
        color_field("Warning", "warning", colors.warning),
      ]),
    ]),
  ])
}

fn color_section(
  title: String,
  fields: List(lustre_elem.Element(Msg)),
) -> lustre_elem.Element(Msg) {
  html.div([class("bg-white p-4 rounded-lg border border-gray-200")], [
    html.h2([class("text-lg font-medium mb-3 text-gray-800")], [
      lustre_elem.text(title),
    ]),
    html.div([class("space-y-3")], fields),
  ])
}

fn color_field(
  label_text: String,
  key: String,
  _value: String,
) -> lustre_elem.Element(Msg) {
  html.div([class("flex items-center justify-between")], [
    html.label([class("text-sm text-gray-600")], [lustre_elem.text(label_text)]),
    html.input([
      type_("color"),
      class("w-12 h-8 rounded cursor-pointer border border-gray-300"),
      on_input(fn(e) { UpdateColor(key, e) }),
    ]),
  ])
}
