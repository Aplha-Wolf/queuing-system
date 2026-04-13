UPDATE que
SET update_at = now()
WHERE terminal_id = $1 AND update_at IS NULL;
