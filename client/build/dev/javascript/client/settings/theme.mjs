import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$, type_ } from "../../lustre/lustre/attribute.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import { map as effect_map } from "../../lustre/lustre/effect.mjs";
import * as $lustre_elem from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import * as $event from "../../lustre/lustre/event.mjs";
import { on_input } from "../../lustre/lustre/event.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme_context from "../ui/theme/context.mjs";
import * as $theme_types from "../ui/theme/types.mjs";

export class Model extends $CustomType {
  constructor(colors, is_loading, is_saving) {
    super();
    this.colors = colors;
    this.is_loading = is_loading;
    this.is_saving = is_saving;
  }
}
export const Model$Model = (colors, is_loading, is_saving) =>
  new Model(colors, is_loading, is_saving);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$colors = (value) => value.colors;
export const Model$Model$0 = (value) => value.colors;
export const Model$Model$is_loading = (value) => value.is_loading;
export const Model$Model$1 = (value) => value.is_loading;
export const Model$Model$is_saving = (value) => value.is_saving;
export const Model$Model$2 = (value) => value.is_saving;

export class ThemeMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$ThemeMsg = ($0) => new ThemeMsg($0);
export const Msg$isThemeMsg = (value) => value instanceof ThemeMsg;
export const Msg$ThemeMsg$0 = (value) => value[0];

export class UpdateColor extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}
export const Msg$UpdateColor = ($0, $1) => new UpdateColor($0, $1);
export const Msg$isUpdateColor = (value) => value instanceof UpdateColor;
export const Msg$UpdateColor$0 = (value) => value[0];
export const Msg$UpdateColor$1 = (value) => value[1];

export function init() {
  let $ = $theme_context.load_theme_colors();
  let theme_state;
  let effect;
  theme_state = $[0];
  effect = $[1];
  return [
    new Model(theme_state.colors, theme_state.is_loading, false),
    effect_map(effect, (var0) => { return new ThemeMsg(var0); }),
  ];
}

function update_color_field(colors, key, value) {
  if (key === "background") {
    return new $theme_types.ComponentColors(
      value,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "text_primary") {
    return new $theme_types.ComponentColors(
      colors.background,
      value,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "text_secondary") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      value,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "card_background") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      value,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "card_border") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      value,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "card_text") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      value,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "button_primary") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      value,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "button_secondary") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      value,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "input_background") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      value,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "input_border") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      value,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "input_text") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      value,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "header_background") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      value,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "header_text") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      value,
      colors.border,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "border") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      value,
      colors.success,
      colors.danger,
      colors.warning,
    );
  } else if (key === "success") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      value,
      colors.danger,
      colors.warning,
    );
  } else if (key === "danger") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      value,
      colors.warning,
    );
  } else if (key === "warning") {
    return new $theme_types.ComponentColors(
      colors.background,
      colors.text_primary,
      colors.text_secondary,
      colors.card_background,
      colors.card_border,
      colors.card_text,
      colors.button_primary,
      colors.button_secondary,
      colors.input_background,
      colors.input_border,
      colors.input_text,
      colors.header_background,
      colors.header_text,
      colors.border,
      colors.success,
      colors.danger,
      value,
    );
  } else {
    return colors;
  }
}

export function update(model, msg) {
  if (msg instanceof ThemeMsg) {
    let theme_msg = msg[0];
    let $ = $theme_context.update(
      new $theme_types.ThemeState(model.colors, model.is_loading),
      theme_msg,
    );
    let new_state;
    let effect;
    new_state = $[0];
    effect = $[1];
    return [
      new Model(new_state.colors, new_state.is_loading, model.is_saving),
      effect_map(effect, (var0) => { return new ThemeMsg(var0); }),
    ];
  } else {
    let key = msg[0];
    let value = msg[1];
    let update_result = $theme_context.update(
      new $theme_types.ThemeState(model.colors, false),
      new $theme_context.UpdateColor(key, value),
    );
    return [
      new Model(
        update_color_field(model.colors, key, value),
        model.is_loading,
        true,
      ),
      effect_map(update_result[1], (var0) => { return new ThemeMsg(var0); }),
    ];
  }
}

function color_section(title, fields) {
  return $html.div(
    toList([class$("bg-white p-4 rounded-lg border border-gray-200")]),
    toList([
      $html.h2(
        toList([class$("text-lg font-medium mb-3 text-gray-800")]),
        toList([$lustre_elem.text(title)]),
      ),
      $html.div(toList([class$("space-y-3")]), fields),
    ]),
  );
}

function color_field(label_text, key, _) {
  return $html.div(
    toList([class$("flex items-center justify-between")]),
    toList([
      $html.label(
        toList([class$("text-sm text-gray-600")]),
        toList([$lustre_elem.text(label_text)]),
      ),
      $html.input(
        toList([
          type_("color"),
          class$("w-12 h-8 rounded cursor-pointer border border-gray-300"),
          on_input((e) => { return new UpdateColor(key, e); }),
        ]),
      ),
    ]),
  );
}

export function view(model) {
  let colors = model.colors;
  return $html.div(
    toList([class$("p-6")]),
    toList([
      $html.h2(
        toList([class$("text-xl font-semibold mb-6 text-gray-900")]),
        toList([$lustre_elem.text("Theme Settings")]),
      ),
      $html.div(
        toList([class$("grid grid-cols-1 md:grid-cols-2 gap-6")]),
        toList([
          color_section(
            "General",
            toList([
              color_field("Background", "background", colors.background),
              color_field("Text Primary", "text_primary", colors.text_primary),
              color_field(
                "Text Secondary",
                "text_secondary",
                colors.text_secondary,
              ),
              color_field("Border", "border", colors.border),
            ]),
          ),
          color_section(
            "Card",
            toList([
              color_field(
                "Card Background",
                "card_background",
                colors.card_background,
              ),
              color_field("Card Border", "card_border", colors.card_border),
              color_field("Card Text", "card_text", colors.card_text),
            ]),
          ),
          color_section(
            "Button",
            toList([
              color_field(
                "Button Primary",
                "button_primary",
                colors.button_primary,
              ),
              color_field(
                "Button Secondary",
                "button_secondary",
                colors.button_secondary,
              ),
            ]),
          ),
          color_section(
            "Input",
            toList([
              color_field(
                "Input Background",
                "input_background",
                colors.input_background,
              ),
              color_field("Input Border", "input_border", colors.input_border),
              color_field("Input Text", "input_text", colors.input_text),
            ]),
          ),
          color_section(
            "Header",
            toList([
              color_field(
                "Header Background",
                "header_background",
                colors.header_background,
              ),
              color_field("Header Text", "header_text", colors.header_text),
            ]),
          ),
          color_section(
            "Status",
            toList([
              color_field("Success", "success", colors.success),
              color_field("Danger", "danger", colors.danger),
              color_field("Warning", "warning", colors.warning),
            ]),
          ),
        ]),
      ),
    ]),
  );
}
