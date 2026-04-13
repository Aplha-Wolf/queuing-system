import * as $effect from "../lustre/lustre/effect.mjs";
import { map as effect_map, none } from "../lustre/lustre/effect.mjs";
import * as $lustre_elem from "../lustre/lustre/element.mjs";
import { text } from "../lustre/lustre/element.mjs";
import * as $location from "../plinth/plinth/browser/location.mjs";
import * as $window from "../plinth/plinth/browser/window.mjs";
import * as $d from "./display/display.mjs";
import * as $f from "./frontdesk/frontdesk.mjs";
import { toList, CustomType as $CustomType } from "./gleam.mjs";
import * as $router from "./router.mjs";
import * as $s from "./settings/settings.mjs";
import * as $t from "./terminal/terminal.mjs";
import * as $kit from "./ui/kit.mjs";
import { div, h1 } from "./ui/kit.mjs";

export class HomeModel extends $CustomType {}
export const Model$HomeModel = () => new HomeModel();
export const Model$isHomeModel = (value) => value instanceof HomeModel;

export class SettingsModel extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Model$SettingsModel = ($0) => new SettingsModel($0);
export const Model$isSettingsModel = (value) => value instanceof SettingsModel;
export const Model$SettingsModel$0 = (value) => value[0];

export class TerminalModel extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Model$TerminalModel = ($0) => new TerminalModel($0);
export const Model$isTerminalModel = (value) => value instanceof TerminalModel;
export const Model$TerminalModel$0 = (value) => value[0];

export class FrontdeskModel extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Model$FrontdeskModel = ($0) => new FrontdeskModel($0);
export const Model$isFrontdeskModel = (value) =>
  value instanceof FrontdeskModel;
export const Model$FrontdeskModel$0 = (value) => value[0];

export class DisplayModel extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Model$DisplayModel = ($0) => new DisplayModel($0);
export const Model$isDisplayModel = (value) => value instanceof DisplayModel;
export const Model$DisplayModel$0 = (value) => value[0];

export class Navigate extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$Navigate = ($0) => new Navigate($0);
export const Msg$isNavigate = (value) => value instanceof Navigate;
export const Msg$Navigate$0 = (value) => value[0];

export class SettingsMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$SettingsMsg = ($0) => new SettingsMsg($0);
export const Msg$isSettingsMsg = (value) => value instanceof SettingsMsg;
export const Msg$SettingsMsg$0 = (value) => value[0];

export class TerminalMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$TerminalMsg = ($0) => new TerminalMsg($0);
export const Msg$isTerminalMsg = (value) => value instanceof TerminalMsg;
export const Msg$TerminalMsg$0 = (value) => value[0];

export class FrontdeskMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$FrontdeskMsg = ($0) => new FrontdeskMsg($0);
export const Msg$isFrontdeskMsg = (value) => value instanceof FrontdeskMsg;
export const Msg$FrontdeskMsg$0 = (value) => value[0];

export class DisplayMsg extends $CustomType {
  constructor($0) {
    super();
    this[0] = $0;
  }
}
export const Msg$DisplayMsg = ($0) => new DisplayMsg($0);
export const Msg$isDisplayMsg = (value) => value instanceof DisplayMsg;
export const Msg$DisplayMsg$0 = (value) => value[0];

function handle_init_route(route) {
  if (route instanceof $router.HomeRoute) {
    return [new HomeModel(), none()];
  } else if (route instanceof $router.SettingsRoute) {
    let $ = $s.init();
    let model;
    let effect;
    model = $[0];
    effect = $[1];
    return [
      new SettingsModel(model),
      effect_map(effect, (var0) => { return new SettingsMsg(var0); }),
    ];
  } else if (route instanceof $router.TerminalRoute) {
    let code = route.code;
    let $ = $t.init(code);
    let model;
    let effect;
    model = $[0];
    effect = $[1];
    return [
      new TerminalModel(model),
      effect_map(effect, (var0) => { return new TerminalMsg(var0); }),
    ];
  } else if (route instanceof $router.FrontdeskRoute) {
    let code = route.code;
    let $ = $f.init(code);
    let model;
    let effect;
    model = $[0];
    effect = $[1];
    return [
      new FrontdeskModel(model),
      effect_map(effect, (var0) => { return new FrontdeskMsg(var0); }),
    ];
  } else {
    let code = route.code;
    let $ = $d.init(code);
    let model;
    let effect;
    model = $[0];
    effect = $[1];
    return [
      new DisplayModel(model),
      effect_map(effect, (var0) => { return new DisplayMsg(var0); }),
    ];
  }
}

export function init(_) {
  let _pipe = $window.self();
  let _pipe$1 = $window.location(_pipe);
  let _pipe$2 = $location.pathname(_pipe$1);
  let _pipe$3 = $router.parse_route(_pipe$2);
  return handle_init_route(_pipe$3);
}

export function update(model, msg) {
  if (model instanceof HomeModel) {
    if (msg instanceof Navigate) {
      let route = msg[0];
      return handle_init_route(route);
    } else {
      return [model, none()];
    }
  } else if (model instanceof SettingsModel) {
    if (msg instanceof SettingsMsg) {
      let m = model[0];
      let msg$1 = msg[0];
      let $ = $s.update(m, msg$1);
      let new_model;
      let effect;
      new_model = $[0];
      effect = $[1];
      return [
        new SettingsModel(new_model),
        effect_map(effect, (var0) => { return new SettingsMsg(var0); }),
      ];
    } else {
      return [model, none()];
    }
  } else if (model instanceof TerminalModel) {
    if (msg instanceof TerminalMsg) {
      let m = model[0];
      let msg$1 = msg[0];
      let $ = $t.update(m, msg$1);
      let new_model;
      let effect;
      new_model = $[0];
      effect = $[1];
      return [
        new TerminalModel(new_model),
        effect_map(effect, (var0) => { return new TerminalMsg(var0); }),
      ];
    } else {
      return [model, none()];
    }
  } else if (model instanceof FrontdeskModel) {
    if (msg instanceof FrontdeskMsg) {
      let m = model[0];
      let msg$1 = msg[0];
      let $ = $f.update(m, msg$1);
      let new_model;
      let effect;
      new_model = $[0];
      effect = $[1];
      return [
        new FrontdeskModel(new_model),
        effect_map(effect, (var0) => { return new FrontdeskMsg(var0); }),
      ];
    } else {
      return [model, none()];
    }
  } else if (msg instanceof DisplayMsg) {
    let m = model[0];
    let msg$1 = msg[0];
    let $ = $d.update(m, msg$1);
    let new_model;
    let effect;
    new_model = $[0];
    effect = $[1];
    return [
      new DisplayModel(new_model),
      effect_map(effect, (var0) => { return new DisplayMsg(var0); }),
    ];
  } else {
    return [model, none()];
  }
}

function home_view() {
  return div(
    "flex flex-col h-screen w-screen items-center justify-center bg-black",
    toList([
      h1(
        "text-3xl text-white font-extrabold mb-8",
        toList([text("QUEUING SYSTEM")]),
      ),
    ]),
  );
}

export function view(model) {
  if (model instanceof HomeModel) {
    return home_view();
  } else if (model instanceof SettingsModel) {
    let m = model[0];
    return $lustre_elem.map(
      $s.view(m),
      (var0) => { return new SettingsMsg(var0); },
    );
  } else if (model instanceof TerminalModel) {
    let m = model[0];
    return $lustre_elem.map(
      $t.view(m),
      (var0) => { return new TerminalMsg(var0); },
    );
  } else if (model instanceof FrontdeskModel) {
    let m = model[0];
    return $lustre_elem.map(
      $f.view(m),
      (var0) => { return new FrontdeskMsg(var0); },
    );
  } else {
    let m = model[0];
    return $lustre_elem.map(
      $d.view(m),
      (var0) => { return new DisplayMsg(var0); },
    );
  }
}
