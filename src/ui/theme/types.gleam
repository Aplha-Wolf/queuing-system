pub type ComponentColors {
  ComponentColors(
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

pub type ThemeState {
  ThemeState(colors: ComponentColors, is_loading: Bool)
}

pub type Size {
  Xs
  Sm
  Md
  Lg
  Xl
}

pub type Device {
  Web
  Mobile
}

pub type Variant {
  Primary
  Secondary
  Danger
  Success
  Outline
}

pub type InputType {
  Text
  Password
  Email
  Number
  Tel
  Url
}

pub type ContainerSize {
  ContainerXs
  ContainerSm
  ContainerMd
  ContainerLg
  ContainerXl
  ContainerFull
}

pub fn default_component_colors() -> ComponentColors {
  ComponentColors(
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
