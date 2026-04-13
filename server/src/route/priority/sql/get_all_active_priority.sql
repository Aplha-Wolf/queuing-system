SELECT
    id, CAST(create_at AS TEXT) AS create_at, name, icon, prefix, level, active
FROM
    priority
WHERE
    active = TRUE
ORDER BY level ASC
LIMIT $1
OFFSET $2
