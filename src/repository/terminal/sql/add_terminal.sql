INSERT INTO terminal 
    (code, name) 
VALUES 
    ($1, $2)
RETURNING id;