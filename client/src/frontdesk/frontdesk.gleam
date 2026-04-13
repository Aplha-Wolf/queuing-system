import api
import gleam/dynamic/decode
import gleam/http/response.{type Response}
import gleam/int
import gleam/json
import gleam/list
import gleam/option.{type Option}
import lib/device
import lustre/effect.{type Effect, none}
import lustre/element as lustre_elem
import rsvp
import shared/queue as sququeue
import ui/badge as ui_badge
import ui/card
import ui/kit.{div, text}
import ui/theme/types.{Success}

pub type Model {
  Model(
    queues: List(sququeue.Queue),
    code: String,
    loading: Bool,
    error: Option(String),
    device: types.Device,
  )
}

pub type Msg {
  LoadedQueues(Result(Response(String), rsvp.Error))
}

pub fn init(code: String) -> #(Model, Effect(Msg)) {
  #(
    Model(
      queues: [],
      code: code,
      loading: True,
      error: option.None,
      device: device.detect_device(),
    ),
    fetch_queues(code),
  )
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    LoadedQueues(Ok(response)) ->
      case json.parse(response.body, using: queue_list_decoder()) {
        Ok(queues) -> #(Model(..model, queues: queues, loading: False), none())
        Error(_) -> #(
          Model(..model, loading: False, error: option.Some("Parse error")),
          none(),
        )
      }
    LoadedQueues(Error(_)) -> #(
      Model(
        ..model,
        loading: False,
        error: option.Some("Failed to load queues"),
      ),
      none(),
    )
  }
}

pub fn view(model: Model) -> lustre_elem.Element(Msg) {
  div("flex flex-col h-screen bg-gray-900", [
    header(model),
    body(model),
  ])
}

fn header(model: Model) -> lustre_elem.Element(Msg) {
  let queue_count = list.length(model.queues) |> int.to_string()
  div(
    "flex text-xl text-white font-extrabold h-[20%] bg-green-800 p-4 justify-between items-center",
    [
      text("FRONTDESK (" <> model.code <> ")"),
      ui_badge.badge(queue_count <> " queues", Success),
    ],
  )
}

fn body(_model: Model) -> lustre_elem.Element(Msg) {
  div("flex h-[80%] items-center justify-center p-8", [
    card.card_elevated("Frontdesk Operations", [
      text("Queue management interface"),
    ]),
  ])
}

fn fetch_queues(code: String) -> Effect(Msg) {
  api.get("/api/queues/" <> code, rsvp.expect_ok_response(LoadedQueues))
}

fn queue_list_decoder() -> decode.Decoder(List(sququeue.Queue)) {
  decode.list(queue_decoder())
}

fn queue_decoder() -> decode.Decoder(sququeue.Queue) {
  use id <- decode.field("id", decode.int)
  use que_label <- decode.field("que_label", decode.string)
  decode.success(sququeue.Queue(id:, que_label:))
}
