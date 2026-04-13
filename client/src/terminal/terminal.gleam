import api
import gleam/dynamic/decode
import gleam/http/response.{type Response}
import gleam/json
import gleam/list
import gleam/option.{type Option}
import lib/device
import lustre/attribute.{style}
import lustre/effect.{type Effect, map as effect_map, none}
import lustre/element as lustre_elem
import lustre/element/html
import rsvp
import shared/queue as sququeue
import shared/terminal as sterminal
import ui/button
import ui/kit.{div, div_with_class_and_style, text}
import ui/list as ui_list
import ui/theme/context as theme_context
import ui/theme/types as theme_types

pub type Model {
  Model(
    terminal: Option(sterminal.Terminal),
    current_queue: sququeue.Queue,
    queues: List(sququeue.Queue),
    code: String,
    loading: Bool,
    error: Option(String),
    device: theme_types.Device,
    colors: theme_types.ComponentColors,
  )
}

pub type Msg {
  LoadedTerminal(Result(Response(String), rsvp.Error))
  LoadedQueues(Result(Response(String), rsvp.Error))
  NextQueue
  RecallQueue
  QueueUpdated(Result(Response(String), rsvp.Error))
  ThemeMsg(theme_context.ThemeMsg)
}

pub fn init(code: String) -> #(Model, Effect(Msg)) {
  let #(theme_state, theme_effect) = theme_context.load_theme_colors()
  #(
    Model(
      terminal: option.None,
      current_queue: sququeue.empty(),
      queues: [],
      code: code,
      loading: True,
      error: option.None,
      device: device.detect_device(),
      colors: theme_state.colors,
    ),
    effect_map(theme_effect, ThemeMsg),
  )
}

pub fn after_mount(_old_model: Model, model: Model) -> Effect(Msg) {
  fetch_terminal(model.code)
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    LoadedTerminal(Ok(response)) ->
      case json.parse(response.body, using: terminal_decoder()) {
        Ok(terminal) -> #(
          Model(..model, terminal: option.Some(terminal), loading: False),
          fetch_queues(model.code),
        )
        Error(_) -> #(
          Model(..model, loading: False, error: option.Some("Parse error")),
          none(),
        )
      }
    LoadedTerminal(Error(_)) -> #(
      Model(
        ..model,
        loading: False,
        error: option.Some("Failed to load terminal"),
      ),
      none(),
    )
    LoadedQueues(Ok(response)) ->
      case json.parse(response.body, using: queue_list_decoder()) {
        Ok(queues) -> #(Model(..model, queues: queues), none())
        Error(_) -> #(Model(..model, error: option.Some("Parse error")), none())
      }
    LoadedQueues(Error(_)) -> #(
      Model(..model, error: option.Some("Failed to load queues")),
      none(),
    )
    NextQueue -> #(model, none())
    RecallQueue -> #(model, none())
    QueueUpdated(_) -> #(model, none())
    ThemeMsg(theme_msg) -> {
      let update_result =
        theme_context.update(
          theme_types.ThemeState(colors: model.colors, is_loading: False),
          theme_msg,
        )
      #(
        Model(..model, colors: update_result.0.colors),
        effect_map(update_result.1, ThemeMsg),
      )
    }
  }
}

pub fn view(model: Model) -> lustre_elem.Element(Msg) {
  let colors = model.colors

  html.div([style("background-color", colors.background)], [
    header_view(model.code, colors.header_background, colors.header_text),
    body_view(model, colors),
  ])
}

fn header_view(
  code: String,
  header_style: String,
  text_style: String,
) -> lustre_elem.Element(Msg) {
  html.div(
    [
      style("background-color", header_style),
      style("color", text_style),
    ],
    [text("TERMINAL (" <> code <> ")")],
  )
}

fn body_view(
  model: Model,
  colors: theme_types.ComponentColors,
) -> lustre_elem.Element(Msg) {
  html.div([style("display", "flex"), style("height", "100%")], [
    queue_list_section(model.queues, colors),
    current_queue_section(model, colors),
    action_section(model, colors),
  ])
}

fn queue_list_section(
  queues: List(sququeue.Queue),
  colors: theme_types.ComponentColors,
) -> lustre_elem.Element(Msg) {
  let queue_labels = list.map(queues, fn(q: sququeue.Queue) { q.que_label })

  div("w-1/4 p-2", [
    div_with_class_and_style(
      "p-4 rounded-lg",
      colors.card_background,
      [style("border", colors.card_border)],
      [
        div_with_class_and_style("", colors.card_text, [], [
          ui_list.text_list_bordered(queue_labels),
        ]),
      ],
    ),
  ])
}

fn current_queue_section(
  model: Model,
  colors: theme_types.ComponentColors,
) -> lustre_elem.Element(Msg) {
  let display_text = case model.terminal {
    option.Some(t) if t.active -> model.current_queue.que_label
    _ -> "INACTIVE"
  }

  let status_color = case model.terminal {
    option.Some(t) if t.active -> colors.success
    _ -> colors.danger
  }

  div("w-1/2 flex items-center justify-center p-4", [
    div_with_class_and_style(
      "w-full border rounded-lg p-8 text-center",
      colors.card_background,
      [style("border-color", colors.card_border)],
      [
        div_with_class_and_style("text-sm mb-2", colors.text_secondary, [], [
          lustre_elem.text("NOW SERVING"),
        ]),
        div_with_class_and_style(
          "text-5xl font-black",
          colors.text_primary,
          [],
          [
            lustre_elem.text(display_text),
          ],
        ),
        div_with_class_and_style("mt-4 text-sm font-medium", status_color, [], [
          lustre_elem.text(case model.terminal {
            option.Some(t) if t.active -> "ACTIVE"
            _ -> "INACTIVE"
          }),
        ]),
      ],
    ),
  ])
}

fn action_section(
  model: Model,
  colors: theme_types.ComponentColors,
) -> lustre_elem.Element(Msg) {
  let is_disabled = case model.terminal {
    option.Some(t) -> !t.active
    _ -> True
  }

  div("w-1/4 flex flex-col p-2 gap-2", [
    button.button(
      "NEXT",
      theme_types.Primary,
      theme_types.Md,
      model.device,
      is_disabled,
      "",
      colors.button_primary,
      colors.text_primary,
      NextQueue,
    ),
    button.button(
      "RECALL",
      theme_types.Primary,
      theme_types.Md,
      model.device,
      is_disabled,
      "",
      colors.button_primary,
      colors.text_primary,
      RecallQueue,
    ),
  ])
}

fn fetch_terminal(code: String) -> Effect(Msg) {
  api.get(
    "/api/terminals?code=" <> code,
    rsvp.expect_ok_response(LoadedTerminal),
  )
}

fn fetch_queues(code: String) -> Effect(Msg) {
  api.get(
    "/api/queues/terminals/onqueues?code=" <> code,
    rsvp.expect_ok_response(LoadedQueues),
  )
}

fn terminal_decoder() -> decode.Decoder(sterminal.Terminal) {
  use id <- decode.field("id", decode.int)
  use created_at <- decode.field("created_at", decode.string)
  use code <- decode.field("code", decode.string)
  use name <- decode.field("name", decode.string)
  use active <- decode.field("active", decode.bool)
  decode.success(sterminal.Terminal(id:, created_at:, code:, name:, active:))
}

fn queue_list_decoder() -> decode.Decoder(List(sququeue.Queue)) {
  decode.list(queue_decoder())
}

fn queue_decoder() -> decode.Decoder(sququeue.Queue) {
  use id <- decode.field("id", decode.int)
  use que_label <- decode.field("que_label", decode.string)
  decode.success(sququeue.Queue(id:, que_label:))
}
