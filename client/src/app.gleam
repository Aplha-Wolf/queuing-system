import display/display as d
import frontdesk/frontdesk as f
import lustre/effect.{type Effect, map as effect_map, none}
import lustre/element.{text} as lustre_elem
import plinth/browser/location
import plinth/browser/window
import router
import settings/settings as s
import terminal/terminal as t
import ui/kit.{div, h1}

pub type Model {
  HomeModel
  SettingsModel(s.Model)
  TerminalModel(t.Model)
  FrontdeskModel(f.Model)
  DisplayModel(d.Model)
}

pub type Msg {
  Navigate(router.Route)
  SettingsMsg(s.Msg)
  TerminalMsg(t.Msg)
  FrontdeskMsg(f.Msg)
  DisplayMsg(d.Msg)
}

pub fn init(_args: Nil) -> #(Model, Effect(Msg)) {
  window.self()
  |> window.location()
  |> location.pathname()
  |> router.parse_route()
  |> handle_init_route()
}

fn handle_init_route(route: router.Route) -> #(Model, Effect(Msg)) {
  case route {
    router.SettingsRoute -> {
      let #(model, effect) = s.init()
      #(SettingsModel(model), effect_map(effect, SettingsMsg))
    }
    router.TerminalRoute(code) -> {
      let #(model, effect) = t.init(code)
      #(TerminalModel(model), effect_map(effect, TerminalMsg))
    }
    router.FrontdeskRoute(code) -> {
      let #(model, effect) = f.init(code)
      #(FrontdeskModel(model), effect_map(effect, FrontdeskMsg))
    }
    router.DisplayRoute(code) -> {
      let #(model, effect) = d.init(code)
      #(DisplayModel(model), effect_map(effect, DisplayMsg))
    }
    router.HomeRoute -> #(HomeModel, none())
  }
}

pub fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case model, msg {
    HomeModel, Navigate(route) -> handle_init_route(route)
    SettingsModel(m), SettingsMsg(msg) -> {
      let #(new_model, effect) = s.update(m, msg)
      #(SettingsModel(new_model), effect_map(effect, SettingsMsg))
    }
    TerminalModel(m), TerminalMsg(msg) -> {
      let #(new_model, effect) = t.update(m, msg)
      #(TerminalModel(new_model), effect_map(effect, TerminalMsg))
    }
    FrontdeskModel(m), FrontdeskMsg(msg) -> {
      let #(new_model, effect) = f.update(m, msg)
      #(FrontdeskModel(new_model), effect_map(effect, FrontdeskMsg))
    }
    DisplayModel(m), DisplayMsg(msg) -> {
      let #(new_model, effect) = d.update(m, msg)
      #(DisplayModel(new_model), effect_map(effect, DisplayMsg))
    }
    _, _ -> #(model, none())
  }
}

pub fn view(model: Model) -> lustre_elem.Element(Msg) {
  case model {
    HomeModel -> home_view()
    SettingsModel(m) -> lustre_elem.map(s.view(m), SettingsMsg)
    TerminalModel(m) -> lustre_elem.map(t.view(m), TerminalMsg)
    FrontdeskModel(m) -> lustre_elem.map(f.view(m), FrontdeskMsg)
    DisplayModel(m) -> lustre_elem.map(d.view(m), DisplayMsg)
  }
}

fn home_view() -> lustre_elem.Element(Msg) {
  div("flex flex-col h-screen w-screen items-center justify-center bg-black", [
    h1("text-3xl text-white font-extrabold mb-8", [
      text("QUEUING SYSTEM"),
    ]),
  ])
}
