import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text as elem_text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { span } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Danger, Mobile, Primary, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(label, variant, device, pill, extra_class) {
    super();
    this.label = label;
    this.variant = variant;
    this.device = device;
    this.pill = pill;
    this.extra_class = extra_class;
  }
}
export const Model$Model = (label, variant, device, pill, extra_class) =>
  new Model(label, variant, device, pill, extra_class);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$label = (value) => value.label;
export const Model$Model$0 = (value) => value.label;
export const Model$Model$variant = (value) => value.variant;
export const Model$Model$1 = (value) => value.variant;
export const Model$Model$device = (value) => value.device;
export const Model$Model$2 = (value) => value.device;
export const Model$Model$pill = (value) => value.pill;
export const Model$Model$3 = (value) => value.pill;
export const Model$Model$extra_class = (value) => value.extra_class;
export const Model$Model$4 = (value) => value.extra_class;

export function init(label, variant, device, pill, extra_class) {
  return new Model(label, variant, device, pill, extra_class);
}

export function view(model) {
  let _block;
  let $ = model.pill;
  if ($) {
    _block = "rounded-full";
  } else {
    _block = "rounded";
  }
  let shape_class = _block;
  let device_class = device_to_class(model.device);
  let combined_class = ((((("inline-flex items-center px-2.5 py-0.5 text-xs font-medium " + " ") + shape_class) + " ") + device_class) + " ") + model.extra_class;
  return span(
    toList([class$(combined_class)]),
    toList([elem_text(model.label)]),
  );
}

export function badge(label, variant) {
  return view(init(label, variant, new Web(), false, ""));
}

export function badge_pill(label, variant) {
  return view(init(label, variant, new Web(), true, ""));
}

export function badge_custom(label, variant, device, pill, extra_class) {
  return view(init(label, variant, device, pill, extra_class));
}

export function active() {
  return view(init("ACTIVE", new Primary(), new Web(), true, ""));
}

export function inactive() {
  return view(init("INACTIVE", new Danger(), new Web(), true, ""));
}

export function badge_mobile(label, variant) {
  return view(init(label, variant, new Mobile(), false, ""));
}
