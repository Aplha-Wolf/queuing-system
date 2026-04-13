import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div as html_div, li as html_li, ul as html_ul } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $kit from "../ui/kit.mjs";
import { text } from "../ui/kit.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Mobile, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(items, device, bordered, extra_class) {
    super();
    this.items = items;
    this.device = device;
    this.bordered = bordered;
    this.extra_class = extra_class;
  }
}
export const Model$Model = (items, device, bordered, extra_class) =>
  new Model(items, device, bordered, extra_class);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$items = (value) => value.items;
export const Model$Model$0 = (value) => value.items;
export const Model$Model$device = (value) => value.device;
export const Model$Model$1 = (value) => value.device;
export const Model$Model$bordered = (value) => value.bordered;
export const Model$Model$2 = (value) => value.bordered;
export const Model$Model$extra_class = (value) => value.extra_class;
export const Model$Model$3 = (value) => value.extra_class;

export function init(items, device, bordered, extra_class) {
  return new Model(items, device, bordered, extra_class);
}

export function list(items) {
  return view(init(items, new Web(), false, ""));
}

export function view(model) {
  let _block;
  let $ = model.bordered;
  if ($) {
    _block = "divide-y divide-gray-700";
  } else {
    _block = "";
  }
  let border_class = _block;
  let device_class = device_to_class(model.device);
  let combined_class = (((("flex flex-col " + border_class) + " ") + device_class) + " ") + model.extra_class;
  let list_items = $list.map(
    model.items,
    (item) => {
      return html_li(
        toList([class$("py-2 px-3 text-white text-sm")]),
        toList([item]),
      );
    },
  );
  return html_div(
    toList([class$(combined_class)]),
    toList([html_ul(toList([]), list_items)]),
  );
}

export function list_bordered(items) {
  return view(init(items, new Web(), true, ""));
}

export function list_custom(items, device, bordered, extra_class) {
  return view(init(items, device, bordered, extra_class));
}

export function text_list(items) {
  let elements = $list.map(items, (item) => { return text(item); });
  return view(init(elements, new Web(), false, ""));
}

export function text_list_bordered(items) {
  let elements = $list.map(items, (item) => { return text(item); });
  return view(init(elements, new Web(), true, ""));
}

export function list_mobile(items) {
  return view(init(items, new Mobile(), false, ""));
}
