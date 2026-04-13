SELECT
    id, CAST(create_at AS TEXT) AS create_at, code, name, active, title_fontsize, option_fontsize,
    icon_height, icon_width, priority_cols, priority_rows, transaction_cols,
    transaction_rows
FROM frontdesk
LIMIT $1
