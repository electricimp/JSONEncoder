// Copyright (c) 2017-19 Electric Imp
// Copyright (c) 2020-23 KORE Wireless
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

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


class CustomTypeTestCase extends ImpTestCase {

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

}
