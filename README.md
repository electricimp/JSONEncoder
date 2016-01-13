# JSON encoder/decoder in Squirrel
 
(decoder is coming)

TODO:
- special chars escaping in string 

## Example

```squirrel
class A {
  field = 123;
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
{"a":123,"c":{"field":123},"b":[1,2,3,4],"e":"(instance : 0x2000ba7c)","d":5.125,"g":true,"f":null,"h":"Some\nùnicode\rstring\"ø∆ø\""}
[1,2]
```
