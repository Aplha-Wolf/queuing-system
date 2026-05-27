SELECT
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
LIMIT 10;