#require "JSONEncoder.class.nut:0.4.0"

// class with _typeof()
class rawTypeof {
  function _serialize() {
    return "@something"
  }

  function _typeof() {
    return "raw";
  }
};

// class with _typeof() and _tostring()
class rawTypeofWithToString {
  function _tostring() {
    return "@something"
  }

  function _typeof() {
    return "raw";
  }
};

// class without _typeof()
class instanceTypeof {
  function _serialize() {
    return "@something"
  }
};

s <- JSONEncoder.encode({r1 = rawTypeof(), r2 = rawTypeofWithToString(), i = instanceTypeof()});
server.log(s);
// == {"i":"@something","r1":@something,"r2":@something}
