import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/display_terminal/sql as display_terminal_sql
import shared/display_terminal as shared_display_terminal

pub type DisplayTerminalError {
  DatabaseError(json.Json)
}

pub fn get_display_terminals(
  db: pog.Connection,
  id: Int,
  limit: Int,
) -> Result(List(shared_display_terminal.DisplayTerminal), DisplayTerminalError) {
  case display_terminal_sql.get_display_terminals(db, id, limit) {
    Ok(x) -> Ok(listaldisplayallterminalsrow_to_displayterminals(x.rows, []))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn listaldisplayallterminalsrow_to_displayterminals(
  in: List(display_terminal_sql.GetDisplayTerminalsRow),
  out: List(shared_display_terminal.DisplayTerminal),
) -> List(shared_display_terminal.DisplayTerminal) {
  case in {
    [] -> out
    [x, ..y] ->
      listaldisplayallterminalsrow_to_displayterminals(
        y,
        list.append(out, [getdisplayterminalsrow_to_displayterminal(x)]),
      )
  }
}

fn getdisplayterminalsrow_to_displayterminal(
  terminal: display_terminal_sql.GetDisplayTerminalsRow,
) -> shared_display_terminal.DisplayTerminal {
  shared_display_terminal.DisplayTerminal(
    id: terminal.id,
    code: terminal.code,
    name: terminal.name,
    que_label: terminal.que_label,
  )
}

pub fn display_terminal_list_to_json(
  terminals: List(shared_display_terminal.DisplayTerminal),
) -> json.Json {
  json.preprocessed_array(
    list.map(terminals, fn(t) { shared_display_terminal.to_json(t) }),
  )
}

pub fn display_terminal_error_to_json(error: DisplayTerminalError) -> json.Json {
  case error {
    DatabaseError(e) -> e
  }
}
