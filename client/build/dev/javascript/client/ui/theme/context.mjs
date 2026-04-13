import * as $response from "../../../gleam_http/gleam/http/response.mjs";
import * as $json from "../../../gleam_json/gleam/json.mjs";
import * as $effect from "../../../lustre/lustre/effect.mjs";
import { none } from "../../../lustre/lustre/effect.mjs";
import * as $rsvp from "../../../rsvp/rsvp.mjs";
import * as $api from "../../api.mjs";
import { Ok, CustomType as $CustomType } from "../../gleam.mjs";
import { set_css_var } from "../../lib/theme_ffi.ffi.js";
import * as $theme from "../../ui/theme/theme.mjs";
import * as $theme_types from "../../ui/theme/types.mjs";

export class LoadedColors extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const ThemeMsg$LoadedColors = ($0) => new LoadedColors($0);
export const ThemeMsg$isLoadedColors = (value) => value instanceof LoadedColors;
export const ThemeMsg$LoadedColors$0 = (value) => value[0];

export class UpdateColor extends $CustomType {
  constructor($0, $1) {
    super();
    this[0] = $0;
    this[1] = $1;
  }
}
export const ThemeMsg$UpdateColor = ($0, $1) => new UpdateColor($0, $1);
export const ThemeMsg$isUpdateColor = (value) => value instanceof UpdateColor;
export const ThemeMsg$UpdateColor$0 = (value) => value[0];
export const ThemeMsg$UpdateColor$1 = (value) => value[1];

export class SavedColors extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const ThemeMsg$SavedColors = ($0) => new SavedColors($0);
export const ThemeMsg$isSavedColors = (value) => value instanceof SavedColors;
export const ThemeMsg$SavedColors$0 = (value) => value[0];

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

function apply_css_variables(colors) {
  set_css_var("--background", colors.background);
  set_css_var("--text-primary", colors.text_primary);
  set_css_var("--text-secondary", colors.text_secondary);
  set_css_var("--card-background", colors.card_background);
  set_css_var("--card-border", colors.card_border);
  set_css_var("--card-text", colors.card_text);
  set_css_var("--button-primary", colors.button_primary);
  set_css_var("--button-secondary", colors.button_secondary);
  set_css_var("--input-background", colors.input_background);
  set_css_var("--input-border", colors.input_border);
  set_css_var("--input-text", colors.input_text);
  set_css_var("--header-background", colors.header_background);
  set_css_var("--header-text", colors.header_text);
  set_css_var("--border", colors.border);
  set_css_var("--success", colors.success);
  set_css_var("--danger", colors.danger);
  set_css_var("--warning", colors.warning);
  return undefined;
}

function fetch_colors() {
  return $api.get(
    "/api/settings/colors",
    $rsvp.expect_ok_response((var0) => { return new LoadedColors(var0); }),
  );
}

export function load_theme_colors() {
  return [
    new $theme_types.ThemeState($theme.default_component_colors(), true),
    fetch_colors(),
  ];
}

function save_colors(colors) {
  return $api.put(
    "/api/settings/colors",
    $theme.component_colors_to_json(colors),
    $rsvp.expect_ok_response((var0) => { return new SavedColors(var0); }),
  );
}

export function update(state, msg) {
  if (msg instanceof LoadedColors) {
    let $ = msg[0];
    if ($ instanceof Ok) {
      let response = $[0];
      let $1 = $json.parse(response.body, $theme.component_colors_decoder());
      if ($1 instanceof Ok) {
        let colors = $1[0];
        apply_css_variables(colors);
        return [new $theme_types.ThemeState(colors, false), none()];
      } else {
        return [
          new $theme_types.ThemeState($theme.default_component_colors(), false),
          none(),
        ];
      }
    } else {
      return [
        new $theme_types.ThemeState($theme.default_component_colors(), false),
        none(),
      ];
    }
  } else if (msg instanceof UpdateColor) {
    let key = msg[0];
    let value = msg[1];
    let new_colors = update_color_field(state.colors, key, value);
    apply_css_variables(new_colors);
    return [
      new $theme_types.ThemeState(new_colors, state.is_loading),
      save_colors(new_colors),
    ];
  } else {
    let $ = msg[0];
    if ($ instanceof Ok) {
      return [state, none()];
    } else {
      return [state, none()];
    }
  }
}
