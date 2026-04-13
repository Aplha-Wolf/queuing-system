-record(server_first, {
    nonce :: binary(),
    salt :: bitstring(),
    iterations :: integer(),
    raw :: bitstring()
}).
