# JSON encoder in Squirrel

## _serialize() metamethod

Instances can contain `_serialize()` metamethod that is called during the encoding to get the representation of an instance as (for example) table or array. See an example below.

## Example

```squirrel
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
  h = "Some\nùnicode\rstring\"ø∆ø\""
};

server.log(JSON.stringify(t));
server.log(JSON.stringify([1,2]));
```

should produce

```json
{"a":123,"c":{"_field":123},"b":[1,2,3,4],"e":{"field":123},"d":5.125,"g":true,"f":null,"h":"Some\nùnicode\rstring\"ø∆ø\""}
[1,2]
```
