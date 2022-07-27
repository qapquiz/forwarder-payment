// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console2.sol";
import "openzeppelin-contracts/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";
import "../src/ForwarderFactory.sol";
import "../src/Forwarder.sol";

contract ForwarderFactoryTest is Test {
    ForwarderFactory private forwarderFactory;
    ERC20PresetMinterPauser private dummyToken;

    function setUp() public {
        forwarderFactory = new ForwarderFactory();
        dummyToken = new ERC20PresetMinterPauser("Dummy Token", "DMT");
    }

    function testCreateForwarder() public {
        forwarderFactory.initForwarder(address(1));
    }

    function testFlushERC20() public {
        Forwarder forwarder = forwarderFactory.initForwarder(address(1));
        dummyToken.mint(address(forwarder), 200);

        forwarder.flushERC20(address(dummyToken));
        assertGt(dummyToken.balanceOf(address(1)), 0);
    }
}