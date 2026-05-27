import lustre/attribute.{class}
import lustre/element
import lustre/element/html.{div, h2}
import ui/theme/theme.{device_to_class, size_to_text_class}
import ui/theme/types.{type Device, type Size, Md, Web}

pub type Model(msg) {
  Model(
    title: String,
    content: List(element.Element(msg)),
    footer: List(element.Element(msg)),
    elevated: Bool,
    size: Size,
    device: Device,
  )
}

pub type Msg(msg) {
  Nil
}

pub fn init(
  title: String,
  content: List(element.Element(msg)),
  footer: List(element.Element(msg)),
  elevated: Bool,
  size: Size,
  device: Device,
) -> Model(msg) {
  Model(
    title: title,
    content: content,
    footer: footer,
    elevated: elevated,
    size: size,
    device: device,
  )
}

pub fn view(model: Model(msg)) -> element.Element(msg) {
  let elevated_class = case model.elevated {
    True -> "shadow-lg"
    False -> ""
  }

  let size_class = model.size |> size_to_text_class()
  let device_class = model.device |> device_to_class()

  let base_class =
    "border rounded-lg p-6 bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700 "
    <> elevated_class
    <> " "
    <> device_class

  let title_class =
    "text-xl font-semibold mb-4 text-gray-900 dark:text-gray-100 " <> size_class

  [base_class |> class()]
  |> div([
    [title_class |> class()]
      |> h2([model.title |> element.text()]),
    ["mb-4" |> class()]
      |> div(model.content),
    ["pt-4 border-t border-gray-200 dark:border-gray-700" |> class()]
      |> div(model.footer),
  ])
}

pub fn card(
  title: String,
  content: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(title, content, [], False, Md, Web))
}

pub fn card_with_size(
  title: String,
  content: List(element.Element(msg)),
  size: Size,
  device: Device,
) -> element.Element(msg) {
  view(init(title, content, [], False, size, device))
}

pub fn card_with_footer(
  title: String,
  content: List(element.Element(msg)),
  footer: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(title, content, footer, False, Md, Web))
}

pub fn card_elevated(
  title: String,
  content: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(title, content, [], True, Md, Web))
}
