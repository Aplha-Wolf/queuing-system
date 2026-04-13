-record(list_response, {
    status :: integer(),
    message :: binary(),
    page :: shared@priority:page(),
    data :: list(shared@priority:priority())
}).
