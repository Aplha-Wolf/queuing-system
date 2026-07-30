import lustre/attribute.{class}
import lustre/element
import lustre/element/html.{div}
import ui/theme/theme.{container_size_to_class, device_to_class}
import ui/theme/types.{type ContainerSize, type Device, ContainerMd, Mobile, Web}

pub type Model(msg) {
  Model(
    size: ContainerSize,
    centered: Bool,
    children: List(element.Element(msg)),
    device: Device,
  )
}

pub type Msg(msg) {
  Nil
}

pub fn init(
  size: ContainerSize,
  centered: Bool,
  children: List(element.Element(msg)),
  device: Device,
) -> Model(msg) {
  Model(size: size, centered: centered, children: children, device: device)
}

pub fn view(model: Model(msg)) -> element.Element(msg) {
  let size_class = model.size |> container_size_to_class()
  let centered_class = case model.centered {
    True -> "flex justify-center items-center"
    False -> ""
  }
  let device_class = model.device |> device_to_class()

  let full_class =
    "w-full mx-auto px-4 "
    <> size_class
    <> " "
    <> centered_class
    <> " "
    <> device_class

  [full_class |> class()]
  |> div(model.children)
}

pub fn container(children: List(element.Element(msg))) -> element.Element(msg) {
  view(init(ContainerMd, False, children, Web))
}

pub fn container_with_size(
  size: ContainerSize,
  children: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(size, False, children, Web))
}

pub fn container_mobile(
  size: ContainerSize,
  children: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(size, False, children, Mobile))
}

pub fn container_centered(
  children: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(ContainerMd, True, children, Web))
}
