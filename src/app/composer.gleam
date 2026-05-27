import apps/terminal/app as terminal_app
import apps/display/app as display_app
import apps/frontdesk/app as frontdesk_app
import apps/settings/app as settings_app
import apps/terminal/public as terminal_mod
import apps/display/public as display_mod
import apps/frontdesk/public as frontdesk_mod
import apps/settings/public as settings_mod
import helpers/env_loader
import helpers/sql as sql_helper
import modules/notifications/public as notifications
import pog

pub type App {
  App(
    terminal: terminal_mod.TerminalService,
    display: display_mod.DisplayService,
    frontdesk: frontdesk_mod.FrontdeskService,
    settings: settings_mod.SettingsService,
    notifications: notifications.NotificationBus,
    db: pog.Connection,
  )
}

pub fn bootstrap() -> App {
  env_loader.load_env_file("./.env")
  let assert Ok(pool) = sql_helper.start_db_pool()
  let db = sql_helper.db_connection(pool)

  let assert Ok(notif_started) = notifications.start()
  let notif_bus = notif_started.data

  App(
    terminal: terminal_app.get_service(terminal_app.start(db)),
    display: display_app.get_service(display_app.start(db)),
    frontdesk: frontdesk_app.get_service(
      frontdesk_app.start(db, notif_bus),
    ),
    settings: settings_app.get_service(settings_app.start(db)),
    notifications: notif_bus,
    db: db,
  )
}
