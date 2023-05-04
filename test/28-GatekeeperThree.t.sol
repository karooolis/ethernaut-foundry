// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/28-GatekeeperThree/GatekeeperThree.sol";
import "../src/levels/28-GatekeeperThree/GatekeeperThreeFactory.sol";

contract GatekeeperThreeTest is Test, BaseTest {
    GatekeeperThree public level;

    constructor() {
        levelFactory = new GatekeeperThreeFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(this._createLevelInstance());
        level = GatekeeperThree(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() public override {
        vm.startPrank(attacker);

        vm.stopPrank();
    }
}
