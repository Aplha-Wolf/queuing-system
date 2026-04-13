SELECT
  id, TO_CHAR(create_at, 'YYYY-MM-DD HH24:MI:SS') AS create_at, name, is_ads, media_type, filename, active 
FROM
    media
WHERE id = (
    SELECT id
    FROM media
  WHERE active = TRUE AND is_ads = TRUE
    ORDER BY RANDOM() LIMIT 1
);
