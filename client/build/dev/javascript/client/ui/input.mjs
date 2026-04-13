import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$, placeholder, type_, value } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div, input as html_input, label } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class, input_type_to_string, size_to_text_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Email, Md, Mobile, Password, Text, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(label, placeholder, input_type, value, size, device) {
    super();
    this.label = label;
    this.placeholder = placeholder;
    this.input_type = input_type;
    this.value = value;
    this.size = size;
    this.device = device;
  }
}
export const Model$Model = (label, placeholder, input_type, value, size, device) =>
  new Model(label, placeholder, input_type, value, size, device);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$label = (value) => value.label;
export const Model$Model$0 = (value) => value.label;
export const Model$Model$placeholder = (value) => value.placeholder;
export const Model$Model$1 = (value) => value.placeholder;
export const Model$Model$input_type = (value) => value.input_type;
export const Model$Model$2 = (value) => value.input_type;
export const Model$Model$value = (value) => value.value;
export const Model$Model$3 = (value) => value.value;
export const Model$Model$size = (value) => value.size;
export const Model$Model$4 = (value) => value.size;
export const Model$Model$device = (value) => value.device;
export const Model$Model$5 = (value) => value.device;

export class InputChanged extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}
export const Msg$InputChanged = ($0, $1) => new InputChanged($0, $1);
export const Msg$isInputChanged = (value) => value instanceof InputChanged;
export const Msg$InputChanged$0 = (value) => value[0];
export const Msg$InputChanged$1 = (value) => value[1];

export function init(label, placeholder, input_type, value, size, device) {
  return new Model(label, placeholder, input_type, value, size, device);
}

export function update(model, msg) {
  let new_value = msg[1];
  return new Model(
    model.label,
    model.placeholder,
    model.input_type,
    new_value,
    model.size,
    model.device,
  );
}

export function view(model) {
  let _block;
  let _pipe = model.size;
  _block = size_to_text_class(_pipe);
  let size_class = _block;
  let _block$1;
  let _pipe$1 = model.device;
  _block$1 = device_to_class(_pipe$1);
  let device_class = _block$1;
  let _block$2;
  let _pipe$2 = model.input_type;
  _block$2 = input_type_to_string(_pipe$2);
  let type_str = _block$2;
  let wrapper_class = "flex flex-col gap-2 mb-4 " + device_class;
  let label_class = "text-sm font-medium text-gray-700 dark:text-gray-300 " + size_class;
  let input_class = "p-2 border border-gray-300 dark:border-gray-600 rounded bg-white dark:bg-gray-800 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-blue-500 " + size_class;
  let _pipe$3 = toList([
    (() => {
      let _pipe$3 = wrapper_class;
      return class$(_pipe$3);
    })(),
  ]);
  return div(
    _pipe$3,
    toList([
      (() => {
        let _pipe$4 = toList([
          (() => {
            let _pipe$4 = label_class;
            return class$(_pipe$4);
          })(),
        ]);
        return label(
          _pipe$4,
          toList([
            (() => {
              let _pipe$5 = model.label;
              return $element.text(_pipe$5);
            })(),
          ]),
        );
      })(),
      html_input(
        toList([
          (() => {
            let _pipe$4 = type_str;
            return type_(_pipe$4);
          })(),
          (() => {
            let _pipe$4 = model.placeholder;
            return placeholder(_pipe$4);
          })(),
          (() => {
            let _pipe$4 = model.value;
            return value(_pipe$4);
          })(),
          (() => {
            let _pipe$4 = input_class;
            return class$(_pipe$4);
          })(),
        ]),
      ),
    ]),
  );
}

export function text_input(label, placeholder) {
  return view(init(label, placeholder, new Text(), "", new Md(), new Web()));
}

export function text_input_with_size(label, placeholder, size) {
  return view(init(label, placeholder, new Text(), "", size, new Web()));
}

export function text_input_mobile(label, placeholder, size) {
  return view(init(label, placeholder, new Text(), "", size, new Mobile()));
}

export function password_input(label, placeholder) {
  return view(init(label, placeholder, new Password(), "", new Md(), new Web()));
}

export function email_input(label, placeholder) {
  return view(init(label, placeholder, new Email(), "", new Md(), new Web()));
}
