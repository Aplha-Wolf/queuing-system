-- Get theme by ID
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
WHERE id = $1
LIMIT 1
