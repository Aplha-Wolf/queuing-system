INSERT INTO
    terminal_quetype
    (terminal_id, quetype_id)
VALUES
    ($1, $2)
RETURNING id;