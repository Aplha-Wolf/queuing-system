import * as $attribute from "../../lustre/lustre/attribute.mjs";
import { class$ } from "../../lustre/lustre/attribute.mjs";
import * as $effect from "../../lustre/lustre/effect.mjs";
import { map as effect_map } from "../../lustre/lustre/effect.mjs";
import * as $lustre_elem from "../../lustre/lustre/element.mjs";
import * as $html from "../../lustre/lustre/element/html.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";
import * as $theme_settings from "../settings/theme.mjs";

export class Model extends $CustomType {
  constructor(theme_model) {
    super();
    this.theme_model = theme_model;
  }
}
export const Model$Model = (theme_model) => new Model(theme_model);
export const Model$isModel = (value) => value instanceof Model;
export const Model$Model$theme_model = (value) => value.theme_model;
export const Model$Model$0 = (value) => value.theme_model;

export class ThemeMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$ThemeMsg = ($0) => new ThemeMsg($0);
export const Msg$isThemeMsg = (value) => value instanceof ThemeMsg;
export const Msg$ThemeMsg$0 = (value) => value[0];

export function init() {
  let $ = $theme_settings.init();
  let theme_model;
  let theme_effect;
  theme_model = $[0];
  theme_effect = $[1];
  return [
    new Model(theme_model),
    effect_map(theme_effect, (var0) => { return new ThemeMsg(var0); }),
  ];
}

export function update(model, msg) {
  let theme_msg = msg[0];
  let $ = $theme_settings.update(model.theme_model, theme_msg);
  let new_theme_model;
  let effect;
  new_theme_model = $[0];
  effect = $[1];
  return [
    new Model(new_theme_model),
    effect_map(effect, (var0) => { return new ThemeMsg(var0); }),
  ];
}

function header() {
  return $html.h1(
    toList([class$("text-3xl font-bold mb-8 text-gray-900")]),
    toList([$lustre_elem.text("Theme Settings")]),
  );
}

export function view(model) {
  return $html.div(
    toList([class$("min-h-screen bg-gray-100 p-8")]),
    toList([
      $html.div(
        toList([class$("max-w-6xl mx-auto")]),
        toList([
          header(),
          $lustre_elem.map(
            $theme_settings.view(model.theme_model),
            (var0) => { return new ThemeMsg(var0); },
          ),
        ]),
      ),
    ]),
  );
}
