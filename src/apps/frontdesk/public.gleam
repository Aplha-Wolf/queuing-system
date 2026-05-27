import gleam/dynamic/decode
import gleam/erlang/process
import gleam/list
import gleam/option.{type Option}
import pog
import repository/frontdesk/sql as frontdesk_sql
import repository/priority/sql as priority_sql
import repository/quetype/sql as quetype_sql
import repository/que/sql as que_sql
import modules/notifications/public as notifications

pub type FrontdeskInfo {
  FrontdeskInfo(id: Int, code: String, name: String, active: Bool)
}

pub type PriorityItem {
  PriorityItem(id: Int, name: String)
}

pub type QueTypeItem {
  QueTypeItem(id: Int, name: String)
}

pub type FrontdeskService {
  FrontdeskService(
    db: pog.Connection,
    notifications: notifications.NotificationBus,
  )
}

pub fn frontdesk_service(
  db: pog.Connection,
  notifications_bus: notifications.NotificationBus,
) -> FrontdeskService {
  FrontdeskService(db:, notifications: notifications_bus)
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

pub fn get_active_priorities(service: FrontdeskService) -> List(PriorityItem) {
  case priority_sql.get_all_active_priority(service.db, 100, 0) {
    Ok(data) -> list.map(data.rows, fn(r) { PriorityItem(id: r.id, name: r.name) })
    _ -> []
  }
}

pub fn get_queue_types(service: FrontdeskService) -> List(QueTypeItem) {
  case quetype_sql.get_quetype_with_limit_offset(service.db, 100, 0) {
    Ok(data) -> list.map(data.rows, fn(r) { QueTypeItem(id: r.id, name: r.name) })
    _ -> []
  }
}

fn query_single_int(
  db: pog.Connection,
  sql: String,
  params: List(pog.Value),
) -> Int {
  let decoder = {
    use v <- decode.field(0, decode.int)
    decode.success(v)
  }
  let q = pog.query(sql)
  let q = list.fold(params, q, fn(acc, p) { pog.parameter(acc, p) })
  case pog.returning(q, decoder) |> pog.execute(db) {
    Ok(data) -> case list.first(data.rows) {
      Ok(v) -> v
      _ -> 0
    }
    _ -> 0
  }
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
  let reset_id = query_single_int(
    service.db,
    "SELECT id FROM reset ORDER BY id DESC LIMIT 1",
    [],
  )
  let next_no = query_single_int(
    service.db,
    "SELECT COALESCE(MAX(que_no), 0) + 1 FROM que WHERE quetype_id = $1 AND reset_id = $2",
    [pog.int(quetype_id), pog.int(reset_id)],
  )
  case que_sql.add_queue(service.db, reset_id, quetype_id, priority_id, next_no) {
    Ok(_) -> {
      process.send(service.notifications, notifications.Broadcast(notifications.QueueCreated))
      QueueCreated
    }
    _ -> QueueFailed("Failed to create queue")
  }
}
