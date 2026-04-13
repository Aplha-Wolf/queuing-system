-record(connection, {
    socket :: mug:socket(),
    buffer :: bitstring(),
    timeout :: integer()
}).
