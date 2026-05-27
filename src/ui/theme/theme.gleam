import ui/theme/types.{
  type ComponentColors, type ContainerSize, type Device, type InputType,
  type Size, ComponentColors as Colors, ContainerFull, ContainerLg, ContainerMd,
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

pub fn default_component_colors() -> ComponentColors {
  Colors(
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
