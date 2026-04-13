-record(get_display_by_code_row, {
    id :: integer(),
    code :: binary(),
    create_at :: binary(),
    name :: binary(),
    active :: boolean(),
    now_serving_size :: integer(),
    media_width :: integer(),
    terminal_div_width :: integer(),
    cols :: integer(),
    rows :: integer(),
    name_size :: integer(),
    que_label_size :: integer(),
    que_no_size :: integer(),
    date_time_size :: integer()
}).
