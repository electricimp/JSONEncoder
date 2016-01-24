#require "JSONEncoder.class.nut:0.4.0"

t <- {
  a = 123,
  b = [1, 2, 3, 4]
};

s <- JSONEncoder.encode(t);

server.log(s);
// == {"a":123,"b":[1,2,3,4]}
