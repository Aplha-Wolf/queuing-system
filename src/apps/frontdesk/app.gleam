import gleam/otp/static_supervisor
import apps/frontdesk/public as frontdesk_mod
import modules/notifications/public as notifications
import pog

pub opaque type FrontdeskApp {
  FrontdeskApp(service: frontdesk_mod.FrontdeskService)
}

pub fn start(
  db: pog.Connection,
  notification_bus: notifications.NotificationBus,
) -> FrontdeskApp {
  let assert Ok(_) =
    static_supervisor.start(
      static_supervisor.new(static_supervisor.OneForOne),
    )
  FrontdeskApp(service: frontdesk_mod.frontdesk_service(db, notification_bus))
}

pub fn get_service(app: FrontdeskApp) -> frontdesk_mod.FrontdeskService {
  app.service
}
