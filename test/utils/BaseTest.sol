// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/Ethernaut.sol";

contract BaseTest is Test {
    Ethernaut internal ethernaut;
    Level internal levelFactory;

    address payable internal levelAddr;
    address internal attacker;

    function setUp() public virtual {
        // level setup
        ethernaut = new Ethernaut();
        ethernaut.registerLevel(levelFactory);

        // attacker setup
        attacker = makeAddr("attacker");
        vm.deal(attacker, 100 ether);
    }

    /// @dev Create a level instance
    function _createLevelInstance() internal returns (address) {
        vm.prank(attacker);
        return ethernaut.createLevelInstance(levelFactory);
    }

    /// @dev Implement the attack
    function _attack() internal virtual {}

    /// @dev Validate the level instance
    function _validateLevel() internal {
        vm.startPrank(attacker);
        bool success = ethernaut.submitLevelInstance(payable(levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}
