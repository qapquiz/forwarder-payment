// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
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
        Forwarder forwarder = forwarderFactory.initForwarder(address(1));
        assertTrue(address(forwarder) != address(0));
    }

    function testCreateCloneForwarder() public {
        Forwarder forwarder = forwarderFactory.initForwarder(address(1));
        Forwarder cloneForwarder = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "2"
        );

        assertTrue(address(forwarder) != address(cloneForwarder));
        assertEq(forwarder.destination(), cloneForwarder.destination());
    }

    function testFlushERC20() public {
        Forwarder forwarder = forwarderFactory.initForwarder(address(1));
        dummyToken.mint(address(forwarder), 200);

        forwarder.flushERC20(address(dummyToken));
        assertGt(dummyToken.balanceOf(address(1)), 0);
    }

    function testFlushFiveForwarderManually() public {
        Forwarder forwarder = forwarderFactory.initForwarder(address(1));
        dummyToken.mint(address(forwarder), 200);

        Forwarder cloneForwarderOne = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "0"
        );
        dummyToken.mint(address(cloneForwarderOne), 200);

        Forwarder cloneForwarderTwo = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "1"
        );
        dummyToken.mint(address(cloneForwarderTwo), 200);

        Forwarder cloneForwarderThree = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "2"
        );
        dummyToken.mint(address(cloneForwarderThree), 200);

        Forwarder cloneForwarderFour = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "3"
        );
        dummyToken.mint(address(cloneForwarderFour), 200);

        forwarder.flushERC20(address(dummyToken));
        cloneForwarderOne.flushERC20(address(dummyToken));
        cloneForwarderTwo.flushERC20(address(dummyToken));
        cloneForwarderThree.flushERC20(address(dummyToken));
        cloneForwarderFour.flushERC20(address(dummyToken));

        assertEq(dummyToken.balanceOf(address(1)), 1000);
    }

    function testFlushFiveForwarderWithFlushAll() public {
        Forwarder forwarder = forwarderFactory.initForwarder(address(1));
        dummyToken.mint(address(forwarder), 200);

        Forwarder cloneForwarderOne = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "0"
        );
        dummyToken.mint(address(cloneForwarderOne), 200);

        Forwarder cloneForwarderTwo = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "1"
        );
        dummyToken.mint(address(cloneForwarderTwo), 200);

        Forwarder cloneForwarderThree = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "2"
        );
        dummyToken.mint(address(cloneForwarderThree), 200);

        Forwarder cloneForwarderFour = forwarderFactory.createCloneForwarder(
            address(forwarder),
            "3"
        );
        dummyToken.mint(address(cloneForwarderFour), 200);

        forwarderFactory.flushAll(address(forwarder), address(dummyToken));
        

        assertEq(dummyToken.balanceOf(address(1)), 1000);
    }
}
