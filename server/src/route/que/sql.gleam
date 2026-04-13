//// This module contains the code to run the sql queries defined in
//// `./src/route/que/sql`.
//// > 🐿️ This module was generated automatically using v4.6.0 of
//// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
////

import gleam/dynamic/decode
import pog

/// A row you get from running the `add_queue` query
/// defined in `./src/route/que/sql/add_queue.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type AddQueueRow {
  AddQueueRow(id: Int)
}

/// Runs the `add_queue` query
/// defined in `./src/route/que/sql/add_queue.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn add_queue(
  db: pog.Connection,
  arg_1: Int,
  arg_2: Int,
  arg_3: Int,
  arg_4: Int,
) -> Result(pog.Returned(AddQueueRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    decode.success(AddQueueRow(id:))
  }

  "INSERT INTO que
    (reset_id, quetype_id, priority_id, que_no)
VALUES
    ($1, $2, $3, $4)
RETURNING id;"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.parameter(pog.int(arg_2))
  |> pog.parameter(pog.int(arg_3))
  |> pog.parameter(pog.int(arg_4))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// Runs the `clear_terminal_queue` query
/// defined in `./src/route/que/sql/clear_terminal_queue.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn clear_terminal_queue(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(Nil), pog.QueryError) {
  let decoder = decode.map(decode.dynamic, fn(_) { Nil })

  "UPDATE que
SET update_at = now()
WHERE terminal_id = $1 AND update_at IS NULL;
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_queues_using_terminal_code` query
/// defined in `./src/route/que/sql/get_queues_using_terminal_code.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetQueuesUsingTerminalCodeRow {
  GetQueuesUsingTerminalCodeRow(id: Int, que_label: String)
}

/// Runs the `get_queues_using_terminal_code` query
/// defined in `./src/route/que/sql/get_queues_using_terminal_code.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_queues_using_terminal_code(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(GetQueuesUsingTerminalCodeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use que_label <- decode.field(1, decode.string)
    decode.success(GetQueuesUsingTerminalCodeRow(id:, que_label:))
  }

  "SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
        INNER JOIN terminal AS t ON (t.id = tq.terminal_id)
WHERE
    t.code = $1 AND q.terminal_id IS NULL
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    p.level ASC, q.que_no ASC
LIMIT 10;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_queues_using_terminal_id` query
/// defined in `./src/route/que/sql/get_queues_using_terminal_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetQueuesUsingTerminalIdRow {
  GetQueuesUsingTerminalIdRow(id: Int, que_label: String)
}

/// Runs the `get_queues_using_terminal_id` query
/// defined in `./src/route/que/sql/get_queues_using_terminal_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_queues_using_terminal_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetQueuesUsingTerminalIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use que_label <- decode.field(1, decode.string)
    decode.success(GetQueuesUsingTerminalIdRow(id:, que_label:))
  }

  "SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
WHERE
    tq.terminal_id = $1 AND q.terminal_id IS NULL 
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    p.level ASC, q.que_no ASC
LIMIT 10;"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_terminal_queue_by_code` query
/// defined in `./src/route/que/sql/get_terminal_queue_by_code.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetTerminalQueueByCodeRow {
  GetTerminalQueueByCodeRow(id: Int, que_label: String)
}

/// Runs the `get_terminal_queue_by_code` query
/// defined in `./src/route/que/sql/get_terminal_queue_by_code.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_terminal_queue_by_code(
  db: pog.Connection,
  arg_1: String,
) -> Result(pog.Returned(GetTerminalQueueByCodeRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use que_label <- decode.field(1, decode.string)
    decode.success(GetTerminalQueueByCodeRow(id:, que_label:))
  }

  "SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
        INNER JOIN terminal AS t ON (t.id = tq.terminal_id)
WHERE
    t.code = $1 AND q.terminal_id = t.id AND q.update_at is NULL
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    q.update_at DESC
LIMIT 1;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `get_terminal_queue_by_id` query
/// defined in `./src/route/que/sql/get_terminal_queue_by_id.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type GetTerminalQueueByIdRow {
  GetTerminalQueueByIdRow(id: Int, que_label: String)
}

/// Runs the `get_terminal_queue_by_id` query
/// defined in `./src/route/que/sql/get_terminal_queue_by_id.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn get_terminal_queue_by_id(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(GetTerminalQueueByIdRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use que_label <- decode.field(1, decode.string)
    decode.success(GetTerminalQueueByIdRow(id:, que_label:))
  }

  "SELECT
    q.id, p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0') AS que_label
FROM
    que AS q
        INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
            INNER JOIN priority AS p ON (p.id = q.priority_id)
        INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
WHERE
    q.terminal_id = $1 AND q.update_at is NULL
    AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
ORDER BY
    q.update_at DESC
LIMIT 1;"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `next_queue` query
/// defined in `./src/route/que/sql/next_queue.sql`.
///
/// > 🐿️ This type definition was generated automatically using v4.6.0 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type NextQueueRow {
  NextQueueRow(id: Int, que_label: String)
}

/// Runs the `next_queue` query
/// defined in `./src/route/que/sql/next_queue.sql`.
///
/// > 🐿️ This function was generated automatically using v4.6.0 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn next_queue(
  db: pog.Connection,
  arg_1: Int,
) -> Result(pog.Returned(NextQueueRow), pog.QueryError) {
  let decoder = {
    use id <- decode.field(0, decode.int)
    use que_label <- decode.field(1, decode.string)
    decode.success(NextQueueRow(id:, que_label:))
  }

  "WITH rows_to_update AS (
    SELECT q2.id AS que_id, p.prefix || qt.prefix || LPAD(CAST(q2.que_no AS TEXT), 3, '0') AS que_label
    FROM que AS q2
    INNER JOIN quetype AS qt ON qt.id = q2.quetype_id
    INNER JOIN terminal_quetype AS tq ON tq.quetype_id = qt.id
    INNER JOIN priority AS p ON p.id = q2.priority_id
    WHERE q2.terminal_id IS NULL 
      AND tq.terminal_id = $1
      AND q2.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
    ORDER BY p.level ASC, q2.que_no ASC
    LIMIT 1
)
UPDATE que AS q2
SET terminal_id = $1
FROM rows_to_update
WHERE q2.id = rows_to_update.que_id
RETURNING q2.id, rows_to_update.que_label;
"
  |> pog.query
  |> pog.parameter(pog.int(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}
