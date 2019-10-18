#require "JSONEncoder.class.nut:3.0.0"

/**
 * Example of blob serialization
 */

local b = blob(144);
b.writestring("Welcome to the Electric Imp Dev Center. We’ve collected everything you’ll need to build great connected products with the Electric Imp Platform.")

local j = JSONEncoder.encode({"binary_data":b});
server.log(j);

// Logs:
// {"binary_data":"V2VsY29tZSB0byB0aGUgRWxlY3RyaWMgSW1wIERldiBDZW50ZXIuIFdl4oCZdmUgY29sbGVjdGVkIGV2ZXJ5dGhpbmcgeW914oCZbGwgbmVlZCB0byBidWlsZCBncmVhdCBjb25uZWN0ZWQgcHJvZHVjdHMgd2l0aCB0aGUgRWxlY3RyaWMgSW1wIFBsYXRmb3JtLg=="}