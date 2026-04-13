import gleam/int
import lustre/attribute.{class}
import lustre/element
import lustre/element/html.{div}
import ui/theme/theme.{device_to_class}
import ui/theme/types.{type Device, type Size, Md, Mobile, Web}

pub type Model(msg) {
  Model(
    columns: Int,
    gap: Size,
    children: List(element.Element(msg)),
    size: Size,
    device: Device,
  )
}

pub type Msg(msg) {
  Nil
}

pub fn init(
  columns: Int,
  gap: Size,
  children: List(element.Element(msg)),
  size: Size,
  device: Device,
) -> Model(msg) {
  Model(
    columns: columns,
    gap: gap,
    children: children,
    size: size,
    device: device,
  )
}

pub fn view(model: Model(msg)) -> element.Element(msg) {
  let gap_str = case model.gap {
    Md -> "gap-4"
    _ -> "gap-2"
  }

  let cols_str = model.columns |> int.to_string()
  let device_class = model.device |> device_to_class()

  let full_class =
    "grid grid-cols-" <> cols_str <> " " <> gap_str <> " " <> device_class

  [full_class |> class()]
  |> div(model.children)
}

pub fn grid(
  columns: Int,
  children: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(columns, Md, children, Md, Web))
}

pub fn grid_with_size(
  columns: Int,
  gap: Size,
  size: Size,
  device: Device,
  children: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(columns, gap, children, size, device))
}

pub fn grid_mobile(
  columns: Int,
  children: List(element.Element(msg)),
) -> element.Element(msg) {
  view(init(columns, Md, children, Md, Mobile))
}
