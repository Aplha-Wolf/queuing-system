import gleam/string
import ui/theme/types.{type ThemeState}

pub fn surface(state: ThemeState) -> String {
  "bg-[" <> state.colors.background <> "]"
}

pub fn surface_alt(state: ThemeState) -> String {
  "bg-[" <> state.colors.card_background <> "]"
}

pub fn text_primary(state: ThemeState) -> String {
  "text-[" <> state.colors.text_primary <> "]"
}

pub fn text_secondary(state: ThemeState) -> String {
  "text-[" <> state.colors.text_secondary <> "]"
}

pub fn border_color(state: ThemeState) -> String {
  "border-[" <> state.colors.border <> "]"
}

pub fn primary_bg(state: ThemeState) -> String {
  "bg-[" <> state.colors.button_primary <> "]"
}

pub fn primary_text(state: ThemeState) -> String {
  "text-[" <> state.colors.button_primary <> "]"
}

pub fn primary_hover(state: ThemeState) -> String {
  "hover:bg-[" <> state.colors.button_primary <> "]"
}

pub fn success_bg(state: ThemeState) -> String {
  "bg-[" <> state.colors.success <> "]"
}

pub fn danger_bg(state: ThemeState) -> String {
  "bg-[" <> state.colors.danger <> "]"
}

pub fn danger_text(state: ThemeState) -> String {
  "text-[" <> state.colors.danger <> "]"
}

pub fn warning_bg(state: ThemeState) -> String {
  "bg-[" <> state.colors.warning <> "]"
}

pub fn secondary_bg(state: ThemeState) -> String {
  "bg-[" <> state.colors.button_secondary <> "]"
}

pub fn layout_classes(state: ThemeState) -> String {
  string.join([surface(state), text_primary(state), "min-h-screen"], " ")
}

pub fn card_classes(state: ThemeState) -> String {
  string.join(
    [
      "rounded-lg",
      "p-6",
      border_color(state),
      surface_alt(state),
      text_primary(state),
    ],
    " ",
  )
}

pub fn section_classes(state: ThemeState) -> String {
  string.join(
    ["p-4", surface_alt(state), border_color(state), "rounded-lg"],
    " ",
  )
}
