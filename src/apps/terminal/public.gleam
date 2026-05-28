import gleam/list
import gleam/option.{type Option, Some, None}
import modules/queue/public as queue_mod
import pog
import repository/terminal/sql as terminal_sql
import shared_kernel/terminal.{type Terminal, Terminal}
import shared_kernel/queue.{type Queue}

pub type TerminalService {
  TerminalService(db: pog.Connection, queues: queue_mod.QueueService)
}

pub fn terminal_service(
  db: pog.Connection,
  queues: queue_mod.QueueService,
) -> TerminalService {
  TerminalService(db:, queues:)
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
  queue_mod.get_pending_queues(service.queues, code)
}

pub fn get_current_queue(service: TerminalService, code: String) -> Queue {
  queue_mod.get_current_queue(service.queues, code)
}

pub fn next_queue(service: TerminalService, terminal_id: Int) -> Result(Queue, Nil) {
  queue_mod.next_queue(service.queues, terminal_id)
}

pub fn recall_queue(service: TerminalService, terminal_id: Int) -> Result(Nil, Nil) {
  queue_mod.recall_queue(service.queues, terminal_id)
}
