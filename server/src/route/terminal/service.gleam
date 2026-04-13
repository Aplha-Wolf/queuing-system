import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/terminal/sql as terminal_sql
import shared/terminal as shared_terminal

pub type TerminalList {
  TerminalList(count: Int, terminals: List(shared_terminal.Terminal))
}

pub type AddTerminalResult {
  AddTerminalResult(insert_id: Int)
}

pub type UpdateTerminalResult {
  UpdateTerminalResult(message: String)
}

pub type DeleteTerminalResult {
  DeleteTerminalResult(message: String)
}

pub type TerminalError {
  DatabaseError(json.Json)
  NotFound
  InsertFailed
}

pub fn list_all_terminals(
  db: pog.Connection,
) -> Result(TerminalList, TerminalError) {
  case terminal_sql.list_all_terminals(db) {
    Ok(x) -> {
      Ok(TerminalList(
        count: x.count,
        terminals: listallterminalsrow_to_terminals(x.rows, []),
      ))
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn listallterminalsrow_to_terminals(
  in: List(terminal_sql.ListAllTerminalsRow),
  out: List(shared_terminal.Terminal),
) -> List(shared_terminal.Terminal) {
  case in {
    [] -> out
    [x, ..y] ->
      listallterminalsrow_to_terminals(
        y,
        list.append(out, [listallterminals_to_terminal(x)]),
      )
  }
}

fn listallterminals_to_terminal(
  terminal: terminal_sql.ListAllTerminalsRow,
) -> shared_terminal.Terminal {
  shared_terminal.Terminal(
    id: terminal.id,
    created_at: terminal.create_at,
    code: terminal.code,
    name: terminal.name,
    active: terminal.active,
  )
}

pub fn add_terminal(
  db: pog.Connection,
  code: String,
  name: String,
) -> Result(AddTerminalResult, TerminalError) {
  case terminal_sql.add_terminal(db, code, name) {
    Ok(ret) ->
      case ret.count > 0 {
        True -> Ok(addterminalrows_to_result(ret.rows))
        False -> Error(InsertFailed)
      }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn addterminalrows_to_result(
  rows: List(terminal_sql.AddTerminalRow),
) -> AddTerminalResult {
  let assert Ok(row) = list.first(rows)
  AddTerminalResult(insert_id: row.id)
}

pub fn update_terminal(
  db: pog.Connection,
  code: String,
  name: String,
  active: Bool,
  id: Int,
) -> Result(UpdateTerminalResult, TerminalError) {
  case terminal_sql.update_teminal(db, code, name, active, id) {
    Ok(_) -> {
      Ok(UpdateTerminalResult(message: "Successfully updated!"))
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn delete_terminal(
  db: pog.Connection,
  id: Int,
) -> Result(DeleteTerminalResult, TerminalError) {
  case terminal_sql.find_terminal_by_id(db, id) {
    Ok(x) ->
      case x.count {
        0 -> Error(NotFound)
        _ ->
          case terminal_sql.delete_terminal(db, id) {
            Ok(_) -> {
              Ok(DeleteTerminalResult(message: "Successfully deleted!"))
            }
            Error(err) ->
              Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
          }
      }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

pub fn find_terminal_by_id(
  db: pog.Connection,
  id: Int,
) -> Result(shared_terminal.Terminal, TerminalError) {
  case terminal_sql.find_terminal_by_id(db, id) {
    Ok(x) -> {
      case x.count {
        0 -> Error(NotFound)
        _ -> Ok(findterminalbyidrow_to_terminal(x.rows))
      }
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn findterminalbyidrow_to_terminal(
  terminals: List(terminal_sql.FindTerminalByIdRow),
) -> shared_terminal.Terminal {
  let assert Ok(row) = list.first(terminals)

  shared_terminal.Terminal(
    id: row.id,
    created_at: row.create_at,
    code: row.code,
    name: row.name,
    active: row.active,
  )
}

pub fn find_terminal_by_name(
  db: pog.Connection,
  name: String,
) -> Result(shared_terminal.Terminal, TerminalError) {
  case terminal_sql.find_terminal_by_name(db, name) {
    Ok(x) -> {
      case x.count {
        0 -> Error(NotFound)
        _ -> Ok(findterminalbynamerow_to_terminal(x.rows))
      }
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn findterminalbynamerow_to_terminal(
  terminals: List(terminal_sql.FindTerminalByNameRow),
) -> shared_terminal.Terminal {
  let assert Ok(row) = list.first(terminals)

  shared_terminal.Terminal(
    id: row.id,
    created_at: row.create_at,
    code: row.code,
    name: row.name,
    active: row.active,
  )
}

pub fn find_terminal_by_code(
  db: pog.Connection,
  code: String,
) -> Result(shared_terminal.Terminal, TerminalError) {
  case terminal_sql.find_terminal_by_code(db, code) {
    Ok(x) -> {
      case x.count {
        0 -> Error(NotFound)
        _ -> Ok(findterminalbycoderow_to_terminal(x.rows))
      }
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn findterminalbycoderow_to_terminal(
  terminals: List(terminal_sql.FindTerminalByCodeRow),
) -> shared_terminal.Terminal {
  let assert Ok(row) = list.first(terminals)

  shared_terminal.Terminal(
    id: row.id,
    created_at: row.create_at,
    code: row.code,
    name: row.name,
    active: row.active,
  )
}

pub fn terminal_error_to_json(error: TerminalError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    NotFound -> json.object([#("message", json.string("Terminal not found"))])
    InsertFailed -> json.object([#("error", json.string("Insert failed!"))])
  }
}

pub fn terminal_list_to_json(list: TerminalList) -> json.Json {
  json.object([
    #("count", json.int(list.count)),
    #(
      "terminals",
      json.preprocessed_array(
        list.map(list.terminals, fn(t) { shared_terminal.to_json(t) }),
      ),
    ),
  ])
}

pub fn add_terminal_result_to_json(result: AddTerminalResult) -> json.Json {
  json.object([#("insert_id", json.int(result.insert_id))])
}

pub fn update_terminal_result_to_json(result: UpdateTerminalResult) -> json.Json {
  json.object([#("message", json.string(result.message))])
}

pub fn delete_terminal_result_to_json(result: DeleteTerminalResult) -> json.Json {
  json.object([#("message", json.string(result.message))])
}
