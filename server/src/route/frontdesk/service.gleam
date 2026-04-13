import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/frontdesk/sql as frontdesk_sql
import shared/frontdesk as shared_frontdesk

pub type FrontDeskError {
  DatabaseError(json.Json)
  NotFound
}

pub fn get_frontdesk_by_code(
  code: String,
  db: pog.Connection,
) -> Result(shared_frontdesk.FrontDesk, FrontDeskError) {
  case frontdesk_sql.get_frontdesk_by_code(db, code) {
    Ok(x) if x.count == 1 -> Ok(getfrontdeskbycoderow_to_frontdesk(x.rows))
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
    _ -> Error(NotFound)
  }
}

fn getfrontdeskbycoderow_to_frontdesk(
  frontdesk: List(frontdesk_sql.GetFrontdeskByCodeRow),
) -> shared_frontdesk.FrontDesk {
  let assert Ok(row) = list.first(frontdesk)

  shared_frontdesk.FrontDesk(
    id: row.id,
    create_at: row.create_at,
    code: row.code,
    name: row.name,
    active: row.active,
    title_fontsize: row.title_fontsize,
    option_fontsize: row.option_fontsize,
    icon_height: row.icon_height,
    icon_width: row.icon_width,
    priority_cols: row.priority_cols,
    priority_rows: row.priority_rows,
    transaction_cols: row.transaction_cols,
    transaction_rows: row.transaction_rows,
  )
}

pub fn frontdesk_error_to_json(error: FrontDeskError) -> json.Json {
  case error {
    DatabaseError(e) -> e
    NotFound -> json.object([#("message", json.string("Frontdesk not found"))])
  }
}
