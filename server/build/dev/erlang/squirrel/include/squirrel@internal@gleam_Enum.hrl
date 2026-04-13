-record(enum, {
    original_name :: binary(),
    name :: squirrel@internal@gleam:type_identifier(),
    variants :: non_empty_list:non_empty_list(squirrel@internal@gleam:enum_variant())
}).
