import gleam/otp/static_supervisor
import apps/terminal/public as terminal_mod
import pog

pub opaque type TerminalApp {
  TerminalApp(service: terminal_mod.TerminalService)
}

pub fn start(db: pog.Connection) -> TerminalApp {
  let assert Ok(_) =
    static_supervisor.start(
      static_supervisor.new(static_supervisor.OneForOne),
    )
  TerminalApp(service: terminal_mod.terminal_service(db))
}

pub fn get_service(app: TerminalApp) -> terminal_mod.TerminalService {
  app.service
}
