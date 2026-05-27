import envoy
import gleam/erlang/process
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
