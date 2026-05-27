import gleam/otp/static_supervisor
import apps/display/public as display_mod
import pog

pub opaque type DisplayApp {
  DisplayApp(service: display_mod.DisplayService)
}

pub fn start(db: pog.Connection) -> DisplayApp {
  let assert Ok(_) =
    static_supervisor.start(
      static_supervisor.new(static_supervisor.OneForOne),
    )
  DisplayApp(service: display_mod.display_service(db))
}

pub fn get_service(app: DisplayApp) -> display_mod.DisplayService {
  app.service
}
