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

class BasicTestCase extends ImpTestCase {

  function test01() {
    local someblob = blob();
    someblob.writestring("a\ta");

    local data = {
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

    local res = ::JSONEncoder.encode(data);

    this.assertEqual("{\"a\":123,\"c\":{\"_field\":123},\"b\":[1,2,3,4],\"e\":{\"field\":123},\"d\":5.125,\"g\":true,\"f\":null,\"i\":\"a\\ta\",\"h\":\"Some\\nùnicode\\rstring ø∆ø\"}", res);
  }

  /**
   * @see https://github.com/electricimp/JSONEncoder/issues/2
   */
  function test02_Nullchars() {
    local obj = blob(7);
    obj.writestring("Hello");
    local str = ::JSONEncoder.encode(obj);
    this.assertEqual("\"Hello\\u0000\\u0000\"", str);
  }

}
