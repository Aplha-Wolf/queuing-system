-record(collection, {
    name :: binary(),
    to_json :: fun((any()) -> gleam@json:json()),
    decoder :: gleam@dynamic@decode:decoder(any()),
    config :: storail:config()
}).
