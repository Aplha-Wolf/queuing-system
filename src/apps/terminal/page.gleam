import gleam/erlang/process
import gleam/list
import gleam/option.{type Option, Some as OptSome}
import lustre/attribute
import lustre/effect.{type Effect, none, select as effect_select}
import lustre/element.{type Element}
import lustre/element/html
import apps/terminal/public as terminal_mod
import modules/notifications/public as notifications
import shared_kernel/queue
import shared_kernel/terminal
import ui/button
import ui/kit
import ui/list as ui_list
import ui/theme/theme as theme_helpers
import ui/theme/types as theme_types

pub type InitArgs {
  InitArgs(code: String, terminal_service: terminal_mod.TerminalService, notification_bus: notifications.NotificationBus)
}

pub type Model {
  Model(
    terminal: Option(terminal.Terminal),
    current_queue: queue.Queue,
    queues: List(queue.Queue),
    code: String,
    loading: Bool,
    error: Option(String),
    colors: theme_types.ComponentColors,
    terminal_service: terminal_mod.TerminalService,
    notification_bus: notifications.NotificationBus,
  )
}

pub type Msg {
  NextQueue
  RecallQueue
  NoOp
  AppStateEvent(notifications.Event)
}

pub fn init(args: InitArgs) -> #(Model, Effect(Msg)) {
  let InitArgs(code:, terminal_service:, notification_bus:) = args

  let base =
    Model(
      terminal: option.None,
      current_queue: queue.empty(),
      queues: [],
      code: code,
      loading: True,
      error: option.None,
      colors: theme_helpers.default_component_colors(),
      terminal_service: terminal_service,
      notification_bus: notification_bus,
    )

  let sub_effect = effect_select(fn(_dispatch, subject) {
    process.send(notification_bus, notifications.Register(subject))
    process.new_selector()
    |> process.select_map(for: subject, mapping: fn(event) { AppStateEvent(event) })
  })

  case terminal_mod.find_by_code(terminal_service, code) {
    OptSome(terminal) -> {
      let loaded = Model(..base, terminal: option.Some(terminal), loading: False)
      #(load_queues(loaded, code), sub_effect)
    }
    _ -> #(Model(..base, loading: False, error: option.Some("Terminal not found")), sub_effect)
  }
}

fn load_queues(model: Model, code: String) -> Model {
  let queues = terminal_mod.get_pending_queues(model.terminal_service, code)
  let current = terminal_mod.get_current_queue(model.terminal_service, code)
  Model(..model, queues: queues, current_queue: current)
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    NextQueue -> {
      case model.terminal {
        OptSome(t) -> {
          case terminal_mod.next_queue(model.terminal_service, t.id) {
            Ok(new_current) -> {
              process.send(
                model.notification_bus,
                notifications.Broadcast(notifications.QueueCreated),
              )
              let updated = Model(..model, current_queue: new_current)
              #(load_queues(updated, model.code), none())
            }
            _ -> #(model, none())
          }
        }
        _ -> #(model, none())
      }
    }
    RecallQueue -> {
      case model.terminal {
        OptSome(t) -> {
          let _ = terminal_mod.recall_queue(model.terminal_service, t.id)
          process.send(
            model.notification_bus,
            notifications.Broadcast(notifications.QueueCreated),
          )
          let cleared = Model(..model, current_queue: queue.empty())
          #(load_queues(cleared, model.code), none())
        }
        _ -> #(model, none())
      }
    }
    NoOp -> #(model, none())
    AppStateEvent(_event) -> #(load_queues(model, model.code), none())
  }
}

pub fn view(model: Model) -> Element(Msg) {
  let colors = model.colors

  html.div([attribute.style("background-color", colors.background)], [
    header_view(model.code, colors.header_background, colors.header_text),
    body_view(model, colors),
  ])
}

fn header_view(
  code: String,
  header_style: String,
  text_style: String,
) -> Element(Msg) {
  html.div(
    [
      attribute.style("background-color", header_style),
      attribute.style("color", text_style),
    ],
    [kit.text("TERMINAL (" <> code <> ")")],
  )
}

fn body_view(model: Model, colors: theme_types.ComponentColors) -> Element(Msg) {
  html.div([attribute.style("display", "flex"), attribute.style("height", "100%")], [
    queue_list_section(model.queues, colors),
    current_queue_section(model, colors),
    action_section(model, colors),
  ])
}

fn queue_list_section(
  queues: List(queue.Queue),
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  let queue_labels = list.map(queues, fn(q: queue.Queue) { q.que_label })

  kit.div("w-1/4 p-2", [
    kit.div_with_class_and_style(
      "p-4 rounded-lg",
      colors.card_background,
      [attribute.style("border", colors.card_border)],
      [
        kit.div_with_class_and_style("", colors.card_text, [], [
          ui_list.text_list_bordered(queue_labels),
        ]),
      ],
    ),
  ])
}

fn current_queue_section(
  model: Model,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  let display_text = case model.terminal {
    OptSome(t) if t.active -> model.current_queue.que_label
    _ -> "INACTIVE"
  }

  let status_color = case model.terminal {
    OptSome(t) if t.active -> colors.success
    _ -> colors.danger
  }

  kit.div("w-1/2 flex items-center justify-center p-4", [
    kit.div_with_class_and_style(
      "w-full border rounded-lg p-8 text-center",
      colors.card_background,
      [attribute.style("border-color", colors.card_border)],
      [
        kit.div_with_class_and_style("text-sm mb-2", colors.text_secondary, [], [
          html.text("NOW SERVING"),
        ]),
        kit.div_with_class_and_style(
          "text-5xl font-black",
          colors.text_primary,
          [],
          [html.text(display_text)],
        ),
        kit.div_with_class_and_style("mt-4 text-sm font-medium", status_color, [], [
          html.text(case model.terminal {
            OptSome(t) if t.active -> "ACTIVE"
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
) -> Element(Msg) {
  let is_disabled = case model.terminal {
    OptSome(t) -> !t.active
    _ -> True
  }

  kit.div("w-1/4 flex flex-col p-2 gap-2", [
    button.button(
      "NEXT",
      theme_types.Primary,
      theme_types.Md,
      theme_types.Web,
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
      theme_types.Web,
      is_disabled,
      "",
      colors.button_primary,
      colors.text_primary,
      RecallQueue,
    ),
  ])
}
