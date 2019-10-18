// Copyright (c) 2019 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

@include "github:electricimp/JSONEncoder/JSONEncoder.class.nut@fix-binary-string-issue"
@include "github:electricimp/JSONParser/JSONParser.class.nut"

class BlobDeviceTestCase extends ImpTestCase {

    function test01() {
        // Create a blob and add meaningful data to it
        local b = blob(144);
        local s = "Welcome to the Electric Imp Dev Center. We’ve collected everything you’ll need to build great connected products with the Electric Imp Platform.";
        b.writestring(s)

        // Encode the data and send to the agent for testing
        local j = ::JSONEncoder.encode({"binary_data":b});

        agent.on("set.json", function(js) {
            local t1 = ::JSONParser.parse(j);
            local b1 = t1.binary_data;
            local t2 = ::JSONParser.parse(js);
            local b2 = t2.binary_data;
            this.assertEqual(b1, b2);
        }.bindenv(this));

        agent.send("get.json", s);
    }
}