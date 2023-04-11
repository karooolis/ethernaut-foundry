// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/10-Reentrance/Reentrance.sol";
import "../src/levels/10-Reentrance/ReentranceFactory.sol";

contract ReentranceTest is Test {
    Ethernaut public ethernaut;
    ReentranceFactory public reentranceFactory;
    Reentrance public reentrance;

    address eoa1 = address(0x1);

    function setUp() public {
        vm.deal(eoa1, 10_000 ether);

        ethernaut = new Ethernaut();
        reentranceFactory = new ReentranceFactory();
        ethernaut.registerLevel(reentranceFactory);

        vm.startPrank(eoa1);
        address levelAddr = ethernaut.createLevelInstance{value: 1 ether}(
            reentranceFactory
        );
        reentrance = Reentrance(payable(levelAddr));
    }

    function testAttack() public {
        uint256 reentranceBalance = address(reentrance).balance;
        console.log(reentranceBalance);
    }
}
