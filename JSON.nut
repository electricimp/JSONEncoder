/**
 * JSON encoder. Decoder is coming.
 * @author Mikhail Yurasov <mikhail@electricimp.com>
 * @verion 0.0.1
 */
JSON <- {

  version = [0, 0, 1],

  /**
   * Encode value to JSON
   * @param {table|array} val
   * @returns {string}
   */
  stringify = function (value) {
    return JSON._encode(value, true);
  },

  /**
   * @param {table|array} val
   * @param {boolean} _isRoot
   * @param {boolean} _isArray
   * @private
   */
 _encode = function (val, _isRoot = true, _isArray = false) {

    local r = "";

    foreach (key, value in val) {

      if (!_isArray) {
        (r += "\"" + key + "\":");
      }

      switch (type(value)) {

        case "table":
          r += "{\n" + JSON._encode(value, false) + "}";
          break

        case "array":
          r += "[" + JSON._encode(value, false, true) + "]";
          break

        case "string":
          r += "\"" + value + "\"";
          break;

        case "integer":
        case "float":
          r += value;
          break;

        case "null":
          r += "null";
          break;

        default:
          r += "\"" + value + "\"";
          break;
      }

      r += ",";
    }

    r = r.slice(0, r.len() - 1);

    return _isRoot ? ("{" + r + "}") : r;
  }
}
