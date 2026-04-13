import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/priority/sql as priority_sql
import shared/priority as shared_priority

pub type PriorityListResponse {
  PriorityListResponse(
    status: Int,
    message: String,
    page: shared_priority.Page,
    data: List(shared_priority.Priority),
  )
}

pub type PriorityError {
  DatabaseError(json.Json)
}

pub fn get_active_priority_with_limit_offset(
  db: pog.Connection,
  limit: Int,
  offset: Int,
) -> Result(PriorityListResponse, PriorityError) {
  case priority_sql.get_all_active_priority(db, limit, offset) {
    Ok(x) -> {
      let total = get_no_of_active_priority(db)
      Ok(PriorityListResponse(
        status: 200,
        message: "",
        page: shared_priority.Page(count: x.count, total: total),
        data: getallactivepriorityrows_to_priority(x.rows, []),
      ))
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn getallactivepriorityrows_to_priority(
  in: List(priority_sql.GetAllActivePriorityRow),
  out: List(shared_priority.Priority),
) -> List(shared_priority.Priority) {
  case in {
    [] -> out
    [x, ..y] ->
      getallactivepriorityrows_to_priority(
        y,
        list.append(out, [allactivepriorityrows_to_priority(x)]),
      )
  }
}

fn allactivepriorityrows_to_priority(
  priority: priority_sql.GetAllActivePriorityRow,
) -> shared_priority.Priority {
  shared_priority.Priority(
    id: priority.id,
    create_at: priority.create_at,
    name: priority.name,
    icon: priority.icon,
    level: priority.level,
    prefix: priority.prefix,
    active: priority.active,
  )
}

fn get_no_of_active_priority(db: pog.Connection) -> Int {
  case priority_sql.get_no_of_active_priority(db) {
    Ok(x) if x.count == 1 -> {
      let assert Ok(row) = list.first(x.rows)
      row.total_count
    }
    _ -> 0
  }
}

pub fn priority_list_response_to_json(resp: PriorityListResponse) -> json.Json {
  json.object([
    #("status", json.int(resp.status)),
    #("message", json.string(resp.message)),
    #("page", shared_priority.page_to_json(resp.page)),
    #(
      "data",
      json.preprocessed_array(
        list.map(resp.data, fn(p) { shared_priority.to_json(p) }),
      ),
    ),
  ])
}

pub fn priority_error_to_json(error: PriorityError) -> json.Json {
  case error {
    DatabaseError(e) -> e
  }
}
