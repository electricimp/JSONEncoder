// Copyright (c) 2017 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

// Iterated in a custom way
class C {

    field = 123;

    function _nexti(p) {
        if (p == null) return 0;
        if (p < 1) return p+1;
        return null;
    }

    function _get(i) {
        return "c";
    }
}


class CustomIteratorsTestCase extends ImpTestCase {

    function test01() {
        local data = {c = C()};
        local res = ::JSONEncoder.encode(data);
        this.assertEqual("{\"c\":{\"0\":\"c\",\"1\":\"c\"}}", res);
    }

}
