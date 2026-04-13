import * as $attribute from "../../lustre/lustre/attribute.mjs";
import * as $element from "../../lustre/lustre/element.mjs";
import { text as lelem_text } from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList, prepend as listPrepend } from "../gleam.mjs";

export function div(class_name, children) {
  return $html.div(toList([$attribute.class$(class_name)]), children);
}

export function h1(class_name, children) {
  return $html.h1(toList([$attribute.class$(class_name)]), children);
}

export function h2(class_name, children) {
  return $html.h2(toList([$attribute.class$(class_name)]), children);
}

export function h3(class_name, children) {
  return $html.h3(toList([$attribute.class$(class_name)]), children);
}

export function p(class_name, children) {
  return $html.p(toList([$attribute.class$(class_name)]), children);
}

export function span(class_name, children) {
  return $html.span(toList([$attribute.class$(class_name)]), children);
}

export function text(content) {
  return lelem_text(content);
}

export function section(class_name, children) {
  return $html.section(toList([$attribute.class$(class_name)]), children);
}

export function header_el(class_name, children) {
  return $html.header(toList([$attribute.class$(class_name)]), children);
}

export function footer_el(class_name, children) {
  return $html.footer(toList([$attribute.class$(class_name)]), children);
}

export function main_el(class_name, children) {
  return $html.main(toList([$attribute.class$(class_name)]), children);
}

export function aside(class_name, children) {
  return $html.aside(toList([$attribute.class$(class_name)]), children);
}

export function nav(class_name, children) {
  return $html.nav(toList([$attribute.class$(class_name)]), children);
}

export function article(class_name, children) {
  return $html.article(toList([$attribute.class$(class_name)]), children);
}

export function ul(class_name, children) {
  return $html.ul(toList([$attribute.class$(class_name)]), children);
}

export function ol(class_name, children) {
  return $html.ol(toList([$attribute.class$(class_name)]), children);
}

export function li(class_name, children) {
  return $html.li(toList([$attribute.class$(class_name)]), children);
}

export function div_with_style(class_name, style_value, children) {
  return $html.div(
    toList([$attribute.class$(class_name), $attribute.style("", style_value)]),
    children,
  );
}

export function div_with_attrs(attrs, children) {
  return $html.div(attrs, children);
}

export function div_with_class_and_style(
  class_name,
  style_value,
  extra_attrs,
  children
) {
  return $html.div(
    listPrepend(
      $attribute.class$(class_name),
      listPrepend($attribute.style("", style_value), extra_attrs),
    ),
    children,
  );
}

export function span_with_attrs(attrs, children) {
  return $html.span(attrs, children);
}
