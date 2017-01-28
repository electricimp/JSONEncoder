// Copyright (c) 2017 Electric Imp
// This file is licensed under the MIT License
// http://opensource.org/licenses/MIT

class AgentTestCase extends ImpTestCase {
  function setUp() {
    return "Hi from #{__FILE__}!";
  }

  function testSomething() {
    this.assertTrue(this instanceof ImpTestCase);
  }

  function tearDown() {
    return "Test finished";
  }
}
