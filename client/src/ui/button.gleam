import gleam/string
import lustre/attribute.{class, disabled}
import lustre/element
import lustre/element/html.{button as html_button}
import lustre/event.{on_click}
import ui/theme/theme.{device_to_class, size_to_class}
import ui/theme/types.{type Device, type Size, type Variant}

pub type ButtonConfig(msg) {
  ButtonConfig(
    label: String,
    variant: Variant,
    size: Size,
    device: Device,
    is_disabled: Bool,
    extra_class: String,
    background_color: String,
    text_color: String,
    on_click: msg,
  )
}

pub type Model(msg) =
  ButtonConfig(msg)

pub fn build(config: ButtonConfig(msg)) -> element.Element(msg) {
  let size_class = size_to_class(config.size)
  let device_class = device_to_class(config.device)
  let disabled_class = case config.is_disabled {
    True -> "opacity-50 cursor-not-allowed"
    False -> "cursor-pointer"
  }

  let combined_class =
    string.join(
      [
        size_class,
        device_class,
        disabled_class,
        config.extra_class,
      ],
      " ",
    )
    |> string.trim

  [
    class(combined_class),
    disabled(config.is_disabled),
    on_click(config.on_click),
    attribute.style("background-color", config.background_color),
    attribute.style("color", config.text_color),
  ]
  |> html_button([config.label |> element.text()])
}

pub fn view(model: ButtonConfig(msg)) -> element.Element(msg) {
  build(model)
}

pub fn button(
  label: String,
  variant: Variant,
  size: Size,
  device: Device,
  is_disabled: Bool,
  extra_class: String,
  background_color: String,
  text_color: String,
  on_click: msg,
) -> element.Element(msg) {
  ButtonConfig(
    label: label,
    variant: variant,
    size: size,
    device: device,
    is_disabled: is_disabled,
    extra_class: extra_class,
    background_color: background_color,
    text_color: text_color,
    on_click: on_click,
  )
  |> build
}
