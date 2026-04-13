-- Activate theme by ID
UPDATE theme
SET is_active = true, updated_at = CURRENT_TIMESTAMP
WHERE id = $1
