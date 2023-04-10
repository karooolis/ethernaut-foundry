// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/14-NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin public naughtCoinCTF;

    address player = address(0x1);

    function setUp() public {
        naughtCoinCTF = new NaughtCoin(player);
    }

    function testAttack() public {}
}
