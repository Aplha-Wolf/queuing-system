import apps/settings/public as settings_mod
import lustre/attribute.{class, type_}
import lustre/effect.{type Effect, none as effect_none}
import lustre/element.{type Element, none as element_none}
import lustre/element/html
import lustre/event.{on_input}
import ui/theme/types.{type ComponentColors, ComponentColors}

pub type Model {
  Model(
    colors: ComponentColors,
    is_loading: Bool,
    is_saving: Bool,
    message: String,
    settings_service: settings_mod.SettingsService,
  )
}

pub type Msg {
  UpdateColor(String, String)
  NoOp
}

pub type InitArgs {
  InitArgs(settings_service: settings_mod.SettingsService)
}

pub fn init(args: InitArgs) -> #(Model, Effect(Msg)) {
  let colors = settings_mod.get_colors(args.settings_service)

  #(
    Model(
      colors:,
      is_loading: False,
      is_saving: False,
      message: "",
      settings_service: args.settings_service,
    ),
    effect_none(),
  )
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    NoOp -> #(model, effect_none())
    UpdateColor(key, value) -> {
      let new_colors = update_color_field(model.colors, key, value)
      settings_mod.save_colors(model.settings_service, new_colors)
      #(
        Model(..model, colors: new_colors, is_saving: True, message: "Saved!"),
        effect_none(),
      )
    }
  }
}

fn update_color_field(
  colors: ComponentColors,
  key: String,
  value: String,
) -> ComponentColors {
  case key {
    "background" -> ComponentColors(..colors, background: value)
    "text_primary" -> ComponentColors(..colors, text_primary: value)
    "text_secondary" -> ComponentColors(..colors, text_secondary: value)
    "card_background" -> ComponentColors(..colors, card_background: value)
    "card_border" -> ComponentColors(..colors, card_border: value)
    "card_text" -> ComponentColors(..colors, card_text: value)
    "button_primary" -> ComponentColors(..colors, button_primary: value)
    "button_secondary" -> ComponentColors(..colors, button_secondary: value)
    "input_background" -> ComponentColors(..colors, input_background: value)
    "input_border" -> ComponentColors(..colors, input_border: value)
    "input_text" -> ComponentColors(..colors, input_text: value)
    "header_background" -> ComponentColors(..colors, header_background: value)
    "header_text" -> ComponentColors(..colors, header_text: value)
    "border" -> ComponentColors(..colors, border: value)
    "success" -> ComponentColors(..colors, success: value)
    "danger" -> ComponentColors(..colors, danger: value)
    "warning" -> ComponentColors(..colors, warning: value)
    _ -> colors
  }
}

pub fn view(model: Model) -> Element(Msg) {
  let colors = model.colors

  html.div([class("p-6")], [
    html.h2([class("text-xl font-semibold mb-6 text-[#f9fafb]")], [
      html.text("Theme Settings"),
    ]),
    case model.message {
      "" -> element_none()
      msg ->
        html.div([class("mb-4 p-2 bg-[#22c55e] text-white rounded text-sm")], [
          html.text(msg),
        ])
    },
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

fn color_section(title: String, fields: List(Element(Msg))) -> Element(Msg) {
  html.div([class("bg-[#374151] p-4 rounded-lg border border-[#4b5563]")], [
    html.h2([class("text-lg font-medium mb-3 text-[#f9fafb]")], [
      html.text(title),
    ]),
    html.div([class("space-y-3")], fields),
  ])
}

fn color_field(
  label_text: String,
  key: String,
  _value: String,
) -> Element(Msg) {
  html.div([class("flex items-center justify-between")], [
    html.label([class("text-sm text-[#9ca3af]")], [html.text(label_text)]),
    html.input([
      type_("color"),
      class("w-12 h-8 rounded cursor-pointer border border-[#4b5563]"),
      on_input(fn(e) { UpdateColor(key, e) }),
    ]),
  ])
}
