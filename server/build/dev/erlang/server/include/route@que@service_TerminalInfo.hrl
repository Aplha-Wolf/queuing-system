-record(terminal_info, {
    terminal :: shared@terminal:terminal(),
    current :: shared@queue:queue(),
    queues :: list(shared@queue:queue())
}).
