import gleam/otp/static_supervisor
import apps/settings/public as settings_mod
import pog

pub opaque type SettingsApp {
  SettingsApp(service: settings_mod.SettingsService)
}

pub fn start(db: pog.Connection) -> SettingsApp {
  let assert Ok(_) =
    static_supervisor.start(
      static_supervisor.new(static_supervisor.OneForOne),
    )
  SettingsApp(service: settings_mod.settings_service(db))
}

pub fn get_service(app: SettingsApp) -> settings_mod.SettingsService {
  app.service
}
