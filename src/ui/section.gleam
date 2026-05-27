import lustre/attribute.{class}
import lustre/element.{type Element, text as elem_text}
import lustre/element/html.{div as html_div}
import ui/theme/theme.{device_to_class}
import ui/theme/types.{type Device, type Size, Md, Mobile, Web}

pub type Model(msg) {
  Model(
    heading: String,
    content: List(Element(msg)),
    size: Size,
    device: Device,
    extra_class: String,
  )
}

pub fn init(
  heading: String,
  content: List(Element(msg)),
  size: Size,
  device: Device,
  extra_class: String,
) -> Model(msg) {
  Model(
    heading: heading,
    content: content,
    size: size,
    device: device,
    extra_class: extra_class,
  )
}

pub fn view(model: Model(msg)) -> Element(msg) {
  let heading_size = case model.size {
    Md -> "text-lg"
    _ -> "text-base"
  }

  let device_class = device_to_class(model.device)

  let combined_class =
    "flex flex-col p-4 bg-gray-800 border border-gray-700 rounded-lg "
    <> device_class
    <> " "
    <> model.extra_class

  html_div([class(combined_class)], [
    html_div([class(heading_size <> " font-semibold text-white mb-3")], [
      elem_text(model.heading),
    ]),
    html_div([class("flex-1")], model.content),
  ])
}

pub fn section(heading: String, content: List(Element(msg))) -> Element(msg) {
  view(init(heading, content, Md, Web, ""))
}

pub fn section_custom(
  heading: String,
  content: List(Element(msg)),
  size: Size,
  device: Device,
  extra_class: String,
) -> Element(msg) {
  view(init(heading, content, size, device, extra_class))
}

pub fn section_mobile(
  heading: String,
  content: List(Element(msg)),
) -> Element(msg) {
  view(init(heading, content, Md, Mobile, ""))
}
