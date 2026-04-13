import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { div } from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme from "../ui/theme/theme.mjs";
import { container_size_to_class, device_to_class } from "../ui/theme/theme.mjs";
import * as $types from "../ui/theme/types.mjs";
import { ContainerMd, Mobile, Web } from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(size, centered, children, device) {
    super();
    this.size = size;
    this.centered = centered;
    this.children = children;
    this.device = device;
  }
}
export const Model$Model = (size, centered, children, device) =>
  new Model(size, centered, children, device);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$size = (value) => value.size;
export const Model$Model$0 = (value) => value.size;
export const Model$Model$centered = (value) => value.centered;
export const Model$Model$1 = (value) => value.centered;
export const Model$Model$children = (value) => value.children;
export const Model$Model$2 = (value) => value.children;
export const Model$Model$device = (value) => value.device;
export const Model$Model$3 = (value) => value.device;

export class Nil extends $CustomType {}
export const Msg$Nil = () => new Nil();
export const Msg$isNil = (value) => value instanceof Nil;

export function init(size, centered, children, device) {
  return new Model(size, centered, children, device);
}

export function view(model) {
  let _block;
  let _pipe = model.size;
  _block = container_size_to_class(_pipe);
  let size_class = _block;
  let _block$1;
  let $ = model.centered;
  if ($) {
    _block$1 = "flex justify-center items-center";
  } else {
    _block$1 = "";
  }
  let centered_class = _block$1;
  let _block$2;
  let _pipe$1 = model.device;
  _block$2 = device_to_class(_pipe$1);
  let device_class = _block$2;
  let full_class = (((("w-full mx-auto px-4 " + size_class) + " ") + centered_class) + " ") + device_class;
  let _pipe$2 = toList([
    (() => {
      let _pipe$2 = full_class;
      return class$(_pipe$2);
    })(),
  ]);
  return div(_pipe$2, model.children);
}

export function container(children) {
  return view(init(new ContainerMd(), false, children, new Web()));
}

export function container_with_size(size, children) {
  return view(init(size, false, children, new Web()));
}

export function container_mobile(size, children) {
  return view(init(size, false, children, new Mobile()));
}

export function container_centered(children) {
  return view(init(new ContainerMd(), true, children, new Web()));
}
