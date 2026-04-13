-record(list_all_frontdesk_row, {
    id :: integer(),
    create_at :: binary(),
    code :: binary(),
    name :: binary(),
    active :: boolean(),
    title_fontsize :: integer(),
    option_fontsize :: integer(),
    icon_height :: integer(),
    icon_width :: integer(),
    priority_cols :: integer(),
    priority_rows :: integer(),
    transaction_cols :: integer(),
    transaction_rows :: integer()
}).
