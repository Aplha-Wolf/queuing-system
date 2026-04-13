SELECT
    COALESCE(COUNT(id), 0) AS total_count
FROM
    quetype
WHERE
    active = TRUE;
