import gleam/list
import gleam/option.{type Option, Some, None}
import pog
import repository/display/sql as display_sql
import repository/display_terminal/sql as display_terminal_sql
import shared_kernel/display.{type Display, Display}

pub type TerminalInfo {
  TerminalInfo(terminal_id: Int, code: String, name: String, que_label: String)
}

pub type DisplayService {
  DisplayService(db: pog.Connection)
}

pub fn display_service(db: pog.Connection) -> DisplayService {
  DisplayService(db:)
}

pub fn find_by_code(service: DisplayService, code: String) -> Option(Display) {
  case display_sql.get_display_by_code(service.db, code) {
    Ok(rows) -> case list.first(rows.rows) {
      Ok(row) -> Some(Display(
        id: row.id,
        code: row.code,
        name: row.name,
        active: row.active,
        created_at: row.create_at,
        now_serving_size: row.now_serving_size,
        media_width: row.media_width,
        terminal_div_width: row.terminal_div_width,
        cols: row.cols,
        rows: row.rows,
        name_size: row.name_size,
        que_label_size: row.que_label_size,
        que_no_size: row.que_no_size,
        date_time_size: row.date_time_size,
      ))
      _ -> None
    }
    _ -> None
  }
}

pub fn get_terminals(
  service: DisplayService,
  display_id: Int,
  limit: Int,
) -> List(TerminalInfo) {
  case display_terminal_sql.get_display_terminals(service.db, display_id, limit) {
    Ok(rows) ->
      list.map(rows.rows, fn(r) {
        TerminalInfo(
          terminal_id: r.id,
          code: r.code,
          name: r.name,
          que_label: r.que_label,
        )
      })
    _ -> []
  }
}

pub fn group_into_rows(
  terminals: List(TerminalInfo),
  cols: Int,
) -> List(List(TerminalInfo)) {
  case terminals {
    [] -> []
    _ -> [list.take(terminals, cols), ..group_into_rows(list.drop(terminals, cols), cols)]
  }
}
