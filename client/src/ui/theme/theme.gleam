import gleam/dynamic/decode
import gleam/json
import ui/theme/types.{
  type ComponentColors, type ContainerSize, type Device, type InputType,
  type Size, ComponentColors, ContainerFull, ContainerLg, ContainerMd,
  ContainerSm, ContainerXl, ContainerXs, Email, Lg, Md, Mobile, Number, Password,
  Sm, Tel, Text, Url, Web, Xl, Xs,
}

pub fn size_to_class(size: Size) -> String {
  case size {
    Xs -> "text-xs px-2 py-1"
    Sm -> "text-sm px-3 py-1.5"
    Md -> "text-base px-4 py-2"
    Lg -> "text-lg px-5 py-2.5"
    Xl -> "text-xl px-6 py-3"
  }
}

pub fn size_to_text_class(size: Size) -> String {
  case size {
    Xs -> "text-xs"
    Sm -> "text-sm"
    Md -> "text-base"
    Lg -> "text-lg"
    Xl -> "text-xl"
  }
}

pub fn device_to_class(device: Device) -> String {
  case device {
    Web -> "w-full"
    Mobile -> "w-full max-w-sm"
  }
}

pub fn input_type_to_string(input_type: InputType) -> String {
  case input_type {
    Text -> "text"
    Password -> "password"
    Email -> "email"
    Number -> "number"
    Tel -> "tel"
    Url -> "url"
  }
}

pub fn container_size_to_class(size: ContainerSize) -> String {
  case size {
    ContainerXs -> "max-w-xs"
    ContainerSm -> "max-w-sm"
    ContainerMd -> "max-w-md"
    ContainerLg -> "max-w-lg"
    ContainerXl -> "max-w-xl"
    ContainerFull -> "max-w-full"
  }
}

pub fn component_colors_decoder() -> decode.Decoder(ComponentColors) {
  use background <- decode.field("background", decode.string)
  use text_primary <- decode.field("text_primary", decode.string)
  use text_secondary <- decode.field("text_secondary", decode.string)
  use card_background <- decode.field("card_background", decode.string)
  use card_border <- decode.field("card_border", decode.string)
  use card_text <- decode.field("card_text", decode.string)
  use button_primary <- decode.field("button_primary", decode.string)
  use button_secondary <- decode.field("button_secondary", decode.string)
  use input_background <- decode.field("input_background", decode.string)
  use input_border <- decode.field("input_border", decode.string)
  use input_text <- decode.field("input_text", decode.string)
  use header_background <- decode.field("header_background", decode.string)
  use header_text <- decode.field("header_text", decode.string)
  use border <- decode.field("border", decode.string)
  use success <- decode.field("success", decode.string)
  use danger <- decode.field("danger", decode.string)
  use warning <- decode.field("warning", decode.string)
  decode.success(ComponentColors(
    background:,
    text_primary:,
    text_secondary:,
    card_background:,
    card_border:,
    card_text:,
    button_primary:,
    button_secondary:,
    input_background:,
    input_border:,
    input_text:,
    header_background:,
    header_text:,
    border:,
    success:,
    danger:,
    warning:,
  ))
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

pub fn component_colors_to_json(colors: ComponentColors) -> json.Json {
  let ComponentColors(
    background:,
    text_primary:,
    text_secondary:,
    card_background:,
    card_border:,
    card_text:,
    button_primary:,
    button_secondary:,
    input_background:,
    input_border:,
    input_text:,
    header_background:,
    header_text:,
    border:,
    success:,
    danger:,
    warning:,
  ) = colors
  json.object([
    #("background", json.string(background)),
    #("text_primary", json.string(text_primary)),
    #("text_secondary", json.string(text_secondary)),
    #("card_background", json.string(card_background)),
    #("card_border", json.string(card_border)),
    #("card_text", json.string(card_text)),
    #("button_primary", json.string(button_primary)),
    #("button_secondary", json.string(button_secondary)),
    #("input_background", json.string(input_background)),
    #("input_border", json.string(input_border)),
    #("input_text", json.string(input_text)),
    #("header_background", json.string(header_background)),
    #("header_text", json.string(header_text)),
    #("border", json.string(border)),
    #("success", json.string(success)),
    #("danger", json.string(danger)),
    #("warning", json.string(warning)),
  ])
}
