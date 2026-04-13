import common/common
import envoy
import gleam/erlang/process
import gleam/json
import gleam/otp/static_supervisor
import pog

fn read_connection_uri() -> Result(pog.Config, Nil) {
  case envoy.get("DATABASE_URL") {
    Ok(config) -> {
      let name: process.Name(pog.Message) = process.new_name("db_pool")
      pog.url_config(name, config)
    }
    Error(_) -> Error(Nil)
  }
}

pub fn start_db_pool() -> Result(process.Name(pog.Message), Nil) {
  case read_connection_uri() {
    Ok(config) -> {
      let name = config.pool_name
      let pool_child =
        config
        |> pog.pool_size(15)
        |> pog.supervised

      let assert Ok(_) =
        static_supervisor.new(static_supervisor.RestForOne)
        |> static_supervisor.add(pool_child)
        |> static_supervisor.start

      Ok(name)
    }
    Error(_) -> Error(Nil)
  }
}

pub fn db_connection(pool: process.Name(pog.Message)) -> pog.Connection {
  pog.named_connection(pool)
}

pub fn pgo_queryerror_tojson(error: pog.QueryError) -> json.Json {
  case error {
    pog.ConstraintViolated(message, constraint, detail) ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.string(message)),
              #("error2", json.string(constraint)),
              #("error3", json.string(detail)),
            ]),
          ]),
        ),
      ])
    pog.PostgresqlError(code, message, name) ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("code", json.string(code)),
              #("message", json.string(message)),
              #("name", json.string(name)),
            ]),
          ]),
        ),
      ])
    pog.UnexpectedArgumentCount(expected, get) ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.int(expected)),
              #("error2", json.int(get)),
              #("error3", json.string("")),
            ]),
          ]),
        ),
      ])
    pog.UnexpectedArgumentType(expected, get) ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.string(expected)),
              #("error2", json.string(get)),
              #("error3", json.string("")),
            ]),
          ]),
        ),
      ])
    pog.UnexpectedResultType(_) ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.string("Decode error with expected type")),
              #("error2", json.string("")),
              #("error3", json.string("")),
            ]),
          ]),
        ),
      ])
    pog.ConnectionUnavailable ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.string("connection unavailable")),
              #("error2", json.string("")),
              #("error3", json.string("")),
            ]),
          ]),
        ),
      ])
    pog.QueryTimeout ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.string("Connection Timeout")),
              #("error2", json.string("")),
              #("error3", json.string("")),
            ]),
          ]),
        ),
      ])
  }
}

pub fn pgo_transactionerror_tojson(
  error: pog.TransactionError(String),
) -> json.Json {
  case error {
    pog.TransactionQueryError(err) -> pgo_queryerror_tojson(err)
    pog.TransactionRolledBack(error) ->
      json.object([
        #("status", json.int(common.api_status_to_int(common.ApiStatusErr))),
        #("message", json.string("SQL Error")),
        #(
          "errors",
          json.preprocessed_array([
            json.object([
              #("error1", json.string(error)),
              #("error2", json.string("")),
              #("error3", json.string("")),
            ]),
          ]),
        ),
      ])
  }
}
