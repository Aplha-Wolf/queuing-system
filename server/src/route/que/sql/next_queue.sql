WITH rows_to_update AS (
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
