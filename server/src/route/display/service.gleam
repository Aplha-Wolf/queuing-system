import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/display/sql as display_sql
import shared/display as shared_display

pub type DisplayError {
  DatabaseError(json.Json)
  NotFound
}

pub fn get_display_by_code(
  db: pog.Connection,
  code: String,
) -> Result(shared_display.Display, DisplayError) {
  case display_sql.get_display_by_code(db, code) {
    Ok(x) if x.count == 1 -> Ok(getdisplaybycode_to_display(x.rows))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
    _ -> Error(NotFound)
  }
}

fn getdisplaybycode_to_display(
  display: List(display_sql.GetDisplayByCodeRow),
) -> shared_display.Display {
  let assert Ok(display) = list.first(display)

  shared_display.Display(
    id: display.id,
    code: display.code,
    name: display.name,
    active: display.active,
    created_at: display.create_at,
    now_serving_size: display.now_serving_size,
    media_width: display.media_width,
    terminal_div_width: display.terminal_div_width,
    cols: display.cols,
    rows: display.rows,
    name_size: display.name_size,
    que_label_size: display.que_label_size,
    que_no_size: display.que_no_size,
    date_time_size: display.date_time_size,
  )
}

pub fn get_display_by_id(
  db: pog.Connection,
  id: Int,
) -> Result(shared_display.Display, DisplayError) {
  case display_sql.get_display_by_id(db, id) {
    Ok(x) if x.count == 1 -> Ok(getdisplaybyid_to_display(x.rows))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
    _ -> Error(NotFound)
  }
}

fn getdisplaybyid_to_display(
  display: List(display_sql.GetDisplayByIdRow),
) -> shared_display.Display {
  let assert Ok(display) = list.first(display)

  shared_display.Display(
    id: display.id,
    code: display.code,
    name: display.name,
    active: display.active,
    created_at: display.create_at,
    now_serving_size: display.now_serving_size,
    media_width: display.media_width,
    terminal_div_width: display.terminal_div_width,
    cols: display.cols,
    rows: display.rows,
    name_size: display.name_size,
    que_label_size: display.que_label_size,
    que_no_size: display.que_no_size,
    date_time_size: display.date_time_size,
  )
}

pub fn display_error_to_json(error: DisplayError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    NotFound -> json.object([#("message", json.string("Display not found"))])
  }
}
