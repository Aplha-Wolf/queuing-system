DELETE FROM
    terminal_quetype
WHERE
    terminal_id = $1
    AND quetype_id != ANY($2);