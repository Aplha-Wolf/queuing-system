import lustre/attribute.{class}
import lustre/element.{type Element, text as elem_text}
import lustre/element/html.{span}
import ui/theme/theme.{device_to_class}
import ui/theme/types.{type Device, type Variant, Danger, Mobile, Primary, Web}

pub type Model(msg) {
  Model(
    label: String,
    variant: Variant,
    device: Device,
    pill: Bool,
    extra_class: String,
  )
}

pub fn init(
  label: String,
  variant: Variant,
  device: Device,
  pill: Bool,
  extra_class: String,
) -> Model(msg) {
  Model(
    label: label,
    variant: variant,
    device: device,
    pill: pill,
    extra_class: extra_class,
  )
}

pub fn view(model: Model(msg)) -> Element(msg) {
  let shape_class = case model.pill {
    True -> "rounded-full"
    False -> "rounded"
  }

  let device_class = device_to_class(model.device)

  let combined_class =
    "inline-flex items-center px-2.5 py-0.5 text-xs font-medium "
    <> " "
    <> shape_class
    <> " "
    <> device_class
    <> " "
    <> model.extra_class

  span([class(combined_class)], [elem_text(model.label)])
}

pub fn badge(label: String, variant: Variant) -> Element(msg) {
  view(init(label, variant, Web, False, ""))
}

pub fn badge_pill(label: String, variant: Variant) -> Element(msg) {
  view(init(label, variant, Web, True, ""))
}

pub fn badge_custom(
  label: String,
  variant: Variant,
  device: Device,
  pill: Bool,
  extra_class: String,
) -> Element(msg) {
  view(init(label, variant, device, pill, extra_class))
}

pub fn active() -> Element(msg) {
  view(init("ACTIVE", Primary, Web, True, ""))
}

pub fn inactive() -> Element(msg) {
  view(init("INACTIVE", Danger, Web, True, ""))
}

pub fn badge_mobile(label: String, variant: Variant) -> Element(msg) {
  view(init(label, variant, Mobile, False, ""))
}
