import * as $string from "../../gleam_stdlib/gleam/string.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$, disabled } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { button as html_button } from "../../lustre/lustre/element/html.mjs";
import * as $event from "../../lustre/lustre/event.mjs";
import { on_click } from "../../lustre/lustre/event.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class, size_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";

export class ButtonConfig extends $CustomType {
  constructor(label, variant, size, device, is_disabled, extra_class, background_color, text_color, on_click) {
    super();
    this.label = label;
    this.variant = variant;
    this.size = size;
    this.device = device;
    this.is_disabled = is_disabled;
    this.extra_class = extra_class;
    this.background_color = background_color;
    this.text_color = text_color;
    this.on_click = on_click;
  }
}
export const ButtonConfig$ButtonConfig = (label, variant, size, device, is_disabled, extra_class, background_color, text_color, on_click) =>
  new ButtonConfig(label,
  variant,
  size,
  device,
  is_disabled,
  extra_class,
  background_color,
  text_color,
  on_click);
export const ButtonConfig$isButtonConfig = (value) =>
  value instanceof ButtonConfig;
export const ButtonConfig$ButtonConfig$label = (value) => value.label;
export const ButtonConfig$ButtonConfig$0 = (value) => value.label;
export const ButtonConfig$ButtonConfig$variant = (value) => value.variant;
export const ButtonConfig$ButtonConfig$1 = (value) => value.variant;
export const ButtonConfig$ButtonConfig$size = (value) => value.size;
export const ButtonConfig$ButtonConfig$2 = (value) => value.size;
export const ButtonConfig$ButtonConfig$device = (value) => value.device;
export const ButtonConfig$ButtonConfig$3 = (value) => value.device;
export const ButtonConfig$ButtonConfig$is_disabled = (value) =>
  value.is_disabled;
export const ButtonConfig$ButtonConfig$4 = (value) => value.is_disabled;
export const ButtonConfig$ButtonConfig$extra_class = (value) =>
  value.extra_class;
export const ButtonConfig$ButtonConfig$5 = (value) => value.extra_class;
export const ButtonConfig$ButtonConfig$background_color = (value) =>
  value.background_color;
export const ButtonConfig$ButtonConfig$6 = (value) => value.background_color;
export const ButtonConfig$ButtonConfig$text_color = (value) => value.text_color;
export const ButtonConfig$ButtonConfig$7 = (value) => value.text_color;
export const ButtonConfig$ButtonConfig$on_click = (value) => value.on_click;
export const ButtonConfig$ButtonConfig$8 = (value) => value.on_click;

export function build(config) {
  let size_class = size_to_class(config.size);
  let device_class = device_to_class(config.device);
  let _block;
  let $ = config.is_disabled;
  if ($) {
    _block = "opacity-50 cursor-not-allowed";
  } else {
    _block = "cursor-pointer";
  }
  let disabled_class = _block;
  let _block$1;
  let _pipe = $string.join(
    toList([size_class, device_class, disabled_class, config.extra_class]),
    " ",
  );
  _block$1 = $string.trim(_pipe);
  let combined_class = _block$1;
  let _pipe$1 = toList([
    class$(combined_class),
    disabled(config.is_disabled),
    on_click(config.on_click),
    $attribute.style("background-color", config.background_color),
    $attribute.style("color", config.text_color),
  ]);
  return html_button(
    _pipe$1,
    toList([
      (() => {
        let _pipe$2 = config.label;
        return $element.text(_pipe$2);
      })(),
    ]),
  );
}

export function view(model) {
  return build(model);
}

export function button(
  label,
  variant,
  size,
  device,
  is_disabled,
  extra_class,
  background_color,
  text_color,
  on_click
) {
  let _pipe = new ButtonConfig(
    label,
    variant,
    size,
    device,
    is_disabled,
    extra_class,
    background_color,
    text_color,
    on_click,
  );
  return build(_pipe);
}
