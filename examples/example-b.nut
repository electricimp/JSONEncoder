#require "JSONEncoder.class.nut:2.1.0"

// contains _serialize function to allow custom representation of an instance
class A {
    _field = 123;

    // returns instance representation as table
    function _serialize() {
        return { field = this._field };
    }
}

someblob <- blob();
someblob.writestring("a\ta");

t <- {
    a = 123,
    b = [1, 2, 3, 4],
    c = A,
    d = 5.125,
    e = A(),
    f = null,
    g = true,
    h = "Some\nùnicode\rstring ø∆ø",
    i = someblob
};

s <- JSONEncoder.encode(t);
try { server.log(s) } catch (e) { ::print(s) };
assert(s == "{\"a\":123,\"c\":{\"_field\":123},\"b\":[1,2,3,4],\"e\":{\"field\":123},\"d\":5.125,\"g\":true,\"f\":null,\"i\":\"a\\ta\",\"h\":\"Some\\nùnicode\\rstring ø∆ø\"}");
