SELECT
    id, code, name, active, CAST(create_at AS TEXT) AS create_at
FROM 
    terminal 
WHERE 
    id = $1
LIMIT 1