-record(theme_with_colors_result, {
    id :: integer(),
    name :: binary(),
    display_name :: binary(),
    description :: binary(),
    is_active :: boolean(),
    is_dark :: boolean(),
    colors :: list(shared@theme:theme_color())
}).
