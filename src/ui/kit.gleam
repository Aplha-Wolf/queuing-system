import lustre/attribute
import lustre/element.{type Element, text as lelem_text}
import lustre/element/html

pub fn div(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class(class_name)], children)
}

pub fn h1(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.h1([attribute.class(class_name)], children)
}

pub fn h2(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.h2([attribute.class(class_name)], children)
}

pub fn h3(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.h3([attribute.class(class_name)], children)
}

pub fn p(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.p([attribute.class(class_name)], children)
}

pub fn span(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.span([attribute.class(class_name)], children)
}

pub fn text(content: String) -> Element(msg) {
  lelem_text(content)
}

pub fn section(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.section([attribute.class(class_name)], children)
}

pub fn header_el(
  class_name: String,
  children: List(Element(msg)),
) -> Element(msg) {
  html.header([attribute.class(class_name)], children)
}

pub fn footer_el(
  class_name: String,
  children: List(Element(msg)),
) -> Element(msg) {
  html.footer([attribute.class(class_name)], children)
}

pub fn main_el(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.main([attribute.class(class_name)], children)
}

pub fn aside(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.aside([attribute.class(class_name)], children)
}

pub fn nav(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.nav([attribute.class(class_name)], children)
}

pub fn article(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.article([attribute.class(class_name)], children)
}

pub fn ul(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.ul([attribute.class(class_name)], children)
}

pub fn ol(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.ol([attribute.class(class_name)], children)
}

pub fn li(class_name: String, children: List(Element(msg))) -> Element(msg) {
  html.li([attribute.class(class_name)], children)
}

pub fn div_with_style(
  class_name: String,
  style_value: String,
  children: List(Element(msg)),
) -> Element(msg) {
  html.div(
    [attribute.class(class_name), attribute.style("", style_value)],
    children,
  )
}

pub fn div_with_attrs(
  attrs: List(attribute.Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  html.div(attrs, children)
}

pub fn div_with_class_and_style(
  class_name: String,
  style_value: String,
  extra_attrs: List(attribute.Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  html.div(
    [
      attribute.class(class_name),
      attribute.style("", style_value),
      ..extra_attrs
    ],
    children,
  )
}

pub fn span_with_attrs(
  attrs: List(attribute.Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  html.span(attrs, children)
}
