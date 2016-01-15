// JSON is supposed to be inclided

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

assert(JSON.stringify({a=A(),c=C()}) == "{\"a\":{\"field\":2},\"c\":{\"0\":\"c\",\"1\":\"c\"}}");
