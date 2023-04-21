// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Ethernaut.sol";
import "../src/levels/18-MagicNum/MagicNum.sol";
import "../src/levels/18-MagicNum/MagicNumFactory.sol";

// @note Run test with forge test --ffi in order to execute evm compile script
contract MagicNumTest is Test {
    Ethernaut public ethernaut;
    MagicNumFactory public magicNumFactory;
    MagicNum public magicNum;
    address internal levelAddr;

    address eoa1 = address(0x1);

    function setUp() public {
        ethernaut = new Ethernaut();
        magicNumFactory = new MagicNumFactory();
        ethernaut.registerLevel(magicNumFactory);

        vm.startPrank(eoa1);
        vm.deal(eoa1, 10_000 ether);

        levelAddr = ethernaut.createLevelInstance{value: 1 ether}(
            magicNumFactory
        );
        magicNum = MagicNum(payable(levelAddr));
    }

    function testAttack() public {
        string[] memory cmds = new string[](3);
        cmds[0] = "evm";
        cmds[1] = "compile";
        cmds[2] = string.concat("src/levels/18-MagicNum/MagicNum.asm");

        // compile contract into bytecode
        bytes memory bytecode = vm.ffi(cmds);

        // obtain deployed contract address
        address deployedAddress;
        assembly {
            deployedAddress := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        // set deployed contract as solver
        magicNum.setSolver(deployedAddress);

        bool success = ethernaut.submitLevelInstance(payable(levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}
