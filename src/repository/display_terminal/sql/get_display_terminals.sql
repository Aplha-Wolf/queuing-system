SELECT
    dt.terminal_id AS id, t.code AS code, t.name AS name
FROM
    display_terminal AS dt
        INNER JOIN terminal AS t ON (t.id = dt.terminal_id)
WHERE
    dt.display_id = $1
ORDER BY
    dt.order ASC, dt.id ASC
LIMIT $2
