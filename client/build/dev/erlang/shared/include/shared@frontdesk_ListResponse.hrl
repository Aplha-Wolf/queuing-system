-record(list_response, {
    status :: integer(),
    message :: binary(),
    page :: shared@frontdesk:page(),
    data :: list(shared@frontdesk:front_desk())
}).
