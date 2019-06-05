// Copyright (c) 2017-19 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class JSONEncoder {

    static VERSION = "2.0.1";

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
                // This is a workaround for a known bug:
                // on device side Blob.tostring() returns null
                // (instaead of an empty string)
                r += "\"" + (val.len() ? this._escape(val.tostring()) : "") + "\"";
                break;

            // Strings and all other
            default:
                r += "\"" + this._escape(val.tostring()) + "\"";
                break;
        }

        return r;
    }

    /**
     * Escape strings according to http://www.json.org/ spec
     * @param {string} str
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
                        throw "Insufficient data for 2-byte Unicode";
                    }
                } else if ((ch1 & 0xF0) == 0xE0) {
                    // 1110xxxx = 3-byte unicode
                    if (i + 2 < str.len()) {
                        local ch2 = (str[++i] & 0xFF);
                        local ch3 = (str[++i] & 0xFF);
                        res += format("%c%c%c", ch1, ch2, ch3);
                    } else {
                        throw "Insufficient data for 3-byte Unicode";
                    }
                } else if ((ch1 & 0xF8) == 0xF0) {
                    // 11110xxx = 4 byte unicode
                    if (i + 3 < str.len()) {
                        local ch2 = (str[++i] & 0xFF);
                        local ch3 = (str[++i] & 0xFF);
                        local ch4 = (str[++i] & 0xFF);
                        res += format("%c%c%c%c", ch1, ch2, ch3, ch4);
                    } else {
                        throw "Insufficient data for 4-byte Unicode";
                    }
                } else {
                    throw "String contains invalid Unicode";
                }
            }
        }

        return res;
    }

    function _toHex(i, l = 2) {
        if (l % 2 != 0) l++;
        local fs = "%0" + l.tostring() + "x";
        return format(fs, i);
    }
}
