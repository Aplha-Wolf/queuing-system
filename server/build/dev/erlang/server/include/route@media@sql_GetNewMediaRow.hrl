-record(get_new_media_row, {
    id :: integer(),
    create_at :: binary(),
    name :: binary(),
    is_ads :: boolean(),
    media_type :: integer(),
    filename :: binary(),
    active :: boolean()
}).
