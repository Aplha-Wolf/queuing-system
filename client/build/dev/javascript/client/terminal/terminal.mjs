import * as $response from "../../gleam_http/gleam/http/response.mjs";
import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import * as $option from "../../gleam_stdlib/gleam/option.mjs";
import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { style } from "../../lustre/lustre/attribute.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import { map as effect_map, none } from "../../lustre/lustre/effect.mjs";
import * as $lustre_elem from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $rsvp from "../../rsvp/rsvp.mjs";
import * as $sququeue from "../../shared/shared/queue.mjs";
import * as $sterminal from "../../shared/shared/terminal.mjs";
import * as $api from "../api.mjs";
import { Ok, toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $device from "../lib/device.mjs";
import * as $button from "../ui/button.mjs";
import * as $kit from "../ui/kit.mjs";
import { div, div_with_class_and_style, text } from "../ui/kit.mjs";
import * as $ui_list from "../ui/list.mjs";
import * as $theme_context from "../ui/theme/context.mjs";
import * as $theme_types from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(terminal, current_queue, queues, code, loading, error, device, colors) {
    super();
    this.terminal = terminal;
    this.current_queue = current_queue;
    this.queues = queues;
    this.code = code;
    this.loading = loading;
    this.error = error;
    this.device = device;
    this.colors = colors;
  }
}
export const Model$Model = (terminal, current_queue, queues, code, loading, error, device, colors) =>
  new Model(terminal,
  current_queue,
  queues,
  code,
  loading,
  error,
  device,
  colors);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$terminal = (value) => value.terminal;
export const Model$Model$0 = (value) => value.terminal;
export const Model$Model$current_queue = (value) => value.current_queue;
export const Model$Model$1 = (value) => value.current_queue;
export const Model$Model$queues = (value) => value.queues;
export const Model$Model$2 = (value) => value.queues;
export const Model$Model$code = (value) => value.code;
export const Model$Model$3 = (value) => value.code;
export const Model$Model$loading = (value) => value.loading;
export const Model$Model$4 = (value) => value.loading;
export const Model$Model$error = (value) => value.error;
export const Model$Model$5 = (value) => value.error;
export const Model$Model$device = (value) => value.device;
export const Model$Model$6 = (value) => value.device;
export const Model$Model$colors = (value) => value.colors;
export const Model$Model$7 = (value) => value.colors;

export class LoadedTerminal extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$LoadedTerminal = ($0) => new LoadedTerminal($0);
export const Msg$isLoadedTerminal = (value) => value instanceof LoadedTerminal;
export const Msg$LoadedTerminal$0 = (value) => value[0];

export class LoadedQueues extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$LoadedQueues = ($0) => new LoadedQueues($0);
export const Msg$isLoadedQueues = (value) => value instanceof LoadedQueues;
export const Msg$LoadedQueues$0 = (value) => value[0];

export class NextQueue extends $CustomType {}
export const Msg$NextQueue = () => new NextQueue();
export const Msg$isNextQueue = (value) => value instanceof NextQueue;

export class RecallQueue extends $CustomType {}
export const Msg$RecallQueue = () => new RecallQueue();
export const Msg$isRecallQueue = (value) => value instanceof RecallQueue;

export class QueueUpdated extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$QueueUpdated = ($0) => new QueueUpdated($0);
export const Msg$isQueueUpdated = (value) => value instanceof QueueUpdated;
export const Msg$QueueUpdated$0 = (value) => value[0];

export class ThemeMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$ThemeMsg = ($0) => new ThemeMsg($0);
export const Msg$isThemeMsg = (value) => value instanceof ThemeMsg;
export const Msg$ThemeMsg$0 = (value) => value[0];

export function init(code) {
  let $ = $theme_context.load_theme_colors();
  let theme_state;
  let theme_effect;
  theme_state = $[0];
  theme_effect = $[1];
  return [
    new Model(
      new $option.None(),
      $sququeue.empty(),
      toList([]),
      code,
      true,
      new $option.None(),
      $device.detect_device(),
      theme_state.colors,
    ),
    effect_map(theme_effect, (var0) => { return new ThemeMsg(var0); }),
  ];
}

function header_view(code, header_style, text_style) {
  return $html.div(
    toList([style("background-color", header_style), style("color", text_style)]),
    toList([text(("TERMINAL (" + code) + ")")]),
  );
}

function queue_list_section(queues, colors) {
  let queue_labels = $list.map(queues, (q) => { return q.que_label; });
  return div(
    "w-1/4 p-2",
    toList([
      div_with_class_and_style(
        "p-4 rounded-lg",
        colors.card_background,
        toList([style("border", colors.card_border)]),
        toList([
          div_with_class_and_style(
            "",
            colors.card_text,
            toList([]),
            toList([$ui_list.text_list_bordered(queue_labels)]),
          ),
        ]),
      ),
    ]),
  );
}

function current_queue_section(model, colors) {
  let _block;
  let $ = model.terminal;
  if ($ instanceof $option.Some) {
    let t = $[0];
    if (t.active) {
      _block = model.current_queue.que_label;
    } else {
      _block = "INACTIVE";
    }
  } else {
    _block = "INACTIVE";
  }
  let display_text = _block;
  let _block$1;
  let $1 = model.terminal;
  if ($1 instanceof $option.Some) {
    let t = $1[0];
    if (t.active) {
      _block$1 = colors.success;
    } else {
      _block$1 = colors.danger;
    }
  } else {
    _block$1 = colors.danger;
  }
  let status_color = _block$1;
  return div(
    "w-1/2 flex items-center justify-center p-4",
    toList([
      div_with_class_and_style(
        "w-full border rounded-lg p-8 text-center",
        colors.card_background,
        toList([style("border-color", colors.card_border)]),
        toList([
          div_with_class_and_style(
            "text-sm mb-2",
            colors.text_secondary,
            toList([]),
            toList([$lustre_elem.text("NOW SERVING")]),
          ),
          div_with_class_and_style(
            "text-5xl font-black",
            colors.text_primary,
            toList([]),
            toList([$lustre_elem.text(display_text)]),
          ),
          div_with_class_and_style(
            "mt-4 text-sm font-medium",
            status_color,
            toList([]),
            toList([
              $lustre_elem.text(
                (() => {
                  let $2 = model.terminal;
                  if ($2 instanceof $option.Some) {
                    let t = $2[0];
                    if (t.active) {
                      return "ACTIVE";
                    } else {
                      return "INACTIVE";
                    }
                  } else {
                    return "INACTIVE";
                  }
                })(),
              ),
            ]),
          ),
        ]),
      ),
    ]),
  );
}

function action_section(model, colors) {
  let _block;
  let $ = model.terminal;
  if ($ instanceof $option.Some) {
    let t = $[0];
    _block = !t.active;
  } else {
    _block = true;
  }
  let is_disabled = _block;
  return div(
    "w-1/4 flex flex-col p-2 gap-2",
    toList([
      $button.button(
        "NEXT",
        new $theme_types.Primary(),
        new $theme_types.Md(),
        model.device,
        is_disabled,
        "",
        colors.button_primary,
        colors.text_primary,
        new NextQueue(),
      ),
      $button.button(
        "RECALL",
        new $theme_types.Primary(),
        new $theme_types.Md(),
        model.device,
        is_disabled,
        "",
        colors.button_primary,
        colors.text_primary,
        new RecallQueue(),
      ),
    ]),
  );
}

function body_view(model, colors) {
  return $html.div(
    toList([style("display", "flex"), style("height", "100%")]),
    toList([
      queue_list_section(model.queues, colors),
      current_queue_section(model, colors),
      action_section(model, colors),
    ]),
  );
}

export function view(model) {
  let colors = model.colors;
  return $html.div(
    toList([style("background-color", colors.background)]),
    toList([
      header_view(model.code, colors.header_background, colors.header_text),
      body_view(model, colors),
    ]),
  );
}

function fetch_terminal(code) {
  return $api.get(
    "/api/terminals?code=" + code,
    $rsvp.expect_ok_response((var0) => { return new LoadedTerminal(var0); }),
  );
}

export function after_mount(_, model) {
  return fetch_terminal(model.code);
}

function fetch_queues(code) {
  return $api.get(
    "/api/queues/terminals/onqueues?code=" + code,
    $rsvp.expect_ok_response((var0) => { return new LoadedQueues(var0); }),
  );
}

function terminal_decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "created_at",
        $decode.string,
        (created_at) => {
          return $decode.field(
            "code",
            $decode.string,
            (code) => {
              return $decode.field(
                "name",
                $decode.string,
                (name) => {
                  return $decode.field(
                    "active",
                    $decode.bool,
                    (active) => {
                      return $decode.success(
                        new $sterminal.Terminal(
                          id,
                          created_at,
                          code,
                          name,
                          active,
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      );
    },
  );
}

function queue_decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "que_label",
        $decode.string,
        (que_label) => {
          return $decode.success(new $sququeue.Queue(id, que_label));
        },
      );
    },
  );
}

function queue_list_decoder() {
  return $decode.list(queue_decoder());
}

export function update(model, msg) {
  if (msg instanceof LoadedTerminal) {
    let $ = msg[0];
    if ($ instanceof Ok) {
      let response = $[0];
      let $1 = $json.parse(response.body, terminal_decoder());
      if ($1 instanceof Ok) {
        let terminal = $1[0];
        return [
          new Model(
            new $option.Some(terminal),
            model.current_queue,
            model.queues,
            model.code,
            false,
            model.error,
            model.device,
            model.colors,
          ),
          fetch_queues(model.code),
        ];
      } else {
        return [
          new Model(
            model.terminal,
            model.current_queue,
            model.queues,
            model.code,
            false,
            new $option.Some("Parse error"),
            model.device,
            model.colors,
          ),
          none(),
        ];
      }
    } else {
      return [
        new Model(
          model.terminal,
          model.current_queue,
          model.queues,
          model.code,
          false,
          new $option.Some("Failed to load terminal"),
          model.device,
          model.colors,
        ),
        none(),
      ];
    }
  } else if (msg instanceof LoadedQueues) {
    let $ = msg[0];
    if ($ instanceof Ok) {
      let response = $[0];
      let $1 = $json.parse(response.body, queue_list_decoder());
      if ($1 instanceof Ok) {
        let queues = $1[0];
        return [
          new Model(
            model.terminal,
            model.current_queue,
            queues,
            model.code,
            model.loading,
            model.error,
            model.device,
            model.colors,
          ),
          none(),
        ];
      } else {
        return [
          new Model(
            model.terminal,
            model.current_queue,
            model.queues,
            model.code,
            model.loading,
            new $option.Some("Parse error"),
            model.device,
            model.colors,
          ),
          none(),
        ];
      }
    } else {
      return [
        new Model(
          model.terminal,
          model.current_queue,
          model.queues,
          model.code,
          model.loading,
          new $option.Some("Failed to load queues"),
          model.device,
          model.colors,
        ),
        none(),
      ];
    }
  } else if (msg instanceof NextQueue) {
    return [model, none()];
  } else if (msg instanceof RecallQueue) {
    return [model, none()];
  } else if (msg instanceof QueueUpdated) {
    return [model, none()];
  } else {
    let theme_msg = msg[0];
    let update_result = $theme_context.update(
      new $theme_types.ThemeState(model.colors, false),
      theme_msg,
    );
    return [
      new Model(
        model.terminal,
        model.current_queue,
        model.queues,
        model.code,
        model.loading,
        model.error,
        model.device,
        update_result[0].colors,
      ),
      effect_map(update_result[1], (var0) => { return new ThemeMsg(var0); }),
    ];
  }
}
