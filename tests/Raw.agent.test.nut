/**
 * Test as-is serialization
 */

// value returned by _serialize() is then encoded further
class serializeClass {
  function _serialize() {
    // very long integer
    return "12345678901234567890"
  }
};

// value returned by _serializeRaw() is then encoded further
class serializeRawClass {
  function _serializeRaw() {
    // very long integer
    return "12345678901234567890"
  }
};

class RawTestCase extends ImpTestCase {

  function test01() {
    local data = {i1 = serializeClass(), i2 = serializeRawClass()};
    local res = ::JSONEncoder.encode(data);
    this.assertEqual("{\"i1\":\"12345678901234567890\",\"i2\":12345678901234567890}", res);
  }

}
