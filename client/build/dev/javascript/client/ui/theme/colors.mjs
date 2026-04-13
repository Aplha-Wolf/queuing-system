import * as $string from "../../../gleam_stdlib/gleam/string.mjs";
import { toList } from "../../gleam.mjs";
import * as $types from "../../ui/theme/types.mjs";

export function surface(state) {
  return ("bg-[" + state.colors.background) + "]";
}

export function surface_alt(state) {
  return ("bg-[" + state.colors.card_background) + "]";
}

export function text_primary(state) {
  return ("text-[" + state.colors.text_primary) + "]";
}

export function text_secondary(state) {
  return ("text-[" + state.colors.text_secondary) + "]";
}

export function border_color(state) {
  return ("border-[" + state.colors.border) + "]";
}

export function primary_bg(state) {
  return ("bg-[" + state.colors.button_primary) + "]";
}

export function primary_text(state) {
  return ("text-[" + state.colors.button_primary) + "]";
}

export function primary_hover(state) {
  return ("hover:bg-[" + state.colors.button_primary) + "]";
}

export function success_bg(state) {
  return ("bg-[" + state.colors.success) + "]";
}

export function danger_bg(state) {
  return ("bg-[" + state.colors.danger) + "]";
}

export function danger_text(state) {
  return ("text-[" + state.colors.danger) + "]";
}

export function warning_bg(state) {
  return ("bg-[" + state.colors.warning) + "]";
}

export function secondary_bg(state) {
  return ("bg-[" + state.colors.button_secondary) + "]";
}

export function layout_classes(state) {
  return $string.join(
    toList([surface(state), text_primary(state), "min-h-screen"]),
    " ",
  );
}

export function card_classes(state) {
  return $string.join(
    toList([
      "rounded-lg",
      "p-6",
      border_color(state),
      surface_alt(state),
      text_primary(state),
    ]),
    " ",
  );
}

export function section_classes(state) {
  return $string.join(
    toList(["p-4", surface_alt(state), border_color(state), "rounded-lg"]),
    " ",
  );
}
