// JSON is supposed to be inclided

// contains _serialize function to allow custom representation of an instance
class A {
  _field = 123;

  // returns instance representation as table
  function _serialize() {
    return {
      field = this._field
    }
  }
}

t <- {
  a = 123,
  b = [1, 2, 3, 4],
  c = A,
  d = 5.125,
  e = A(),
  f = null,
  g = true,
  h = "Some\nùnicode\rstring ø∆ø"
};

server.log(JSON.stringify(t));
assert(JSON.stringify(t) == "{\"a\":123,\"c\":{\"_field\":123},\"b\":[1,2,3,4],\"e\":{\"field\":123},\"d\":5.125,\"g\":true,\"f\":null,\"h\":\"Some\\nùnicode\\rstring ø∆ø\"}");
