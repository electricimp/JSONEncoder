# JSON Encoder in Squirrel

Encodes Squirrel data structures into JSON.

_To add this library to your project, add **#require "JSONEncoder.class.nut:0.4.0"** to the top of your code._

## Usage

```squirrel
str <- JSONEncoder.encode(data);
```

## Unicode strings

Current implementation suggests that Squirrel is compiled with single-byte strings (the case for Electric Imp platform) and correctly handles UTF-8 characters.

## Classes serialization

When serializing classes functions are ignored and only properties are exposed.

## Instances serialization

When serializing Instances functions are ignored and only properties are exposed. If the instance implements `_nexti()` meta-method it can define a custom serialization behavior. Another way for defining custom representation in JSON is to implement `_serialize()` method as described below.

### \_serialize() method

Instances can contain `_serialize()` method that is called during the encoding to get the representation of an instance as (for example) table or array. See an example below.

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
  h = "Some\nùnicode\rstring ø∆ø"
};

server.log(JSONEncoder.encode(t));
```

should produce

```json
{"a":123,"c":{"_field":123},"b":[1,2,3,4],"e":{"field":123},"d":5.125,"g":true,"f":null,"h":"Some\nùnicode\rstring ø∆ø"}
```
