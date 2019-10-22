// Copyright (c) 2017 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class BasicDeviceTestCase extends ImpTestCase {

    function test01() {

        // Test: empty blob
        local emptyblob = blob(0);
        local data = { a = emptyblob };
        local res = ::JSONEncoder.encode(data);
        this.assertEqual("{\"a\":\"\"}", res);
    }

    function test02() {

        // Test: Binary string -- see https://electricimp.atlassian.net/browse/CSE-702
        local binStr = "\xe8\x03\x00\x00\x01\x00\x00\xc0";
        local jsonStr = ::JSONEncoder.encode({"binary_string":binStr});
        this.assertEqual(jsonStr, "{\"binary_string\":\"\\xe8\\x03\\x00\\x00\\x01\\x00\\x00\\xc0\"}");
    }

    function test02() {

        // Test: Plain Ascii string
        local asciiStr = "Electric Imp Developer Center";
        local jsonStr = ::JSONEncoder.encode({"ascii_string":asciiStr});
        this.assertEqual(jsonStr, "{\"ascii_string\":\"Electric Imp Developer Center\"}");
    }

    function test04() {

        // Test: Unicode string 1
        local uniStr = "💾❤️😎🎸";
        local jsonStr = ::JSONEncoder.encode({"uni_string":uniStr});
        this.assertEqual(jsonStr, "{\"uni_string\":\"💾❤️😎🎸\"}");
    }

    function test05() {

        // Test: Unicode string 2
        local uniStr = "\xF0\x9F\x98\x9C";
        local jsonStr = ::JSONEncoder.encode({"uni_string":uniStr});
        this.assertEqual(jsonStr, "{\"uni_string\":\"😜\"}");
    }

    function test06() {

        // Test: Full Blob
        local b = blob(144);
        b.writestring("Welcome to the Electric Imp Dev Center. We’ve collected everything you’ll need to build great connected products with the Electric Imp Platform.");
        local jsonStr = ::JSONEncoder.encode({"blob":b});
        this.assertEqual(jsonStr, "{\"blob\":\"Welcome to the Electric Imp Dev Center. We’ve collected everything you’ll need to build great connected products with the Electric Imp Platform.\"}");
    }
}
