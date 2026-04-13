import api
import gleam/dynamic/decode
import gleam/http/response.{type Response}
import gleam/int
import gleam/json
import gleam/option.{type Option}
import lib/device
import lustre/attribute.{style}
import lustre/effect.{type Effect, none}
import lustre/element as lustre_elem
import rsvp
import shared/display as sdisplay
import ui/kit.{div, div_with_attrs, text}
import ui/section
import ui/theme/types

pub type Model {
  Model(
    display: Option(sdisplay.Display),
    code: String,
    loading: Bool,
    error: Option(String),
    device: types.Device,
  )
}

pub type Msg {
  LoadedDisplay(Result(Response(String), rsvp.Error))
}

pub fn init(code: String) -> #(Model, Effect(Msg)) {
  #(
    Model(
      display: option.None,
      code: code,
      loading: True,
      error: option.None,
      device: device.detect_device(),
    ),
    fetch_display(code),
  )
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    LoadedDisplay(Ok(response)) ->
      case json.parse(response.body, using: display_decoder()) {
        Ok(display) -> #(
          Model(..model, display: option.Some(display), loading: False),
          none(),
        )
        Error(_) -> #(
          Model(..model, loading: False, error: option.Some("Parse error")),
          none(),
        )
      }
    LoadedDisplay(Error(_)) -> #(
      Model(
        ..model,
        loading: False,
        error: option.Some("Failed to load display"),
      ),
      none(),
    )
  }
}

pub fn view(model: Model) -> lustre_elem.Element(Msg) {
  div("flex h-screen w-screen justify-between bg-black", [
    media_section(model),
    terminal_section(),
  ])
}

fn media_section(model: Model) -> lustre_elem.Element(Msg) {
  let width = case model.display {
    option.Some(d) -> int.to_string(d.media_width) <> "%"
    _ -> "50%"
  }

  div("flex h-full bg-black items-center justify-center", [
    div_with_attrs([style("width", width)], [
      div("text-white text-4xl font-bold", [
        text("DISPLAY: " <> model.code),
      ]),
    ]),
  ])
}

fn terminal_section() -> lustre_elem.Element(Msg) {
  div("flex h-full bg-black flex-col", [
    section.section("NOW SERVING", [
      div("flex items-center justify-center h-32", [
        text("Waiting for queue..."),
      ]),
    ]),
  ])
}

fn fetch_display(code: String) -> Effect(Msg) {
  api.get("/api/display/" <> code, rsvp.expect_ok_response(LoadedDisplay))
}

fn display_decoder() -> decode.Decoder(sdisplay.Display) {
  use id <- decode.field("id", decode.int)
  use code <- decode.field("code", decode.string)
  use name <- decode.field("name", decode.string)
  use active <- decode.field("active", decode.bool)
  use created_at <- decode.field("created_at", decode.string)
  use now_serving_size <- decode.field("now_serving_size", decode.int)
  use media_width <- decode.field("media_width", decode.int)
  use terminal_div_width <- decode.field("terminal_div_width", decode.int)
  use cols <- decode.field("cols", decode.int)
  use rows <- decode.field("rows", decode.int)
  use name_size <- decode.field("name_size", decode.int)
  use que_label_size <- decode.field("que_label_size", decode.int)
  use que_no_size <- decode.field("que_no_size", decode.int)
  use date_time_size <- decode.field("date_time_size", decode.int)
  decode.success(sdisplay.Display(
    id:,
    code:,
    name:,
    active:,
    created_at:,
    now_serving_size:,
    media_width:,
    terminal_div_width:,
    cols:,
    rows:,
    name_size:,
    que_label_size:,
    que_no_size:,
    date_time_size:,
  ))
}
