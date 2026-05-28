import gleam/dynamic/decode
import gleam/list
import pog
import repository/que/sql as que_sql
import repository/priority/sql as priority_sql
import repository/quetype/sql as quetype_sql
import shared_kernel/queue.{type Queue, Queue}

pub type QueueService {
  QueueService(db: pog.Connection)
}

pub fn queue_service(db: pog.Connection) -> QueueService {
  QueueService(db:)
}

pub fn get_pending_queues(service: QueueService, code: String) -> List(Queue) {
  case que_sql.get_queues_using_terminal_code(service.db, code) {
    Ok(rows) -> list.map(rows.rows, fn(r) { Queue(id: r.id, que_label: r.que_label) })
    _ -> []
  }
}

pub fn get_current_queue(service: QueueService, code: String) -> Queue {
  case que_sql.get_terminal_queue_by_code(service.db, code) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(r) -> Queue(id: r.id, que_label: r.que_label)
      _ -> Queue(id: 0, que_label: "")
    }
    _ -> Queue(id: 0, que_label: "")
  }
}

pub fn get_current_queue_by_terminal_id(
  service: QueueService,
  terminal_id: Int,
) -> Queue {
  case que_sql.get_terminal_queue_by_id(service.db, terminal_id) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(r) -> Queue(id: r.id, que_label: r.que_label)
      _ -> Queue(id: 0, que_label: "")
    }
    _ -> Queue(id: 0, que_label: "")
  }
}

pub fn next_queue(
  service: QueueService,
  terminal_id: Int,
) -> Result(Queue, Nil) {
  case que_sql.next_queue(service.db, terminal_id) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(r) -> Ok(Queue(id: r.id, que_label: r.que_label))
      _ -> Error(Nil)
    }
    _ -> Error(Nil)
  }
}

pub fn recall_queue(
  service: QueueService,
  terminal_id: Int,
) -> Result(Nil, Nil) {
  case que_sql.clear_terminal_queue(service.db, terminal_id) {
    Ok(_) -> Ok(Nil)
    _ -> Error(Nil)
  }
}

pub type PriorityItem {
  PriorityItem(id: Int, name: String)
}

pub type QueTypeItem {
  QueTypeItem(id: Int, name: String)
}

pub fn get_active_priorities(
  service: QueueService,
) -> List(PriorityItem) {
  case priority_sql.get_all_active_priority(service.db, 100, 0) {
    Ok(data) ->
      list.map(data.rows, fn(r) { PriorityItem(id: r.id, name: r.name) })
    _ -> []
  }
}

pub fn get_queue_types(
  service: QueueService,
) -> List(QueTypeItem) {
  case quetype_sql.get_quetype_with_limit_offset(service.db, 100, 0) {
    Ok(data) ->
      list.map(data.rows, fn(r) { QueTypeItem(id: r.id, name: r.name) })
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
  service: QueueService,
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
    Ok(_) -> QueueCreated
    _ -> QueueFailed("Failed to create queue")
  }
}
