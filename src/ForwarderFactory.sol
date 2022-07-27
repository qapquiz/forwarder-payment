// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Forwarder.sol";

contract ForwarderFactory {
    function initForwarder(address destination) public returns (Forwarder forwarder) {
        forwarder = new Forwarder(destination);
    }
}