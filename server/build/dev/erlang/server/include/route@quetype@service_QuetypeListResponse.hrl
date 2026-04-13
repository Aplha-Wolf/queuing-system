-record(quetype_list_response, {
    status :: integer(),
    message :: binary(),
    page :: shared@quetype:page(),
    data :: list(shared@quetype:que_type())
}).
