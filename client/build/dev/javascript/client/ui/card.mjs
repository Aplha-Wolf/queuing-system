import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div, h2 } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class, size_to_text_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Md, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(title, content, footer, elevated, size, device) {
    super();
    this.title = title;
    this.content = content;
    this.footer = footer;
    this.elevated = elevated;
    this.size = size;
    this.device = device;
  }
}
export const Model$Model = (title, content, footer, elevated, size, device) =>
  new Model(title, content, footer, elevated, size, device);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$title = (value) => value.title;
export const Model$Model$0 = (value) => value.title;
export const Model$Model$content = (value) => value.content;
export const Model$Model$1 = (value) => value.content;
export const Model$Model$footer = (value) => value.footer;
export const Model$Model$2 = (value) => value.footer;
export const Model$Model$elevated = (value) => value.elevated;
export const Model$Model$3 = (value) => value.elevated;
export const Model$Model$size = (value) => value.size;
export const Model$Model$4 = (value) => value.size;
export const Model$Model$device = (value) => value.device;
export const Model$Model$5 = (value) => value.device;

export class Nil extends $CustomType {}
export const Msg$Nil = () => new Nil();
export const Msg$isNil = (value) => value instanceof Nil;

export function init(title, content, footer, elevated, size, device) {
  return new Model(title, content, footer, elevated, size, device);
}

export function view(model) {
  let _block;
  let $ = model.elevated;
  if ($) {
    _block = "shadow-lg";
  } else {
    _block = "";
  }
  let elevated_class = _block;
  let _block$1;
  let _pipe = model.size;
  _block$1 = size_to_text_class(_pipe);
  let size_class = _block$1;
  let _block$2;
  let _pipe$1 = model.device;
  _block$2 = device_to_class(_pipe$1);
  let device_class = _block$2;
  let base_class = (("border rounded-lg p-6 bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700 " + elevated_class) + " ") + device_class;
  let title_class = "text-xl font-semibold mb-4 text-gray-900 dark:text-gray-100 " + size_class;
  let _pipe$2 = toList([
    (() => {
      let _pipe$2 = base_class;
      return class$(_pipe$2);
    })(),
  ]);
  return div(
    _pipe$2,
    toList([
      (() => {
        let _pipe$3 = toList([
          (() => {
            let _pipe$3 = title_class;
            return class$(_pipe$3);
          })(),
        ]);
        return h2(
          _pipe$3,
          toList([
            (() => {
              let _pipe$4 = model.title;
              return $element.text(_pipe$4);
            })(),
          ]),
        );
      })(),
      (() => {
        let _pipe$3 = toList([
          (() => {
            let _pipe$3 = "mb-4";
            return class$(_pipe$3);
          })(),
        ]);
        return div(_pipe$3, model.content);
      })(),
      (() => {
        let _pipe$3 = toList([
          (() => {
            let _pipe$3 = "pt-4 border-t border-gray-200 dark:border-gray-700";
            return class$(_pipe$3);
          })(),
        ]);
        return div(_pipe$3, model.footer);
      })(),
    ]),
  );
}

export function card(title, content) {
  return view(init(title, content, toList([]), false, new Md(), new Web()));
}

export function card_with_size(title, content, size, device) {
  return view(init(title, content, toList([]), false, size, device));
}

export function card_with_footer(title, content, footer) {
  return view(init(title, content, footer, false, new Md(), new Web()));
}

export function card_elevated(title, content) {
  return view(init(title, content, toList([]), true, new Md(), new Web()));
}
