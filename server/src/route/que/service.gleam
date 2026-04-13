import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/que/sql as que_sql
import route/terminal/service as terminal_service
import shared/queue as shared_queue
import shared/terminal as shared_terminal

pub type TerminalInfo {
  TerminalInfo(
    terminal: shared_terminal.Terminal,
    current: shared_queue.Queue,
    queues: List(shared_queue.Queue),
  )
}

pub type QueError {
  DatabaseError(json.Json)
  TerminalNotFound
  QueueNotFound
}

pub fn show_terminal_info(
  code: String,
  db: pog.Connection,
) -> Result(TerminalInfo, QueError) {
  case terminal_service.find_terminal_by_code(db, code) {
    Ok(terminal) -> {
      case
        get_terminal_queue_by_code(code, db),
        get_terminal_queues_by_code(code, db)
      {
        Ok(current), Ok(queues) -> {
          Ok(TerminalInfo(terminal:, current:, queues:))
        }
        Error(e), _ -> Error(e)
        _, Error(e) -> Error(e)
      }
    }
    Error(terminal_service.NotFound) -> Error(TerminalNotFound)
    Error(terminal_service.InsertFailed) ->
      Error(
        DatabaseError(json.object([#("error", json.string("Insert failed!"))])),
      )
    Error(terminal_service.DatabaseError(e)) -> Error(DatabaseError(e))
  }
}

pub fn get_terminal_queues_by_code(
  code: String,
  db: pog.Connection,
) -> Result(List(shared_queue.Queue), QueError) {
  case que_sql.get_queues_using_terminal_code(db, code) {
    Ok(x) -> Ok(terminalquecoderow_to_queues(x.rows, []))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn get_terminal_queues_by_id(
  id: Int,
  db: pog.Connection,
) -> Result(List(shared_queue.Queue), QueError) {
  case que_sql.get_queues_using_terminal_id(db, id) {
    Ok(x) -> Ok(terminalqueidrow_to_queues(x.rows, []))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn terminalqueidrow_to_queues(
  in: List(que_sql.GetQueuesUsingTerminalIdRow),
  out: List(shared_queue.Queue),
) -> List(shared_queue.Queue) {
  case in {
    [] -> out
    [x, ..y] ->
      terminalqueidrow_to_queues(
        y,
        list.append(out, [listallterminalqueuesbyid_to_queue(x)]),
      )
  }
}

fn listallterminalqueuesbycode_to_queue(
  queue: que_sql.GetQueuesUsingTerminalCodeRow,
) -> shared_queue.Queue {
  shared_queue.Queue(id: queue.id, que_label: queue.que_label)
}

fn terminalquecoderow_to_queues(
  in: List(que_sql.GetQueuesUsingTerminalCodeRow),
  out: List(shared_queue.Queue),
) -> List(shared_queue.Queue) {
  case in {
    [] -> out
    [x, ..y] ->
      terminalquecoderow_to_queues(
        y,
        list.append(out, [listallterminalqueuesbycode_to_queue(x)]),
      )
  }
}

fn listallterminalqueuesbyid_to_queue(
  queue: que_sql.GetQueuesUsingTerminalIdRow,
) -> shared_queue.Queue {
  shared_queue.Queue(id: queue.id, que_label: queue.que_label)
}

pub fn get_terminal_queue_by_code(
  code: String,
  db: pog.Connection,
) -> Result(shared_queue.Queue, QueError) {
  case que_sql.get_terminal_queue_by_code(db, code) {
    Ok(x) if x.count == 1 -> Ok(getterminalqueuecoderow_to_queue(x.rows))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
    _ -> Ok(shared_queue.Queue(id: 0, que_label: ""))
  }
}

fn getterminalqueuecoderow_to_queue(
  current_queues: List(que_sql.GetTerminalQueueByCodeRow),
) -> shared_queue.Queue {
  let assert Ok(row) = list.first(current_queues)
  shared_queue.Queue(id: row.id, que_label: row.que_label)
}

pub fn get_terminal_queue_by_id(
  id: Int,
  db: pog.Connection,
) -> Result(shared_queue.Queue, QueError) {
  case que_sql.get_terminal_queue_by_id(db, id) {
    Ok(x) if x.count == 1 -> Ok(getterminalqueueidrow_to_queue(x.rows))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
    _ -> Ok(shared_queue.Queue(id: 0, que_label: ""))
  }
}

fn getterminalqueueidrow_to_queue(
  current_queues: List(que_sql.GetTerminalQueueByIdRow),
) -> shared_queue.Queue {
  let assert Ok(row) = list.first(current_queues)
  shared_queue.Queue(id: row.id, que_label: row.que_label)
}

pub fn next_queue(
  id: Int,
  db: pog.Connection,
) -> Result(shared_queue.Queue, QueError) {
  case que_sql.clear_terminal_queue(db, id) {
    Ok(_) ->
      case que_sql.next_queue(db, id) {
        Ok(x) if x.count == 1 -> Ok(nextquerow_to_queue(x.rows))
        Error(err) ->
          Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
        _ -> Ok(shared_queue.Queue(id: 0, que_label: ""))
      }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn nextquerow_to_queue(rows: List(que_sql.NextQueueRow)) -> shared_queue.Queue {
  let assert Ok(row) = list.first(rows)
  shared_queue.Queue(id: row.id, que_label: row.que_label)
}

pub fn terminal_info_to_json(info: TerminalInfo) -> json.Json {
  json.object([
    #("terminal", shared_terminal.to_json(info.terminal)),
    #("current", shared_queue.to_json(info.current)),
    #(
      "queues",
      json.preprocessed_array(
        list.map(info.queues, fn(q) { shared_queue.to_json(q) }),
      ),
    ),
  ])
}

pub fn que_list_to_json(queues: List(shared_queue.Queue)) -> json.Json {
  json.preprocessed_array(list.map(queues, fn(q) { shared_queue.to_json(q) }))
}

pub fn que_error_to_json(error: QueError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    TerminalNotFound ->
      json.object([#("message", json.string("Terminal not found"))])
    QueueNotFound -> json.object([#("message", json.string("Queue not found"))])
  }
}
