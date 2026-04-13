-- Get active theme
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
WHERE is_active = true
LIMIT 1
