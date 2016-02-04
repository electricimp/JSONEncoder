<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [JSON Encoder](#json-encoder)
  - [Usage](#usage)
  - [Unicode Strings](#unicode-strings)
  - [Classes Serialization](#classes-serialization)
  - [Instances Serialization](#instances-serialization)
    - [Custom Serialization with \_serialize() Method](#custom-serialization-with-%5C_serialize-method)
  - [Example](#example)
  - [License](#license)
  - [Development](#development)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# JSON Encoder

Encodes Squirrel data structures into JSON.

_To add this library to your project, add **#require "JSONEncoder.class.nut:0.4.0"** to the top of your code._

## Usage

```squirrel
str <- JSONEncoder.encode(data);
```

## Unicode Strings

Current implementation suggests that Squirrel is compiled with single-byte strings (the case for Electric Imp platform) and correctly handles UTF-8 characters.

## Classes Serialization

When serializing classes functions are ignored and only properties are exposed.

## Instances Serialization

When serializing Instances functions are ignored and only properties are exposed. If the instance implements `_nexti()` meta-method it can define a custom serialization behavior. Another way for defining custom representation in JSON is to implement `_serialize()` method as described below.

### Custom Serialization with \_serialize() Method

Instances can contain `_serialize()` method that is called during the encoding to get the representation of an instance as (for example) table or array. See an example below.

#### Serializing As-is

In some cases it may be useful to provide a "raw" value to the JSON encoder. In order to do so, an instance can define a `_typeof()` meta-method returning "raw". The *string* value returned by `_serialize()` or `_tosting()` is then inserted into resulting JSON output without further processing or escaping.

Here is an example of two ways of serialization with "raw" values:

```squirrel
// class with _typeof() & _serialize()
class A {
  function _serialize() {
    // very long integer
    return "12345678901234567890"
  }

  function _typeof() {
    return "raw";
  }
};

// class with _typeof() and _tostring()
class B {
  function _tostring() {
    // very long integer
    return "12345678901234567890"
  }

  function _typeof() {
    return "raw";
  }
};

server.log(JSONEncoder.encode([A(), B()]));
```

outputs

```json
[12345678901234567890, 12345678901234567890]
```

Note that while this method may have certain uses, it has the potential to produce non-valid JSON output.

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

## License

The code in this repository is licensed under [MIT License](https://github.com/electricimp/serializer/tree/master/LICENSE).

## Development

This repository uses [git-flow](http://jeffkreeftmeijer.com/2010/why-arent-you-using-git-flow/).
Please make your pull requests to the __develop__ branch.
