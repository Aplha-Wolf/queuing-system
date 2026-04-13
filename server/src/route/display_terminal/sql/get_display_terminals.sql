SELECT
    dt.terminal_id AS id, t.code AS code, t.name AS name, 
    COALESCE((SELECT
        p.prefix || qt.prefix || LPAD(CAST(q.que_no AS TEXT), 3, '0')
    FROM
        que AS q
            INNER JOIN quetype AS qt ON (qt.id = q.quetype_id)
                INNER JOIN priority AS p ON (p.id = q.priority_id)
            INNER JOIN terminal_quetype AS tq ON (tq.quetype_id = qt.id)
    WHERE
        q.terminal_id = dt.terminal_id AND q.update_at is NULL
        AND q.reset_id = (SELECT r.id FROM reset AS r ORDER BY r.id DESC LIMIT 1)
    ORDER BY
        q.update_at DESC
    LIMIT 1), '') AS que_label
FROM
    display_terminal AS dt
        INNER JOIN terminal AS t ON (t.id = dt.terminal_id)
WHERE
    dt.display_id = $1
ORDER BY
    dt.order ASC, dt.id ASC
LIMIT $2
