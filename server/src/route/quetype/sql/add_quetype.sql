INSERT INTO
    quetype
    (name, active, color, prefix)
VALUES
    ($1, $2, $3, $4)
RETURNING id;
