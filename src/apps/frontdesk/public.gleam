import gleam/erlang/process
import gleam/list
import gleam/option.{type Option}
import modules/notifications/public as notifications
import modules/queue/public as queue_mod
import pog
import repository/frontdesk/sql as frontdesk_sql

pub type FrontdeskInfo {
  FrontdeskInfo(id: Int, code: String, name: String, active: Bool)
}

pub type FrontdeskService {
  FrontdeskService(
    db: pog.Connection,
    queues: queue_mod.QueueService,
    notifications: notifications.NotificationBus,
  )
}

pub fn frontdesk_service(
  db: pog.Connection,
  queues: queue_mod.QueueService,
  notifications_bus: notifications.NotificationBus,
) -> FrontdeskService {
  FrontdeskService(db:, queues:, notifications: notifications_bus)
}

pub fn find_by_code(service: FrontdeskService, code: String) -> Option(FrontdeskInfo) {
  case frontdesk_sql.get_frontdesk_by_code(service.db, code) {
    Ok(data) -> case list.first(data.rows) {
      Ok(row) -> option.Some(FrontdeskInfo(
        id: row.id,
        code: row.code,
        name: row.name,
        active: row.active,
      ))
      _ -> option.None
    }
    _ -> option.None
  }
}

pub fn get_active_priorities(
  service: FrontdeskService,
) -> List(queue_mod.PriorityItem) {
  queue_mod.get_active_priorities(service.queues)
}

pub fn get_queue_types(
  service: FrontdeskService,
) -> List(queue_mod.QueTypeItem) {
  queue_mod.get_queue_types(service.queues)
}

pub type CreateQueueResult {
  QueueCreated
  QueueFailed(String)
}

pub fn create_queue(
  service: FrontdeskService,
  priority_id: Int,
  quetype_id: Int,
) -> CreateQueueResult {
  case queue_mod.create_queue(service.queues, priority_id, quetype_id) {
    queue_mod.QueueCreated -> {
      process.send(
        service.notifications,
        notifications.Broadcast(notifications.QueueCreated),
      )
      QueueCreated
    }
    queue_mod.QueueFailed(err) -> QueueFailed(err)
  }
}
