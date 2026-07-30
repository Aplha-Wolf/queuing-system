import apps/display/public as display_mod
import gleam/erlang/process
import gleam/int
import gleam/list
import gleam/option.{type Option}
import lustre/attribute
import lustre/effect.{type Effect, none, select as effect_select}
import lustre/element.{type Element}
import lustre/element/html
import modules/notifications/public as notifications
import shared_kernel/display
import ui/theme/theme as theme_helpers
import ui/theme/types as theme_types

pub type InitArgs {
  InitArgs(
    code: String,
    display_service: display_mod.DisplayService,
    notification_bus: notifications.NotificationBus,
  )
}

pub type Model {
  Model(
    display: Option(display.Display),
    terminals: List(display_mod.TerminalInfo),
    code: String,
    loading: Bool,
    error: Option(String),
    colors: theme_types.ComponentColors,
    display_service: display_mod.DisplayService,
    notification_bus: notifications.NotificationBus,
  )
}

pub type Msg {
  NoOp
  AppStateEvent(notifications.Event)
}

pub fn init(args: InitArgs) -> #(Model, Effect(Msg)) {
  let InitArgs(code:, display_service:, notification_bus:) = args

  let base =
    Model(
      display: option.None,
      terminals: [],
      code: code,
      loading: True,
      error: option.None,
      colors: theme_helpers.default_component_colors(),
      display_service: display_service,
      notification_bus: notification_bus,
    )

  let sub_effect =
    effect_select(fn(_dispatch, subject) {
      process.send(notification_bus, notifications.Register(subject))
      process.new_selector()
      |> process.select_map(for: subject, mapping: fn(event) {
        AppStateEvent(event)
      })
    })

  case display_mod.find_by_code(display_service, code) {
    option.Some(d) -> {
      let terminals =
        display_mod.get_terminals(display_service, d.id, d.cols * d.rows)
      #(
        Model(
          ..base,
          display: option.Some(d),
          terminals: terminals,
          loading: False,
        ),
        sub_effect,
      )
    }
    _ -> #(
      Model(..base, loading: False, error: option.Some("Display not found")),
      sub_effect,
    )
  }
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    NoOp -> #(model, none())
    AppStateEvent(_event) -> {
      let terminals = case model.display {
        option.Some(d) ->
          display_mod.get_terminals(
            model.display_service,
            d.id,
            d.cols * d.rows,
          )
        _ -> model.terminals
      }
      #(Model(..model, terminals: terminals), none())
    }
  }
}

pub fn view(model: Model) -> Element(Msg) {
  let colors = model.colors

  html.div(
    [
      attribute.style("background-color", colors.background),
      attribute.style("color", colors.text_primary),
      attribute.style("width", "100vw"),
      attribute.style("height", "100vh"),
      attribute.style("display", "flex"),
    ],
    [
      media_section(model),
      terminal_section(model, colors),
    ],
  )
}

fn media_section(model: Model) -> Element(Msg) {
  let width = case model.display {
    option.Some(d) -> int.to_string(d.media_width) <> "%"
    _ -> "50%"
  }

  html.div(
    [
      attribute.style("width", width),
      attribute.style("height", "100%"),
      attribute.style("background-color", "#000"),
      attribute.style("display", "flex"),
      attribute.style("align-items", "center"),
      attribute.style("justify-content", "center"),
    ],
    [html.text("DISPLAY: " <> model.code)],
  )
}

fn terminal_section(
  model: Model,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  let cols = case model.display {
    option.Some(d) -> d.cols
    _ -> 1
  }
  let width = case model.display {
    option.Some(d) -> int.to_string(d.terminal_div_width) <> "%"
    _ -> "50%"
  }
  let name_sz = case model.display {
    option.Some(d) -> d.name_size
    _ -> 16
  }
  let label_sz = case model.display {
    option.Some(d) -> d.que_label_size
    _ -> 24
  }
  let que_sz = case model.display {
    option.Some(d) -> d.que_no_size
    _ -> 48
  }

  let rows_list = display_mod.group_into_rows(model.terminals, cols)

  html.div(
    [
      attribute.style("width", width),
      attribute.style("height", "100%"),
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "column"),
      attribute.style("background-color", "#111"),
    ],
    list.map(rows_list, fn(row_terminals) {
      render_row(row_terminals, name_sz, label_sz, que_sz, colors)
    }),
  )
}

fn render_row(
  terminals: List(display_mod.TerminalInfo),
  name_sz: Int,
  label_sz: Int,
  que_sz: Int,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  html.div(
    [attribute.style("display", "flex"), attribute.style("flex", "1")],
    list.map(terminals, fn(t) {
      render_terminal(t, name_sz, label_sz, que_sz, colors)
    }),
  )
}

fn render_terminal(
  terminal: display_mod.TerminalInfo,
  name_sz: Int,
  label_sz: Int,
  que_sz: Int,
  colors: theme_types.ComponentColors,
) -> Element(Msg) {
  html.div(
    [
      attribute.style("flex", "1"),
      attribute.style("display", "flex"),
      attribute.style("flex-direction", "column"),
      attribute.style("align-items", "center"),
      attribute.style("justify-content", "center"),
      attribute.style("border", "1px solid " <> colors.card_border),
      attribute.style("background-color", colors.card_background),
      attribute.style("margin", "2px"),
      attribute.style("border-radius", "8px"),
    ],
    [
      html.div(
        [
          attribute.style("font-size", int.to_string(name_sz) <> "px"),
          attribute.style("color", colors.text_secondary),
        ],
        [html.text(terminal.name)],
      ),
      html.div(
        [
          attribute.style("font-size", int.to_string(que_sz) <> "px"),
          attribute.style("font-weight", "bold"),
          attribute.style("color", colors.text_primary),
          attribute.style("margin-top", "8px"),
        ],
        [html.text(terminal.que_label)],
      ),
      html.div(
        [
          attribute.style("font-size", int.to_string(label_sz) <> "px"),
          attribute.style("color", colors.text_secondary),
          attribute.style("margin-top", "4px"),
        ],
        [html.text("NOW SERVING")],
      ),
    ],
  )
}
