import * as $string from "../gleam_stdlib/gleam/string.mjs";
import { CustomType as $CustomType } from "./gleam.mjs";

export class HomeRoute extends $CustomType {}
export const Route$HomeRoute = () => new HomeRoute();
export const Route$isHomeRoute = (value) => value instanceof HomeRoute;

export class SettingsRoute extends $CustomType {}
export const Route$SettingsRoute = () => new SettingsRoute();
export const Route$isSettingsRoute = (value) => value instanceof SettingsRoute;

export class TerminalRoute extends $CustomType {
  constructor(code) {
    super();
    this.code = code;
  }
}
export const Route$TerminalRoute = (code) => new TerminalRoute(code);
export const Route$isTerminalRoute = (value) => value instanceof TerminalRoute;
export const Route$TerminalRoute$code = (value) => value.code;
export const Route$TerminalRoute$0 = (value) => value.code;

export class FrontdeskRoute extends $CustomType {
  constructor(code) {
    super();
    this.code = code;
  }
}
export const Route$FrontdeskRoute = (code) => new FrontdeskRoute(code);
export const Route$isFrontdeskRoute = (value) =>
  value instanceof FrontdeskRoute;
export const Route$FrontdeskRoute$code = (value) => value.code;
export const Route$FrontdeskRoute$0 = (value) => value.code;

export class DisplayRoute extends $CustomType {
  constructor(code) {
    super();
    this.code = code;
  }
}
export const Route$DisplayRoute = (code) => new DisplayRoute(code);
export const Route$isDisplayRoute = (value) => value instanceof DisplayRoute;
export const Route$DisplayRoute$code = (value) => value.code;
export const Route$DisplayRoute$0 = (value) => value.code;

export function parse_route(path) {
  if (path === "/") {
    return new HomeRoute();
  } else if (path === "/settings") {
    return new SettingsRoute();
  } else if (path === "/terminal") {
    return new TerminalRoute("default");
  } else if (path === "/terminal/") {
    return new TerminalRoute("default");
  } else if (path.startsWith("/terminal/")) {
    let code = path.slice(10);
    return new TerminalRoute($string.trim(code));
  } else if (path === "/frontdesk") {
    return new FrontdeskRoute("default");
  } else if (path === "/frontdesk/") {
    return new FrontdeskRoute("default");
  } else if (path.startsWith("/frontdesk/")) {
    let code = path.slice(11);
    return new FrontdeskRoute($string.trim(code));
  } else if (path === "/display") {
    return new DisplayRoute("default");
  } else if (path === "/display/") {
    return new DisplayRoute("default");
  } else if (path.startsWith("/display/")) {
    let code = path.slice(9);
    return new DisplayRoute($string.trim(code));
  } else {
    return new HomeRoute();
  }
}

export function route_to_path(route) {
  if (route instanceof HomeRoute) {
    return "/";
  } else if (route instanceof SettingsRoute) {
    return "/settings";
  } else if (route instanceof TerminalRoute) {
    let code = route.code;
    return "/terminal/" + code;
  } else if (route instanceof FrontdeskRoute) {
    let code = route.code;
    return "/frontdesk/" + code;
  } else {
    let code = route.code;
    return "/display/" + code;
  }
}
