import * as $json from "../../../gleam_json/gleam/json.mjs";
import * as $decode from "../../../gleam_stdlib/gleam/dynamic/decode.mjs";
import { toList } from "../../gleam.mjs";
import * as $types from "../../ui/theme/types.mjs";
import {
  ComponentColors,
  ContainerFull,
  ContainerLg,
  ContainerMd,
  ContainerSm,
  ContainerXl,
  ContainerXs,
  Email,
  Lg,
  Md,
  Mobile,
  Number,
  Password,
  Sm,
  Tel,
  Text,
  Url,
  Web,
  Xl,
  Xs,
} from "../../ui/theme/types.mjs";

export function size_to_class(size) {
  if (size instanceof Xs) {
    return "text-xs px-2 py-1";
  } else if (size instanceof Sm) {
    return "text-sm px-3 py-1.5";
  } else if (size instanceof Md) {
    return "text-base px-4 py-2";
  } else if (size instanceof Lg) {
    return "text-lg px-5 py-2.5";
  } else {
    return "text-xl px-6 py-3";
  }
}

export function size_to_text_class(size) {
  if (size instanceof Xs) {
    return "text-xs";
  } else if (size instanceof Sm) {
    return "text-sm";
  } else if (size instanceof Md) {
    return "text-base";
  } else if (size instanceof Lg) {
    return "text-lg";
  } else {
    return "text-xl";
  }
}

export function device_to_class(device) {
  if (device instanceof Web) {
    return "w-full";
  } else {
    return "w-full max-w-sm";
  }
}

export function input_type_to_string(input_type) {
  if (input_type instanceof Text) {
    return "text";
  } else if (input_type instanceof Password) {
    return "password";
  } else if (input_type instanceof Email) {
    return "email";
  } else if (input_type instanceof Number) {
    return "number";
  } else if (input_type instanceof Tel) {
    return "tel";
  } else {
    return "url";
  }
}

export function container_size_to_class(size) {
  if (size instanceof ContainerXs) {
    return "max-w-xs";
  } else if (size instanceof ContainerSm) {
    return "max-w-sm";
  } else if (size instanceof ContainerMd) {
    return "max-w-md";
  } else if (size instanceof ContainerLg) {
    return "max-w-lg";
  } else if (size instanceof ContainerXl) {
    return "max-w-xl";
  } else {
    return "max-w-full";
  }
}

export function component_colors_decoder() {
  return $decode.field(
    "background",
    $decode.string,
    (background) => {
      return $decode.field(
        "text_primary",
        $decode.string,
        (text_primary) => {
          return $decode.field(
            "text_secondary",
            $decode.string,
            (text_secondary) => {
              return $decode.field(
                "card_background",
                $decode.string,
                (card_background) => {
                  return $decode.field(
                    "card_border",
                    $decode.string,
                    (card_border) => {
                      return $decode.field(
                        "card_text",
                        $decode.string,
                        (card_text) => {
                          return $decode.field(
                            "button_primary",
                            $decode.string,
                            (button_primary) => {
                              return $decode.field(
                                "button_secondary",
                                $decode.string,
                                (button_secondary) => {
                                  return $decode.field(
                                    "input_background",
                                    $decode.string,
                                    (input_background) => {
                                      return $decode.field(
                                        "input_border",
                                        $decode.string,
                                        (input_border) => {
                                          return $decode.field(
                                            "input_text",
                                            $decode.string,
                                            (input_text) => {
                                              return $decode.field(
                                                "header_background",
                                                $decode.string,
                                                (header_background) => {
                                                  return $decode.field(
                                                    "header_text",
                                                    $decode.string,
                                                    (header_text) => {
                                                      return $decode.field(
                                                        "border",
                                                        $decode.string,
                                                        (border) => {
                                                          return $decode.field(
                                                            "success",
                                                            $decode.string,
                                                            (success) => {
                                                              return $decode.field(
                                                                "danger",
                                                                $decode.string,
                                                                (danger) => {
                                                                  return $decode.field(
                                                                    "warning",
                                                                    $decode.string,
                                                                    (warning) => {
                                                                      return $decode.success(
                                                                        new ComponentColors(
                                                                          background,
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
                                                                          warning,
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

export function default_component_colors() {
  return new ComponentColors(
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

export function component_colors_to_json(colors) {
  let background;
  let text_primary;
  let text_secondary;
  let card_background;
  let card_border;
  let card_text;
  let button_primary;
  let button_secondary;
  let input_background;
  let input_border;
  let input_text;
  let header_background;
  let header_text;
  let border;
  let success;
  let danger;
  let warning;
  background = colors.background;
  text_primary = colors.text_primary;
  text_secondary = colors.text_secondary;
  card_background = colors.card_background;
  card_border = colors.card_border;
  card_text = colors.card_text;
  button_primary = colors.button_primary;
  button_secondary = colors.button_secondary;
  input_background = colors.input_background;
  input_border = colors.input_border;
  input_text = colors.input_text;
  header_background = colors.header_background;
  header_text = colors.header_text;
  border = colors.border;
  success = colors.success;
  danger = colors.danger;
  warning = colors.warning;
  return $json.object(
    toList([
      ["background", $json.string(background)],
      ["text_primary", $json.string(text_primary)],
      ["text_secondary", $json.string(text_secondary)],
      ["card_background", $json.string(card_background)],
      ["card_border", $json.string(card_border)],
      ["card_text", $json.string(card_text)],
      ["button_primary", $json.string(button_primary)],
      ["button_secondary", $json.string(button_secondary)],
      ["input_background", $json.string(input_background)],
      ["input_border", $json.string(input_border)],
      ["input_text", $json.string(input_text)],
      ["header_background", $json.string(header_background)],
      ["header_text", $json.string(header_text)],
      ["border", $json.string(border)],
      ["success", $json.string(success)],
      ["danger", $json.string(danger)],
      ["warning", $json.string(warning)],
    ]),
  );
}
