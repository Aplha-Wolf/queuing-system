import * as $response from "../../../gleam_http/gleam/http/response.mjs";
import * as $rsvp from "../../../rsvp/rsvp.mjs";
import { CustomType as $CustomType } from "../../gleam.mjs";

export class ComponentColors extends $CustomType {
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
export const ComponentColors$ComponentColors = (background, text_primary, text_secondary, card_background, card_border, card_text, button_primary, button_secondary, input_background, input_border, input_text, header_background, header_text, border, success, danger, warning) =>
  new ComponentColors(background,
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
export const ComponentColors$isComponentColors = (value) =>
  value instanceof ComponentColors;
export const ComponentColors$ComponentColors$background = (value) =>
  value.background;
export const ComponentColors$ComponentColors$0 = (value) => value.background;
export const ComponentColors$ComponentColors$text_primary = (value) =>
  value.text_primary;
export const ComponentColors$ComponentColors$1 = (value) => value.text_primary;
export const ComponentColors$ComponentColors$text_secondary = (value) =>
  value.text_secondary;
export const ComponentColors$ComponentColors$2 = (value) =>
  value.text_secondary;
export const ComponentColors$ComponentColors$card_background = (value) =>
  value.card_background;
export const ComponentColors$ComponentColors$3 = (value) =>
  value.card_background;
export const ComponentColors$ComponentColors$card_border = (value) =>
  value.card_border;
export const ComponentColors$ComponentColors$4 = (value) => value.card_border;
export const ComponentColors$ComponentColors$card_text = (value) =>
  value.card_text;
export const ComponentColors$ComponentColors$5 = (value) => value.card_text;
export const ComponentColors$ComponentColors$button_primary = (value) =>
  value.button_primary;
export const ComponentColors$ComponentColors$6 = (value) =>
  value.button_primary;
export const ComponentColors$ComponentColors$button_secondary = (value) =>
  value.button_secondary;
export const ComponentColors$ComponentColors$7 = (value) =>
  value.button_secondary;
export const ComponentColors$ComponentColors$input_background = (value) =>
  value.input_background;
export const ComponentColors$ComponentColors$8 = (value) =>
  value.input_background;
export const ComponentColors$ComponentColors$input_border = (value) =>
  value.input_border;
export const ComponentColors$ComponentColors$9 = (value) => value.input_border;
export const ComponentColors$ComponentColors$input_text = (value) =>
  value.input_text;
export const ComponentColors$ComponentColors$10 = (value) => value.input_text;
export const ComponentColors$ComponentColors$header_background = (value) =>
  value.header_background;
export const ComponentColors$ComponentColors$11 = (value) =>
  value.header_background;
export const ComponentColors$ComponentColors$header_text = (value) =>
  value.header_text;
export const ComponentColors$ComponentColors$12 = (value) => value.header_text;
export const ComponentColors$ComponentColors$border = (value) => value.border;
export const ComponentColors$ComponentColors$13 = (value) => value.border;
export const ComponentColors$ComponentColors$success = (value) => value.success;
export const ComponentColors$ComponentColors$14 = (value) => value.success;
export const ComponentColors$ComponentColors$danger = (value) => value.danger;
export const ComponentColors$ComponentColors$15 = (value) => value.danger;
export const ComponentColors$ComponentColors$warning = (value) => value.warning;
export const ComponentColors$ComponentColors$16 = (value) => value.warning;

export class ThemeState extends $CustomType {
  constructor(colors, is_loading) {
    super();
    this.colors = colors;
    this.is_loading = is_loading;
  }
}
export const ThemeState$ThemeState = (colors, is_loading) =>
  new ThemeState(colors, is_loading);
export const ThemeState$isThemeState = (value) => value instanceof ThemeState;
export const ThemeState$ThemeState$colors = (value) => value.colors;
export const ThemeState$ThemeState$0 = (value) => value.colors;
export const ThemeState$ThemeState$is_loading = (value) => value.is_loading;
export const ThemeState$ThemeState$1 = (value) => value.is_loading;

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

export class Xs extends $CustomType {}
export const Size$Xs = () => new Xs();
export const Size$isXs = (value) => value instanceof Xs;

export class Sm extends $CustomType {}
export const Size$Sm = () => new Sm();
export const Size$isSm = (value) => value instanceof Sm;

export class Md extends $CustomType {}
export const Size$Md = () => new Md();
export const Size$isMd = (value) => value instanceof Md;

export class Lg extends $CustomType {}
export const Size$Lg = () => new Lg();
export const Size$isLg = (value) => value instanceof Lg;

export class Xl extends $CustomType {}
export const Size$Xl = () => new Xl();
export const Size$isXl = (value) => value instanceof Xl;

export class Web extends $CustomType {}
export const Device$Web = () => new Web();
export const Device$isWeb = (value) => value instanceof Web;

export class Mobile extends $CustomType {}
export const Device$Mobile = () => new Mobile();
export const Device$isMobile = (value) => value instanceof Mobile;

export class Primary extends $CustomType {}
export const Variant$Primary = () => new Primary();
export const Variant$isPrimary = (value) => value instanceof Primary;

export class Secondary extends $CustomType {}
export const Variant$Secondary = () => new Secondary();
export const Variant$isSecondary = (value) => value instanceof Secondary;

export class Danger extends $CustomType {}
export const Variant$Danger = () => new Danger();
export const Variant$isDanger = (value) => value instanceof Danger;

export class Success extends $CustomType {}
export const Variant$Success = () => new Success();
export const Variant$isSuccess = (value) => value instanceof Success;

export class Outline extends $CustomType {}
export const Variant$Outline = () => new Outline();
export const Variant$isOutline = (value) => value instanceof Outline;

export class Text extends $CustomType {}
export const InputType$Text = () => new Text();
export const InputType$isText = (value) => value instanceof Text;

export class Password extends $CustomType {}
export const InputType$Password = () => new Password();
export const InputType$isPassword = (value) => value instanceof Password;

export class Email extends $CustomType {}
export const InputType$Email = () => new Email();
export const InputType$isEmail = (value) => value instanceof Email;

export class Number extends $CustomType {}
export const InputType$Number = () => new Number();
export const InputType$isNumber = (value) => value instanceof Number;

export class Tel extends $CustomType {}
export const InputType$Tel = () => new Tel();
export const InputType$isTel = (value) => value instanceof Tel;

export class Url extends $CustomType {}
export const InputType$Url = () => new Url();
export const InputType$isUrl = (value) => value instanceof Url;

export class ContainerXs extends $CustomType {}
export const ContainerSize$ContainerXs = () => new ContainerXs();
export const ContainerSize$isContainerXs = (value) =>
  value instanceof ContainerXs;

export class ContainerSm extends $CustomType {}
export const ContainerSize$ContainerSm = () => new ContainerSm();
export const ContainerSize$isContainerSm = (value) =>
  value instanceof ContainerSm;

export class ContainerMd extends $CustomType {}
export const ContainerSize$ContainerMd = () => new ContainerMd();
export const ContainerSize$isContainerMd = (value) =>
  value instanceof ContainerMd;

export class ContainerLg extends $CustomType {}
export const ContainerSize$ContainerLg = () => new ContainerLg();
export const ContainerSize$isContainerLg = (value) =>
  value instanceof ContainerLg;

export class ContainerXl extends $CustomType {}
export const ContainerSize$ContainerXl = () => new ContainerXl();
export const ContainerSize$isContainerXl = (value) =>
  value instanceof ContainerXl;

export class ContainerFull extends $CustomType {}
export const ContainerSize$ContainerFull = () => new ContainerFull();
export const ContainerSize$isContainerFull = (value) =>
  value instanceof ContainerFull;
