import apps/frontdesk/public as frontdesk_mod
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/effect.{type Effect, none}
import lustre/element.{type Element, none as elem_none}
import lustre/element/html
import modules/queue/public as queue_mod
import ui/button
import ui/kit
import ui/theme/theme as theme_helpers
import ui/theme/types as theme_types

pub type InitArgs {
  InitArgs(code: String, frontdesk_service: frontdesk_mod.FrontdeskService)
}

pub type Model {
  Model(
    frontdesk: Option(frontdesk_mod.FrontdeskInfo),
    priorities: List(queue_mod.PriorityItem),
    quetypes: List(queue_mod.QueTypeItem),
    selected_priority: String,
    selected_quetype: String,
    message: String,
    message_ok: Bool,
    code: String,
    frontdesk_service: frontdesk_mod.FrontdeskService,
  )
}

pub type Msg {
  SelectPriority(String)
  SelectQueType(String)
  CreateQueue
  NoOp
}

pub fn init(args: InitArgs) -> #(Model, Effect(Msg)) {
  let InitArgs(code:, frontdesk_service:) = args

  let base =
    Model(
      frontdesk: None,
      priorities: [],
      quetypes: [],
      selected_priority: "0",
      selected_quetype: "0",
      message: "",
      message_ok: True,
      code: code,
      frontdesk_service: frontdesk_service,
    )

  let frontdesk = frontdesk_mod.find_by_code(frontdesk_service, code)

  let priorities = frontdesk_mod.get_active_priorities(frontdesk_service)
  let quetypes = frontdesk_mod.get_queue_types(frontdesk_service)

  #(Model(..base, frontdesk:, priorities:, quetypes:), none())
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    SelectPriority(id) -> #(Model(..model, selected_priority: id), none())
    SelectQueType(id) -> #(Model(..model, selected_quetype: id), none())
    CreateQueue -> {
      let pid = int.parse(model.selected_priority)
      let qid = int.parse(model.selected_quetype)
      case pid, qid {
        Ok(priority_id), Ok(quetype_id) if priority_id > 0 && quetype_id > 0 -> {
          case
            frontdesk_mod.create_queue(
              model.frontdesk_service,
              priority_id,
              quetype_id,
            )
          {
            frontdesk_mod.QueueCreated -> #(
              Model(
                ..model,
                message: "Queue created",
                message_ok: True,
                selected_priority: "0",
                selected_quetype: "0",
              ),
              none(),
            )
            frontdesk_mod.QueueFailed(err) -> #(
              Model(..model, message: err, message_ok: False),
              none(),
            )
          }
        }
        _, _ -> #(
          Model(
            ..model,
            message: "Select priority and queue type",
            message_ok: False,
          ),
          none(),
        )
      }
    }
    NoOp -> #(model, none())
  }
}

fn default_colors() -> theme_types.ComponentColors {
  theme_helpers.default_component_colors()
}

pub fn view(model: Model) -> Element(Msg) {
  let colors = default_colors()

  let title = case model.frontdesk {
    Some(f) -> "FRONTDESK (" <> f.name <> ")"
    _ -> "FRONTDESK (" <> model.code <> ")"
  }

  html.div(
    [
      attribute.style("background-color", colors.background),
      attribute.style("color", colors.text_primary),
      attribute.style("height", "100vh"),
    ],
    [
      header_view(title, colors.header_background, colors.header_text),
      kit.div_with_class_and_style("p-4", colors.background, [], [
        html.text("Priority"),
      ]),
      priority_grid(model.priorities, model.selected_priority, colors),
      kit.div_with_class_and_style("p-4", colors.background, [], [
        html.text("Queue Type"),
      ]),
      quetype_grid(model.quetypes, model.selected_quetype, colors),
      create_button(model, colors),
      message_view(model),
    ],
  )
}

fn header_view(title: String, bg: String, fg: String) -> Element(Msg) {
  html.div(
    [attribute.style("background-color", bg), attribute.style("color", fg)],
    [
      kit.div_with_class_and_style("p-4 text-xl font-extrabold", bg, [], [
        html.text(title),
      ]),
    ],
  )
}

fn priority_grid(
  priorities: List(queue_mod.PriorityItem),
  selected: String,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  let buttons =
    list.map(priorities, fn(p) {
      let id_str = int.to_string(p.id)
      let variant = case selected {
        s if s == id_str -> theme_types.Primary
        _ -> theme_types.Outline
      }
      button.button(
        p.name,
        variant,
        theme_types.Lg,
        theme_types.Web,
        False,
        "m-1",
        colors.button_primary,
        colors.text_primary,
        SelectPriority(id_str),
      )
    })

  html.div(
    [
      attribute.style("display", "flex"),
      attribute.style("flex-wrap", "wrap"),
      attribute.style("gap", "4px"),
      attribute.style("padding", "16px"),
    ],
    buttons,
  )
}

fn quetype_grid(
  quetypes: List(queue_mod.QueTypeItem),
  selected: String,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  let buttons =
    list.map(quetypes, fn(q) {
      let id_str = int.to_string(q.id)
      let variant = case selected {
        s if s == id_str -> theme_types.Primary
        _ -> theme_types.Outline
      }
      button.button(
        q.name,
        variant,
        theme_types.Lg,
        theme_types.Web,
        False,
        "m-1",
        colors.button_primary,
        colors.text_primary,
        SelectQueType(id_str),
      )
    })

  html.div(
    [
      attribute.style("display", "flex"),
      attribute.style("flex-wrap", "wrap"),
      attribute.style("gap", "4px"),
      attribute.style("padding", "16px"),
    ],
    buttons,
  )
}

fn create_button(
  model: Model,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  let has_selection =
    model.selected_priority != "0" && model.selected_quetype != "0"

  html.div([attribute.style("padding", "16px")], [
    button.button(
      "CREATE QUEUE",
      theme_types.Success,
      theme_types.Lg,
      theme_types.Web,
      !has_selection,
      "w-full",
      colors.success,
      "#ffffff",
      CreateQueue,
    ),
  ])
}

fn message_view(model: Model) -> Element(Msg) {
  case model.message {
    "" -> elem_none()
    msg -> {
      let color = case model.message_ok {
        True -> "#10b981"
        False -> "#ef4444"
      }
      kit.div_with_class_and_style("p-4 text-center font-bold", color, [], [
        html.text(msg),
      ])
    }
  }
}
