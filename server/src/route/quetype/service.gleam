import gleam/json
import gleam/list
import helpers/sql as sql_helper
import pog
import route/quetype/sql as quetype_sql
import shared/quetype as shared_quetype

pub type QuetypeListResponse {
  QuetypeListResponse(
    status: Int,
    message: String,
    page: shared_quetype.Page,
    data: List(shared_quetype.QueType),
  )
}

pub type QuetypeError {
  DatabaseError(json.Json)
}

pub fn get_all_quetype_with_limit_offset(
  db: pog.Connection,
  limit: Int,
  offset: Int,
) -> Result(QuetypeListResponse, QuetypeError) {
  case quetype_sql.get_quetype_with_limit_offset(db, limit, offset) {
    Ok(x) -> {
      let total = get_no_of_active_quetype(db)
      Ok(QuetypeListResponse(
        status: 200,
        message: "",
        page: shared_quetype.Page(count: x.count, total: total),
        data: quetypelistwithlimitoffsetrows_to_quetype(x.rows, []),
      ))
    }
    Error(err) -> Error(DatabaseError(sql_helper.pgo_queryerror_tojson(err)))
  }
}

fn quetypelistwithlimitoffsetrow_to_quetype(
  row: quetype_sql.GetQuetypeWithLimitOffsetRow,
) -> shared_quetype.QueType {
  shared_quetype.QueType(
    id: row.id,
    create_at: row.create_at,
    name: row.name,
    icon: row.icon,
    prefix: row.prefix,
    active: row.active,
  )
}

fn quetypelistwithlimitoffsetrows_to_quetype(
  in: List(quetype_sql.GetQuetypeWithLimitOffsetRow),
  out: List(shared_quetype.QueType),
) -> List(shared_quetype.QueType) {
  case in {
    [] -> out
    [x, ..y] ->
      quetypelistwithlimitoffsetrows_to_quetype(
        y,
        list.append(out, [quetypelistwithlimitoffsetrow_to_quetype(x)]),
      )
  }
}

fn get_no_of_active_quetype(db: pog.Connection) -> Int {
  case quetype_sql.get_no_of_active_quetype(db) {
    Ok(x) if x.count == 1 -> {
      let assert Ok(row) = list.first(x.rows)
      row.total_count
    }
    _ -> 0
  }
}

pub fn quetype_list_response_to_json(resp: QuetypeListResponse) -> json.Json {
  json.object([
    #("status", json.int(resp.status)),
    #("message", json.string(resp.message)),
    #("page", shared_quetype.page_to_json(resp.page)),
    #(
      "data",
      json.preprocessed_array(
        list.map(resp.data, fn(q) { shared_quetype.to_json(q) }),
      ),
    ),
  ])
}

pub fn quetype_error_to_json(error: QuetypeError) -> json.Json {
  case error {
    DatabaseError(e) -> e
  }
}
