import lustre/attribute.{class, placeholder, type_, value}
import lustre/element
import lustre/element/html.{div, input as html_input, label}
import ui/theme/theme.{device_to_class, input_type_to_string, size_to_text_class}
import ui/theme/types.{
  type Device, type InputType, type Size, Email, Md, Mobile, Password, Text, Web,
}

pub type Model(msg) {
  Model(
    label: String,
    placeholder: String,
    input_type: InputType,
    value: String,
    size: Size,
    device: Device,
  )
}

pub type Msg(msg) {
  InputChanged(msg, String)
}

pub fn init(
  label: String,
  placeholder: String,
  input_type: InputType,
  value: String,
  size: Size,
  device: Device,
) -> Model(msg) {
  Model(
    label: label,
    placeholder: placeholder,
    input_type: input_type,
    value: value,
    size: size,
    device: device,
  )
}

pub fn update(model: Model(msg), msg: Msg(msg)) -> Model(msg) {
  case msg {
    InputChanged(_, new_value) -> Model(..model, value: new_value)
  }
}

pub fn view(model: Model(msg)) -> element.Element(msg) {
  let size_class = model.size |> size_to_text_class()
  let device_class = model.device |> device_to_class()
  let type_str = model.input_type |> input_type_to_string()

  let wrapper_class = "flex flex-col gap-2 mb-4 " <> device_class
  let label_class =
    "text-sm font-medium text-gray-700 dark:text-gray-300 " <> size_class
  let input_class =
    "p-2 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 "
    <> size_class

  [wrapper_class |> class()]
  |> div([
    [label_class |> class()]
      |> label([model.label |> element.text()]),
    html_input([
      type_str |> type_(),
      model.placeholder |> placeholder(),
      model.value |> value(),
      input_class |> class(),
    ]),
  ])
}

pub fn text_input(label: String, placeholder: String) -> element.Element(msg) {
  view(init(label, placeholder, Text, "", Md, Web))
}

pub fn text_input_with_size(
  label: String,
  placeholder: String,
  size: Size,
) -> element.Element(msg) {
  view(init(label, placeholder, Text, "", size, Web))
}

pub fn text_input_mobile(
  label: String,
  placeholder: String,
  size: Size,
) -> element.Element(msg) {
  view(init(label, placeholder, Text, "", size, Mobile))
}

pub fn password_input(
  label: String,
  placeholder: String,
) -> element.Element(msg) {
  view(init(label, placeholder, Password, "", Md, Web))
}

pub fn email_input(label: String, placeholder: String) -> element.Element(msg) {
  view(init(label, placeholder, Email, "", Md, Web))
}
