-- Get theme colors by theme_id
SELECT token, light_value, dark_value
FROM theme_color
WHERE theme_id = $1
