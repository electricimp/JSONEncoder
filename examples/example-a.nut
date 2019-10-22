#require "JSONEncoder.class.nut:2.1.0"

class A {
    field = 1

    constructor() {
        // when serialized as instance field==2 should be returned
        this.field = 2;
    }
}

// iterated in a custom way
class C {
    field = 123

    function _nexti(p) {
        if (p == null) return 0;
        if (p < 1) return p+1;
        return null;
    }

    function _get(i) {
        return "c";
    }
}

s <- JSONEncoder.encode({a=A(),c=C()});
try { server.log(s) } catch (e) { ::print(s) };
assert(s == "{\"a\":{\"field\":2},\"c\":{\"0\":\"c\",\"1\":\"c\"}}");
