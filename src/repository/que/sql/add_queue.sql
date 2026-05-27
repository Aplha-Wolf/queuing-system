INSERT INTO que
    (reset_id, quetype_id, priority_id, que_no)
VALUES
    ($1, $2, $3, $4)
RETURNING id;