// Copyright (c) 2017 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class BasicDeviceTestCase extends ImpTestCase {

  function test01() {
    local emptyblob = blob(0);
    local data = {
      a = emptyblob
    };

    local res = ::JSONEncoder.encode(data);

    this.assertEqual("{\"a\":\"\"}", res);
  }
}
