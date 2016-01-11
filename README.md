# JSON encoder/decoder in Squirrel
 
(decoder is coming)

## Example

```squirrel
class A {}

t <- {
  a = 123,
  b = [1, 2, 3, 4],
  c = A,
  d = 5.125,
  e = A(),
  f = null
};

server.log(JSON.stringify(t));
```

should produce
 
```json
{"a":123,"c":"(class : 0x2000b63c)","b":[1,2,3,4],"e":"(instance : 0x2000b99c)","d":5.125,"f":null}
```
