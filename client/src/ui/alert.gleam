import lustre/attribute.{class}
import lustre/element as lustre_elem
import lustre/element/html.{div}
import ui/kit.{text}
import ui/theme/theme.{device_to_class}
import ui/theme/types.{type Device, type Variant, Danger, Mobile, Success, Web}

pub type Model(msg) {
  Model(
    message: String,
    variant: Variant,
    device: Device,
    dismissible: Bool,
    extra_class: String,
  )
}

pub fn init(
  message: String,
  variant: Variant,
  device: Device,
  dismissible: Bool,
  extra_class: String,
) -> Model(msg) {
  Model(
    message: message,
    variant: variant,
    device: device,
    dismissible: dismissible,
    extra_class: extra_class,
  )
}

pub fn view(model: Model(msg)) -> lustre_elem.Element(msg) {
  let variant_class = case model.variant {
    Danger ->
      "bg-red-100 border-red-400 text-red-700 dark:bg-red-900 dark:border-red-700 dark:text-red-200"
    Success ->
      "bg-green-100 border-green-400 text-green-700 dark:bg-green-900 dark:border-green-700 dark:text-green-200"
    _ ->
      "bg-blue-100 border-blue-400 text-blue-700 dark:bg-blue-900 dark:border-blue-700 dark:text-blue-200"
  }

  let device_class = device_to_class(model.device)

  let combined_class =
    "border-l-4 p-4 rounded "
    <> variant_class
    <> " "
    <> device_class
    <> " "
    <> model.extra_class

  div([class(combined_class)], [text(model.message)])
}

pub fn alert(message: String, variant: Variant) -> lustre_elem.Element(msg) {
  view(init(message, variant, Web, False, ""))
}

pub fn error(message: String) -> lustre_elem.Element(msg) {
  view(init(message, Danger, Web, False, ""))
}

pub fn success(message: String) -> lustre_elem.Element(msg) {
  view(init(message, Success, Web, False, ""))
}

pub fn alert_custom(
  message: String,
  variant: Variant,
  device: Device,
  dismissible: Bool,
  extra_class: String,
) -> lustre_elem.Element(msg) {
  view(init(message, variant, device, dismissible, extra_class))
}

pub fn alert_mobile(
  message: String,
  variant: Variant,
) -> lustre_elem.Element(msg) {
  view(init(message, variant, Mobile, False, ""))
}
