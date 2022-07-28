// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Forwarder.sol";
import "forge-std/console2.sol";


contract ForwarderFactory {
    function initForwarder(address destination)
        public
        returns (Forwarder forwarder)
    {
        bytes memory deploymentData = abi.encodePacked(
            type(Forwarder).creationCode,
            abi.encode(destination)
        );

        address deterministicAddress;
        assembly {
            deterministicAddress := create2(0x0, add(0x20, deploymentData), mload(deploymentData), 777)
        }
        console2.logAddress(deterministicAddress);

        forwarder = new Forwarder(destination);
    }
}
