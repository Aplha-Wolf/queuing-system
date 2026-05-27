import gleam/list
import gleam/option.{type Option, Some, None}
import pog
import repository/terminal/sql as terminal_sql
import repository/que/sql as que_sql
import shared_kernel/terminal.{type Terminal, Terminal}
import shared_kernel/queue.{type Queue, Queue, empty}

pub type TerminalService {
  TerminalService(db: pog.Connection)
}

pub fn terminal_service(db: pog.Connection) -> TerminalService {
  TerminalService(db:)
}

pub fn find_by_code(service: TerminalService, code: String) -> Option(Terminal) {
  case terminal_sql.find_terminal_by_code(service.db, code) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(row) -> Some(Terminal(
        id: row.id,
        created_at: row.create_at,
        code: row.code,
        name: row.name,
        active: row.active,
      ))
      _ -> None
    }
    _ -> None
  }
}

pub fn get_pending_queues(service: TerminalService, code: String) -> List(Queue) {
  case que_sql.get_queues_using_terminal_code(service.db, code) {
    Ok(rows) -> list.map(rows.rows, fn(r) { Queue(id: r.id, que_label: r.que_label) })
    _ -> []
  }
}

pub fn get_current_queue(service: TerminalService, code: String) -> Queue {
  case que_sql.get_terminal_queue_by_code(service.db, code) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(r) -> Queue(id: r.id, que_label: r.que_label)
      _ -> empty()
    }
    _ -> empty()
  }
}

pub fn next_queue(service: TerminalService, terminal_id: Int) -> Result(Queue, Nil) {
  case que_sql.next_queue(service.db, terminal_id) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(r) -> Ok(Queue(id: r.id, que_label: r.que_label))
      _ -> Error(Nil)
    }
    _ -> Error(Nil)
  }
}

pub fn recall_queue(service: TerminalService, terminal_id: Int) -> Result(Nil, Nil) {
  case que_sql.clear_terminal_queue(service.db, terminal_id) {
    Ok(_) -> Ok(Nil)
    _ -> Error(Nil)
  }
}
