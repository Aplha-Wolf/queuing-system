UPDATE terminal 
SET 
    code = $1, name = $2, active = $3
WHERE 
    id = $4