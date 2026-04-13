import gleam/http/response.{type Response}
import rsvp

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

pub type ThemeMsg {
  LoadedColors(Result(Response(String), rsvp.Error))
  UpdateColor(String, String)
  SavedColors(Result(Response(String), rsvp.Error))
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
