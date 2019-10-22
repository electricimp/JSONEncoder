// Copyright (c) 2017-19 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class JSONEncoder {

    static VERSION = "2.1.0";

    // max structure depth
    // anything above probably has a cyclic ref
    static _maxDepth = 32;

    /**
     * Encode value to JSON
     * @param {table|array|*} value
     * @returns {string}
    */
    function encode(value) {
        return this._encode(value);
    }

    /**
     * @param {table|array} val
     * @param {integer=0} depth – current depth level
     * @private
    */
    function _encode(val, depth = 0) {
        // Detect cyclic reference
        if (depth > this._maxDepth) throw "Possible cyclic reference";

        local r = "", s = "", i = 0;

        switch (typeof val) {
            case "table":
            case "class":
                s = "";
                // serialize properties, but not functions
                foreach (k, v in val) {
                    if (typeof v != "function") {
                        s += ",\"" + k + "\":" + this._encode(v, depth + 1);
                    }
                }

                s = s.len() > 0 ? s.slice(1) : s;
                r += "{" + s + "}";
                break;

            case "array":
                s = "";

                for (i = 0; i < val.len(); i++) {
                    s += "," + this._encode(val[i], depth + 1);
                }

                s = (i > 0) ? s.slice(1) : s;
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

            case "instance":
                if ("_serializeRaw" in val && typeof val._serializeRaw == "function") {
                    // include value produced by _serializeRaw()
                    r += val._serializeRaw().tostring();
                } else if ("_serialize" in val && typeof val._serialize == "function") {
                    // serialize instances by calling _serialize method
                    r += this._encode(val._serialize(), depth + 1);
                } else {
                    s = "";

                    try {
                        // Iterate through instances which implement _nexti meta-method
                        foreach (k, v in val) {
                            s += ",\"" + k + "\":" + this._encode(v, depth + 1);
                        }
                    } catch (e) {
                        // Iterate through instances w/o _nexti
                        // serialize properties, but not functions
                        foreach (k, v in val.getclass()) {
                            if (typeof v != "function") {
                                s += ",\"" + k + "\":" + this._encode(val[k], depth + 1);
                            }
                        }
                    }

                    s = s.len() > 0 ? s.slice(1) : s;
                    r += "{" + s + "}";
                }

                break;

            case "blob":
                // Workaround a known bug: on device side Blob.tostring()
                // returns null instead of an empty string. And base64-encode
                // the blob as per http.jsonencode() page suggests.
                if (val.len() == 0) {
                    r += "\"\"";
                    break;
                }

                // Fallthrough to string handler

            // Strings and all other types
            default:
                // Try to get the data as viable human-readable string, ie.
                // it contains unicode/Ascii
                local x = this._escape(val.tostring());
                if (x != null) {
                    // The string is *probably* valid, so add it to the JSON
                    r += "\"" + x + "\"";
                } else {
                    // The string doesn't appear to be valid so just dump it
                    r += "\"" + this._dumpBytes(val) + "\"";
                }
                break;
        }

        return r;
    }

    /**
     * Escape strings according to http://www.json.org/ spec.
     * @param {string} str - The input string.
     * @returns {string/null} - The rendered string output, or null if the string lacks valid unicode.
     * @private
    */
    function _escape(str) {
        local res = "";
        for (local i = 0; i < str.len(); i++) {
            local ch1 = (str[i] & 0xFF);
            if ((ch1 & 0x80) == 0x00) {
                // 7-bit Ascii
                ch1 = format("%c", ch1);
                if (ch1 == "\"") {
                    res += "\\\"";
                } else if (ch1 == "\\") {
                    res += "\\\\";
                } else if (ch1 == "/") {
                    res += "\\/";
                } else if (ch1 == "\b") {
                    res += "\\b";
                } else if (ch1 == "\f") {
                    res += "\\f";
                } else if (ch1 == "\n") {
                    res += "\\n";
                } else if (ch1 == "\r") {
                    res += "\\r";
                } else if (ch1 == "\t") {
                    res += "\\t";
                } else if (ch1[0] < 31) {
                    // U+0000 to U+001F (0-31) MUST be escaped as per
                    // https://www.ietf.org/rfc/rfc4627.txt
                    res += ("\\u00" + _toHex(ch1[0]));
                } else {
                    res += ch1;
                }
            } else {
                if ((ch1 & 0xE0) == 0xC0) {
                    // 110xxxxx = 2-byte unicode
                    if (i + 1 < str.len()) {
                        local ch2 = (str[++i] & 0xFF);
                        res += format("%c%c", ch1, ch2);
                    } else {
                        //throw "Insufficient data for 2-byte Unicode";
                        res = null;
                        break;
                    }
                } else if ((ch1 & 0xF0) == 0xE0) {
                    // 1110xxxx = 3-byte unicode
                    if (i + 2 < str.len()) {
                        local ch2 = (str[++i] & 0xFF);
                        local ch3 = (str[++i] & 0xFF);
                        res += format("%c%c%c", ch1, ch2, ch3);
                    } else {
                        //throw "Insufficient data for 3-byte Unicode";
                        res = null;
                        break;
                    }
                } else if ((ch1 & 0xF8) == 0xF0) {
                    // 11110xxx = 4-byte unicode
                    if (i + 3 < str.len()) {
                        local ch2 = (str[++i] & 0xFF);
                        local ch3 = (str[++i] & 0xFF);
                        local ch4 = (str[++i] & 0xFF);
                        res += format("%c%c%c%c", ch1, ch2, ch3, ch4);
                    } else {
                        //throw "Insufficient data for 4-byte Unicode";
                        res = null;
                        break;
                    }
                } else {
                    res = null;
                    break;
                }
            }
        }

        return res;
    }

    /**
     * Convert integer to hex string.
     * @param {integer} i - The input integer value.
     * @param {integer} n - The number of digits in the output. Default: 2
     * @returns {string} - The hex string output.
     * @private
    */
    function _toHex(i, n = 2) {
        if (n % 2 != 0) n++;
        local fs = "%0" + n.tostring() + "x";
        return format(fs, i);
    }

    /**
     * Generate an ascii representation of a hex string of bytes.
     * @param {blob/string} b - The input string or blob.
     * @returns {string} - The ascii-encoded hex string output.
     * @private
    */
    function _dumpBytes(b) {
        local rs = "";
        for (local i = 0 ; i < b.len() ; i++) {
            rs += "\\x" + _toHex(b[i])
        }
        return rs;
    }
}
