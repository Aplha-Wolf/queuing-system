import gleam/string

pub type Route {
  HomeRoute
  SettingsRoute
  TerminalRoute(code: String)
  FrontdeskRoute(code: String)
  DisplayRoute(code: String)
}

pub fn parse_route(path: String) -> Route {
  case path {
    "/" -> HomeRoute
    "/settings" -> SettingsRoute
    "/terminal" -> TerminalRoute(code: "default")
    "/terminal/" -> TerminalRoute(code: "default")
    "/terminal/" <> code -> TerminalRoute(code: string.trim(code))
    "/frontdesk" -> FrontdeskRoute(code: "default")
    "/frontdesk/" -> FrontdeskRoute(code: "default")
    "/frontdesk/" <> code -> FrontdeskRoute(code: string.trim(code))
    "/display" -> DisplayRoute(code: "default")
    "/display/" -> DisplayRoute(code: "default")
    "/display/" <> code -> DisplayRoute(code: string.trim(code))
    _ -> HomeRoute
  }
}

pub fn route_to_path(route: Route) -> String {
  case route {
    HomeRoute -> "/"
    SettingsRoute -> "/settings"
    TerminalRoute(code) -> "/terminal/" <> code
    FrontdeskRoute(code) -> "/frontdesk/" <> code
    DisplayRoute(code) -> "/display/" <> code
  }
}
