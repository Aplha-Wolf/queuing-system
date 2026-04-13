SELECT
    id, CAST(create_at AS TEXT) AS create_at, name,
    icon, prefix, active
FROM
    quetype
ORDER BY
    name ASC
LIMIT $1
OFFSET $2;
