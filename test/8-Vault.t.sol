// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/8-Vault.sol";

contract VaultTest is Test {
    Vault public vaultCTF;

    function setUp() public {
        vaultCTF = new Vault("abc123");
    }

    function testAttack() public {}
}
