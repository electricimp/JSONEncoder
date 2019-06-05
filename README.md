# JSON Encoder #

This library can be used to encode Squirrel data structures into JSON.

**To include this library in your project, add** `#require "JSONEncoder.class.nut:2.0.1"` **at the top of your code.**

![Build Status](https://cse-ci.electricimp.com/app/rest/builds/buildType:(id:JSONEncoder_BuildAndTest)/statusIcon)

## Usage ##

JSONEncoder has no constructor and one public function, *encode()*.

### encode(*data*) ###

The *encode()* method takes one required parameter: the data to be encoded. It returns a JSON string version of that data.

#### Basic Example ####

```squirrel
data <- { "one": 1 };
jsonString <- JSONEncoder.encode(data);

server.log(typeof jsonString);
// Displays 'string'

server.log(jsonString);
// Displays '{"one":1}'
```

## Serialization Details ##

### Unicode Strings ###

The class’ current implementation suggests that Squirrel is compiled with single-byte strings (as is the case with the Electric Imp Platform) and correctly handles UTF-8 characters.

### Class Serialization ###

When serializing classes, functions are ignored and only properties are exposed.

### Instance Serialization ###

When serializing instances, functions are ignored and only properties are exposed. If the instance implements the *_nexti()* metamethod, it can define a custom serialization behavior. Another way for defining custom representation in JSON is to implement a *_serialize()* method in your class.

#### Custom Serialization with \_serialize() Method ###

Instances can contain a *_serialize()* method that is called during the encoding to get the representation of an instance as (for example) a table or an array. See the extended example below.

#### Serializing As-is ###

In some cases it may be useful to provide a ‘raw’ representation of an instance to the JSON encoder. In order to do so, an instance can define a *_serializeRaw()* method returning a string value. This value is then inserted into the resulting JSON output without further processing or escaping.

```squirrel
class A {
    function _serializeRaw() {
        // Very long integer
        return "12345678901234567890";
    }
};

value <- JSONEncoder.encode( [ A() ] );
server.log(typeof value);
// Displays 'string'

server.log(value);
// Displays '[12345678901234567890]'
```

**Note** While this method may be useful in certain cases, it has the potential to produce a non-valid JSON output.

## Extended Example ##

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
// Displays '{"a":123,"c":{"_field":123},"b":[1,2,3,4],"e":{"field":123},"d":5.125,"g":true,"f":null,"h":"Some\nùnicode\rstring ø∆ø"}'
// Note: this output is a JSON string
```

## License ##

This library is licensed under the [MIT License](LICENSE).
