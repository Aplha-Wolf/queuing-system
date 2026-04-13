SELECT
    id, code, CAST(create_at AS TEXT) AS create_at, name, active, 
    now_serving_size, media_width, terminal_div_width, cols, rows, 
    name_size, que_label_size, que_no_size, date_time_size
FROM
    display
WHERE
    code = $1