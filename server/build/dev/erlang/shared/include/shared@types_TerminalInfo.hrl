-record(terminal_info, {
    terminal :: shared@types:terminal(),
    current :: shared@types:queue(),
    queues :: list(shared@types:queue())
}).
