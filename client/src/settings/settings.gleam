import lustre/attribute.{class}
import lustre/effect.{type Effect, map as effect_map}
import lustre/element as lustre_elem
import lustre/element/html
import settings/theme as theme_settings

pub type Model {
  Model(theme_model: theme_settings.Model)
}

pub type Msg {
  ThemeMsg(theme_settings.Msg)
}

pub fn init() -> #(Model, Effect(Msg)) {
  let #(theme_model, theme_effect) = theme_settings.init()
  #(Model(theme_model: theme_model), effect_map(theme_effect, ThemeMsg))
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    ThemeMsg(theme_msg) -> {
      let #(new_theme_model, effect) =
        theme_settings.update(model.theme_model, theme_msg)
      #(Model(theme_model: new_theme_model), effect_map(effect, ThemeMsg))
    }
  }
}

pub fn view(model: Model) -> lustre_elem.Element(Msg) {
  html.div([class("min-h-screen bg-gray-100 p-8")], [
    html.div([class("max-w-6xl mx-auto")], [
      header(),
      lustre_elem.map(theme_settings.view(model.theme_model), ThemeMsg),
    ]),
  ])
}

fn header() -> lustre_elem.Element(Msg) {
  html.h1([class("text-3xl font-bold mb-8 text-gray-900")], [
    lustre_elem.text("Theme Settings"),
  ])
}
