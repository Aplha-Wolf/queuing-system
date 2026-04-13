SELECT
    COALESCE(COUNT(id), 0) AS total_count
FROM
    priority
WHERE
    active = TRUE;
