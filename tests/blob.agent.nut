// Copyright (c) 2019 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

device.on("get.json", function(s) {

    // Native base64-encode the received string
    local b = http.base64encode(s);
    local t = {"binary_data":b};

    // Native JSON-encode the new table
    local j = http.jsonencode(t);

    // Send it back to the device to complete the test
    device.send("set.json", j);
});