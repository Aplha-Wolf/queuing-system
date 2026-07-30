import gleam/list
import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html.{div as html_div, li as html_li, ul as html_ul}
import ui/kit.{text}
import ui/theme/theme.{device_to_class}
import ui/theme/types.{type Device, Mobile, Web}

pub type Model(msg) {
  Model(
    items: List(Element(msg)),
    device: Device,
    bordered: Bool,
    extra_class: String,
  )
}

pub fn init(
  items: List(Element(msg)),
  device: Device,
  bordered: Bool,
  extra_class: String,
) -> Model(msg) {
  Model(
    items: items,
    device: device,
    bordered: bordered,
    extra_class: extra_class,
  )
}

pub fn view(model: Model(msg)) -> Element(msg) {
  let border_class = case model.bordered {
    True -> "divide-y divide-gray-700"
    False -> ""
  }

  let device_class = device_to_class(model.device)

  let combined_class =
    "flex flex-col "
    <> border_class
    <> " "
    <> device_class
    <> " "
    <> model.extra_class

  let list_items =
    list.map(model.items, fn(item: Element(msg)) {
      html_li([class("py-2 px-3 text-white text-sm")], [item])
    })

  html_div([class(combined_class)], [html_ul([], list_items)])
}

pub fn list(items: List(Element(msg))) -> Element(msg) {
  view(init(items, Web, False, ""))
}

pub fn list_bordered(items: List(Element(msg))) -> Element(msg) {
  view(init(items, Web, True, ""))
}

pub fn list_custom(
  items: List(Element(msg)),
  device: Device,
  bordered: Bool,
  extra_class: String,
) -> Element(msg) {
  view(init(items, device, bordered, extra_class))
}

pub fn text_list(items: List(String)) -> Element(msg) {
  let elements = list.map(items, fn(item: String) { text(item) })
  view(init(elements, Web, False, ""))
}

pub fn text_list_bordered(items: List(String)) -> Element(msg) {
  let elements = list.map(items, fn(item: String) { text(item) })
  view(init(elements, Web, True, ""))
}

pub fn list_mobile(items: List(Element(msg))) -> Element(msg) {
  view(init(items, Mobile, False, ""))
}
