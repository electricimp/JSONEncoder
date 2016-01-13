/**
 * JSON encoder. Decoder is coming.
 * @author Mikhail Yurasov <mikhail@electricimp.com>
 * @verion 0.0.2
 */
JSON <- {

  version = [0, 0, 2],

  // max structure depth
  // anything above probably has a cyclic ref
  _maxDepth = 32,

  /**
   * Encode value to JSON
   * @param {table|array|*} value
   * @returns {string}
   */
  stringify = function (value) {
    return JSON._encode(value);
  },

  /**
   * @param {table|array} val
   * @param {integer=0} depth – current depth level
   * @private
   */
  _encode = function (val, depth = 0) {

    // detect cyclic reference
    if (depth > JSON._maxDepth) {
      throw "Possible cyclic reference";
    }

    local
      r = "",
      s = "",
      i = 0;

    switch (type(val)) {

      case "table":
      case "class":
        s = "";

        foreach (k, v in val) {
          s += "," + k + ":" + JSON._encode(v, depth + 1);
        }

        s = s.len() > 0 ? s.slice(1) : s;
        r += "{" + s + "}";
        break;

      case "array":
        s = "";

        for (i = 0; i < val.len(); i++) {
          s += "," + JSON._encode(val[i], depth + 1);
        }

        s = (i > 1) ? s.slice(1) : s;
        r += "[" + s + "]";
        break;

      case "integer":
      case "float":
      case "bool":
        r += val;
        break;

      case "null":
        r += "null";
        break;

      default:
        r += "\"" + val + "\"";
        break;
    }

    return r;
  }
}
