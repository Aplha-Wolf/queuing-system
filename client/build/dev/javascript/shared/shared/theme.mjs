import * as $json from "../../gleam_json/gleam/json.mjs";
import * as $decode from "../../gleam_stdlib/gleam/dynamic/decode.mjs";
import * as $list from "../../gleam_stdlib/gleam/list.mjs";
import { toList, CustomType as $CustomType } from "../gleam.mjs";

export class Theme extends $CustomType {
  constructor(id, name, display_name, description, is_active, is_dark) {
    super();
    this.id = id;
    this.name = name;
    this.display_name = display_name;
    this.description = description;
    this.is_active = is_active;
    this.is_dark = is_dark;
  }
}
export const Theme$Theme = (id, name, display_name, description, is_active, is_dark) =>
  new Theme(id, name, display_name, description, is_active, is_dark);
export const Theme$isTheme = (value) => value instanceof Theme;
export const Theme$Theme$id = (value) => value.id;
export const Theme$Theme$0 = (value) => value.id;
export const Theme$Theme$name = (value) => value.name;
export const Theme$Theme$1 = (value) => value.name;
export const Theme$Theme$display_name = (value) => value.display_name;
export const Theme$Theme$2 = (value) => value.display_name;
export const Theme$Theme$description = (value) => value.description;
export const Theme$Theme$3 = (value) => value.description;
export const Theme$Theme$is_active = (value) => value.is_active;
export const Theme$Theme$4 = (value) => value.is_active;
export const Theme$Theme$is_dark = (value) => value.is_dark;
export const Theme$Theme$5 = (value) => value.is_dark;

export class ThemeColor extends $CustomType {
  constructor(token, light_value, dark_value) {
    super();
    this.token = token;
    this.light_value = light_value;
    this.dark_value = dark_value;
  }
}
export const ThemeColor$ThemeColor = (token, light_value, dark_value) =>
  new ThemeColor(token, light_value, dark_value);
export const ThemeColor$isThemeColor = (value) => value instanceof ThemeColor;
export const ThemeColor$ThemeColor$token = (value) => value.token;
export const ThemeColor$ThemeColor$0 = (value) => value.token;
export const ThemeColor$ThemeColor$light_value = (value) => value.light_value;
export const ThemeColor$ThemeColor$1 = (value) => value.light_value;
export const ThemeColor$ThemeColor$dark_value = (value) => value.dark_value;
export const ThemeColor$ThemeColor$2 = (value) => value.dark_value;

export class ThemeWithColors extends $CustomType {
  constructor(theme, colors) {
    super();
    this.theme = theme;
    this.colors = colors;
  }
}
export const ThemeWithColors$ThemeWithColors = (theme, colors) =>
  new ThemeWithColors(theme, colors);
export const ThemeWithColors$isThemeWithColors = (value) =>
  value instanceof ThemeWithColors;
export const ThemeWithColors$ThemeWithColors$theme = (value) => value.theme;
export const ThemeWithColors$ThemeWithColors$0 = (value) => value.theme;
export const ThemeWithColors$ThemeWithColors$colors = (value) => value.colors;
export const ThemeWithColors$ThemeWithColors$1 = (value) => value.colors;

export class ListThemesResponse extends $CustomType {
  constructor(count, themes) {
    super();
    this.count = count;
    this.themes = themes;
  }
}
export const ListThemesResponse$ListThemesResponse = (count, themes) =>
  new ListThemesResponse(count, themes);
export const ListThemesResponse$isListThemesResponse = (value) =>
  value instanceof ListThemesResponse;
export const ListThemesResponse$ListThemesResponse$count = (value) =>
  value.count;
export const ListThemesResponse$ListThemesResponse$0 = (value) => value.count;
export const ListThemesResponse$ListThemesResponse$themes = (value) =>
  value.themes;
export const ListThemesResponse$ListThemesResponse$1 = (value) => value.themes;

export class ActivateThemeResult extends $CustomType {
  constructor(message) {
    super();
    this.message = message;
  }
}
export const ActivateThemeResult$ActivateThemeResult = (message) =>
  new ActivateThemeResult(message);
export const ActivateThemeResult$isActivateThemeResult = (value) =>
  value instanceof ActivateThemeResult;
export const ActivateThemeResult$ActivateThemeResult$message = (value) =>
  value.message;
export const ActivateThemeResult$ActivateThemeResult$0 = (value) =>
  value.message;

export function decoder() {
  return $decode.field(
    "id",
    $decode.int,
    (id) => {
      return $decode.field(
        "name",
        $decode.string,
        (name) => {
          return $decode.field(
            "display_name",
            $decode.string,
            (display_name) => {
              return $decode.field(
                "description",
                $decode.string,
                (description) => {
                  return $decode.field(
                    "is_active",
                    $decode.bool,
                    (is_active) => {
                      return $decode.field(
                        "is_dark",
                        $decode.bool,
                        (is_dark) => {
                          return $decode.success(
                            new Theme(
                              id,
                              name,
                              display_name,
                              description,
                              is_active,
                              is_dark,
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
    },
  );
}

export function color_decoder() {
  return $decode.field(
    "token",
    $decode.string,
    (token) => {
      return $decode.field(
        "light_value",
        $decode.string,
        (light_value) => {
          return $decode.field(
            "dark_value",
            $decode.string,
            (dark_value) => {
              return $decode.success(
                new ThemeColor(token, light_value, dark_value),
              );
            },
          );
        },
      );
    },
  );
}

export function theme_with_colors_decoder() {
  return $decode.field(
    "theme",
    decoder(),
    (theme) => {
      return $decode.field(
        "colors",
        $decode.list(color_decoder()),
        (colors) => {
          return $decode.success(new ThemeWithColors(theme, colors));
        },
      );
    },
  );
}

export function to_json(theme) {
  let id;
  let name;
  let display_name;
  let description;
  let is_active;
  let is_dark;
  id = theme.id;
  name = theme.name;
  display_name = theme.display_name;
  description = theme.description;
  is_active = theme.is_active;
  is_dark = theme.is_dark;
  return $json.object(
    toList([
      ["id", $json.int(id)],
      ["name", $json.string(name)],
      ["display_name", $json.string(display_name)],
      ["description", $json.string(description)],
      ["is_active", $json.bool(is_active)],
      ["is_dark", $json.bool(is_dark)],
    ]),
  );
}

export function color_to_json(color) {
  let token;
  let light_value;
  let dark_value;
  token = color.token;
  light_value = color.light_value;
  dark_value = color.dark_value;
  return $json.object(
    toList([
      ["token", $json.string(token)],
      ["light_value", $json.string(light_value)],
      ["dark_value", $json.string(dark_value)],
    ]),
  );
}

export function theme_with_colors_to_json(twc) {
  let theme;
  let colors;
  theme = twc.theme;
  colors = twc.colors;
  return $json.object(
    toList([
      ["theme", to_json(theme)],
      ["colors", $json.preprocessed_array($list.map(colors, color_to_json))],
    ]),
  );
}

export function list_themes_decoder() {
  return $decode.field(
    "count",
    $decode.int,
    (count) => {
      return $decode.field(
        "themes",
        $decode.list(decoder()),
        (themes) => {
          return $decode.success(new ListThemesResponse(count, themes));
        },
      );
    },
  );
}

export function activate_result_decoder() {
  return $decode.field(
    "message",
    $decode.string,
    (message) => { return $decode.success(new ActivateThemeResult(message)); },
  );
}
