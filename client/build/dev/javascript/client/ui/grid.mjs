import * as $int from "../../gleam_stdlib/gleam/int.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { device_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { Md, Mobile, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(columns, gap, children, size, device) {
    super();
    this.columns = columns;
    this.gap = gap;
    this.children = children;
    this.size = size;
    this.device = device;
  }
}
export const Model$Model = (columns, gap, children, size, device) =>
  new Model(columns, gap, children, size, device);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$columns = (value) => value.columns;
export const Model$Model$0 = (value) => value.columns;
export const Model$Model$gap = (value) => value.gap;
export const Model$Model$1 = (value) => value.gap;
export const Model$Model$children = (value) => value.children;
export const Model$Model$2 = (value) => value.children;
export const Model$Model$size = (value) => value.size;
export const Model$Model$3 = (value) => value.size;
export const Model$Model$device = (value) => value.device;
export const Model$Model$4 = (value) => value.device;

export class Nil extends $CustomType {}
export const Msg$Nil = () => new Nil();
export const Msg$isNil = (value) => value instanceof Nil;

export function init(columns, gap, children, size, device) {
  return new Model(columns, gap, children, size, device);
}

export function view(model) {
  let _block;
  let $ = model.gap;
  if ($ instanceof Md) {
    _block = "gap-4";
  } else {
    _block = "gap-2";
  }
  let gap_str = _block;
  let _block$1;
  let _pipe = model.columns;
  _block$1 = $int.to_string(_pipe);
  let cols_str = _block$1;
  let _block$2;
  let _pipe$1 = model.device;
  _block$2 = device_to_class(_pipe$1);
  let device_class = _block$2;
  let full_class = (((("grid grid-cols-" + cols_str) + " ") + gap_str) + " ") + device_class;
  let _pipe$2 = toList([
    (() => {
      let _pipe$2 = full_class;
      return class$(_pipe$2);
    })(),
  ]);
  return div(_pipe$2, model.children);
}

export function grid(columns, children) {
  return view(init(columns, new Md(), children, new Md(), new Web()));
}

export function grid_with_size(columns, gap, size, device, children) {
  return view(init(columns, gap, children, size, device));
}

export function grid_mobile(columns, children) {
  return view(init(columns, new Md(), children, new Md(), new Mobile()));
}
