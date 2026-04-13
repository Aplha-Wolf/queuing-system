import * as $json from "../../gleam_json/gleam/json.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Settings extends $CustomType {
  constructor(background, text_primary, text_secondary, card_background, card_border, card_text, button_primary, button_secondary, input_background, input_border, input_text, header_background, header_text, border, success, danger, warning) {
    super();
    this.background = background;
    this.text_primary = text_primary;
    this.text_secondary = text_secondary;
    this.card_background = card_background;
    this.card_border = card_border;
    this.card_text = card_text;
    this.button_primary = button_primary;
    this.button_secondary = button_secondary;
    this.input_background = input_background;
    this.input_border = input_border;
    this.input_text = input_text;
    this.header_background = header_background;
    this.header_text = header_text;
    this.border = border;
    this.success = success;
    this.danger = danger;
    this.warning = warning;
  }
}
export const Settings$Settings = (background, text_primary, text_secondary, card_background, card_border, card_text, button_primary, button_secondary, input_background, input_border, input_text, header_background, header_text, border, success, danger, warning) =>
  new Settings(background,
  text_primary,
  text_secondary,
  card_background,
  card_border,
  card_text,
  button_primary,
  button_secondary,
  input_background,
  input_border,
  input_text,
  header_background,
  header_text,
  border,
  success,
  danger,
  warning);
export const Settings$isSettings = (value) => value instanceof Settings;
export const Settings$Settings$background = (value) => value.background;
export const Settings$Settings$0 = (value) => value.background;
export const Settings$Settings$text_primary = (value) => value.text_primary;
export const Settings$Settings$1 = (value) => value.text_primary;
export const Settings$Settings$text_secondary = (value) => value.text_secondary;
export const Settings$Settings$2 = (value) => value.text_secondary;
export const Settings$Settings$card_background = (value) =>
  value.card_background;
export const Settings$Settings$3 = (value) => value.card_background;
export const Settings$Settings$card_border = (value) => value.card_border;
export const Settings$Settings$4 = (value) => value.card_border;
export const Settings$Settings$card_text = (value) => value.card_text;
export const Settings$Settings$5 = (value) => value.card_text;
export const Settings$Settings$button_primary = (value) => value.button_primary;
export const Settings$Settings$6 = (value) => value.button_primary;
export const Settings$Settings$button_secondary = (value) =>
  value.button_secondary;
export const Settings$Settings$7 = (value) => value.button_secondary;
export const Settings$Settings$input_background = (value) =>
  value.input_background;
export const Settings$Settings$8 = (value) => value.input_background;
export const Settings$Settings$input_border = (value) => value.input_border;
export const Settings$Settings$9 = (value) => value.input_border;
export const Settings$Settings$input_text = (value) => value.input_text;
export const Settings$Settings$10 = (value) => value.input_text;
export const Settings$Settings$header_background = (value) =>
  value.header_background;
export const Settings$Settings$11 = (value) => value.header_background;
export const Settings$Settings$header_text = (value) => value.header_text;
export const Settings$Settings$12 = (value) => value.header_text;
export const Settings$Settings$border = (value) => value.border;
export const Settings$Settings$13 = (value) => value.border;
export const Settings$Settings$success = (value) => value.success;
export const Settings$Settings$14 = (value) => value.success;
export const Settings$Settings$danger = (value) => value.danger;
export const Settings$Settings$15 = (value) => value.danger;
export const Settings$Settings$warning = (value) => value.warning;
export const Settings$Settings$16 = (value) => value.warning;

export function default_settings() {
  return new Settings(
    "#1f2937",
    "#f9fafb",
    "#9ca3af",
    "#374151",
    "#4b5563",
    "#f9fafb",
    "#2563eb",
    "#4b5563",
    "#374151",
    "#4b5563",
    "#f9fafb",
    "#1e3a8a",
    "#f9fafb",
    "#4b5563",
    "#22c55e",
    "#ef4444",
    "#eab308",
  );
}

export function to_json(settings) {
  return $json.object(
    toList([
      ["background", $json.string(settings.background)],
      ["text_primary", $json.string(settings.text_primary)],
      ["text_secondary", $json.string(settings.text_secondary)],
      ["card_background", $json.string(settings.card_background)],
      ["card_border", $json.string(settings.card_border)],
      ["card_text", $json.string(settings.card_text)],
      ["button_primary", $json.string(settings.button_primary)],
      ["button_secondary", $json.string(settings.button_secondary)],
      ["input_background", $json.string(settings.input_background)],
      ["input_border", $json.string(settings.input_border)],
      ["input_text", $json.string(settings.input_text)],
      ["header_background", $json.string(settings.header_background)],
      ["header_text", $json.string(settings.header_text)],
      ["border", $json.string(settings.border)],
      ["success", $json.string(settings.success)],
      ["danger", $json.string(settings.danger)],
      ["warning", $json.string(settings.warning)],
    ]),
  );
}
