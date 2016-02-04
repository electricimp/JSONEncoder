#require "JSONEncoder.class.nut:0.4.0"

// class with _typeof() meta-method
class rawTypeof {
  function _serialize() {
    return "@something"
  }

  function _typeof() {
    return "raw";
  }
};

// class withoit _typeof() meta-method
class instanceTypeof {
  function _serialize() {
    return "@something"
  }
};

s <- JSONEncoder.encode({r = rawTypeof(), i = instanceTypeof()});
server.log(s);
// == {"i":"@something","r":@something}
