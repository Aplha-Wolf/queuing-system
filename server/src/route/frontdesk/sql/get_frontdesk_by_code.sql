SELECT
    id, CAST(create_at AS TEXT) AS create_at, code, name, active,
    title_fontsize, option_fontsize, icon_height, icon_width,
    priority_cols, priority_rows, transaction_cols, transaction_rows
FROM
    frontdesk
WHERE
    code LIKE $1
ORDER BY
    create_at DESC
LIMIT 1;
