import gleam/json

pub type Settings {
  Settings(
    background: String,
    text_primary: String,
    text_secondary: String,
    card_background: String,
    card_border: String,
    card_text: String,
    button_primary: String,
    button_secondary: String,
    input_background: String,
    input_border: String,
    input_text: String,
    header_background: String,
    header_text: String,
    border: String,
    success: String,
    danger: String,
    warning: String,
  )
}

pub fn default_settings() -> Settings {
  Settings(
    background: "#1f2937",
    text_primary: "#f9fafb",
    text_secondary: "#9ca3af",
    card_background: "#374151",
    card_border: "#4b5563",
    card_text: "#f9fafb",
    button_primary: "#2563eb",
    button_secondary: "#4b5563",
    input_background: "#374151",
    input_border: "#4b5563",
    input_text: "#f9fafb",
    header_background: "#1e3a8a",
    header_text: "#f9fafb",
    border: "#4b5563",
    success: "#22c55e",
    danger: "#ef4444",
    warning: "#eab308",
  )
}

pub fn to_json(settings: Settings) -> json.Json {
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
