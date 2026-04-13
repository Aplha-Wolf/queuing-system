-- List all themes
SELECT
  id, name, display_name, description, is_active, is_dark, CAST(created_at AS TEXT) AS created_at
FROM theme
ORDER BY id ASC
