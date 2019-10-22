#require "JSONEncoder.class.nut:2.1.0"

/**
 * Example of blob serialization
 */

local b = blob(144);
b.writestring("Welcome to the Electric Imp Dev Center. We’ve collected everything you’ll need to build great connected products with the Electric Imp Platform.");

local uniStr1 = "💾❤️😎🎸";
local uniStr2 = "\xF0\x9F\x98\x9C";

local j = JSONEncoder.encode({"binary_data":b, "uni_strings": [{"uni_string_one":uniStr}, {"uni_string_two":uniStr2}]});
server.log(j);

// Logs:
// {"uni_strings":[{"uni_string_one":"💾❤️😎🎸"},{"uni_string_two":"😜"}],"binary_data":"Welcome to the Electric Imp Dev Center. We’ve collected everything you’ll need to build great connected products with the Electric Imp Platform."}