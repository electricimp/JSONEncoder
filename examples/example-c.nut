// Copyright (c) 2017-19 Electric Imp
// Copyright (c) 2020-23 KORE Wireless

#require "JSONEncoder.class.nut:3.0.0"

t <- {
    a = 123,
    b = [1, 2, 3, 4]
};

s <- JSONEncoder.encode(t);

server.log(s);
// == {"a":123,"b":[1,2,3,4]}
