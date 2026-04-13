import gleam/erlang/process
import helpers/env_loader
import helpers/sql as sql_helper
import mist
import route/router
import route/web
import wisp
import wisp/wisp_mist

pub fn main() {
  env_loader.load_env_file("./.env")

  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  let assert Ok(pool) = sql_helper.start_db_pool()
  let db = sql_helper.db_connection(pool)
  let context = web.Context(db: db)

  let assert Ok(_) =
    router.handle_request(_, context)
    |> wisp_mist.handler(secret_key_base)
    |> mist.new
    |> mist.port(3001)
    |> mist.start

  process.sleep_forever()
}
