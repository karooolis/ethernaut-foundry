// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/24-PuzzleWallet/PuzzleWallet.sol";
import "../src/levels/24-PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletTest is Test, BaseTest {
    PuzzleWallet public level;

    constructor() {
        levelFactory = new PuzzleWalletFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(this._createLevelInstance{value: 0.001 ether}());
        level = PuzzleWallet(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() public override {
        console.log("attack");
    }
}
