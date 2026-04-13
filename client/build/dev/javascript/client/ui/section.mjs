import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text as elem_text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div as html_div } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Md, Mobile, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(heading, content, size, device, extra_class) {
    super();
    this.heading = heading;
    this.content = content;
    this.size = size;
    this.device = device;
    this.extra_class = extra_class;
  }
}
export const Model$Model = (heading, content, size, device, extra_class) =>
  new Model(heading, content, size, device, extra_class);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$heading = (value) => value.heading;
export const Model$Model$0 = (value) => value.heading;
export const Model$Model$content = (value) => value.content;
export const Model$Model$1 = (value) => value.content;
export const Model$Model$size = (value) => value.size;
export const Model$Model$2 = (value) => value.size;
export const Model$Model$device = (value) => value.device;
export const Model$Model$3 = (value) => value.device;
export const Model$Model$extra_class = (value) => value.extra_class;
export const Model$Model$4 = (value) => value.extra_class;

export function init(heading, content, size, device, extra_class) {
  return new Model(heading, content, size, device, extra_class);
}

export function view(model) {
  let _block;
  let $ = model.size;
  if ($ instanceof Md) {
    _block = "text-lg";
  } else {
    _block = "text-base";
  }
  let heading_size = _block;
  let device_class = device_to_class(model.device);
  let combined_class = (("flex flex-col p-4 bg-gray-800 border border-gray-700 rounded-lg " + device_class) + " ") + model.extra_class;
  return html_div(
    toList([class$(combined_class)]),
    toList([
      html_div(
        toList([class$(heading_size + " font-semibold text-white mb-3")]),
        toList([elem_text(model.heading)]),
      ),
      html_div(toList([class$("flex-1")]), model.content),
    ]),
  );
}

export function section(heading, content) {
  return view(init(heading, content, new Md(), new Web(), ""));
}

export function section_custom(heading, content, size, device, extra_class) {
  return view(init(heading, content, size, device, extra_class));
}

export function section_mobile(heading, content) {
  return view(init(heading, content, new Md(), new Mobile(), ""));
}
