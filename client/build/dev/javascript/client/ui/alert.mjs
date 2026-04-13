import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $lustre_elem from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $kit from "../ui/kit.mjs";
import { text } from "../ui/kit.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Danger, Mobile, Success, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(message, variant, device, dismissible, extra_class) {
    super();
    this.message = message;
    this.variant = variant;
    this.device = device;
    this.dismissible = dismissible;
    this.extra_class = extra_class;
  }
}
export const Model$Model = (message, variant, device, dismissible, extra_class) =>
  new Model(message, variant, device, dismissible, extra_class);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$message = (value) => value.message;
export const Model$Model$0 = (value) => value.message;
export const Model$Model$variant = (value) => value.variant;
export const Model$Model$1 = (value) => value.variant;
export const Model$Model$device = (value) => value.device;
export const Model$Model$2 = (value) => value.device;
export const Model$Model$dismissible = (value) => value.dismissible;
export const Model$Model$3 = (value) => value.dismissible;
export const Model$Model$extra_class = (value) => value.extra_class;
export const Model$Model$4 = (value) => value.extra_class;

export function init(message, variant, device, dismissible, extra_class) {
  return new Model(message, variant, device, dismissible, extra_class);
}

export function view(model) {
  let _block;
  let $ = model.variant;
  if ($ instanceof Danger) {
    _block = "bg-red-100 border-red-400 text-red-700 dark:bg-red-900 dark:border-red-700 dark:text-red-200";
  } else if ($ instanceof Success) {
    _block = "bg-green-100 border-green-400 text-green-700 dark:bg-green-900 dark:border-green-700 dark:text-green-200";
  } else {
    _block = "bg-blue-100 border-blue-400 text-blue-700 dark:bg-blue-900 dark:border-blue-700 dark:text-blue-200";
  }
  let variant_class = _block;
  let device_class = device_to_class(model.device);
  let combined_class = (((("border-l-4 p-4 rounded " + variant_class) + " ") + device_class) + " ") + model.extra_class;
  return div(toList([class$(combined_class)]), toList([text(model.message)]));
}

export function alert(message, variant) {
  return view(init(message, variant, new Web(), false, ""));
}

export function error(message) {
  return view(init(message, new Danger(), new Web(), false, ""));
}

export function success(message) {
  return view(init(message, new Success(), new Web(), false, ""));
}

export function alert_custom(message, variant, device, dismissible, extra_class) {
  return view(init(message, variant, device, dismissible, extra_class));
}

export function alert_mobile(message, variant) {
  return view(init(message, variant, new Mobile(), false, ""));
}
