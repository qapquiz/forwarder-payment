// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Forwarder.sol";
import "forge-std/console2.sol";
import "openzeppelin-contracts/contracts/proxy/Clones.sol";
import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract ForwarderFactory {
    // forwarder => unclaimCloneForwarder
    mapping(address => address[]) clones;

    function initForwarder(address destination)
        public
        returns (Forwarder forwarder)
    {
        forwarder = new Forwarder(destination);
        clones[address(forwarder)].push(address(forwarder));
    }

    function createCloneForwarder(address implementation, bytes32 salt)
        public
        returns (Forwarder cloneForwarder)
    {
        Forwarder forwarder = Forwarder(implementation);
        
        address result = Clones.cloneDeterministic(implementation, salt);
        cloneForwarder = Forwarder(result);
        cloneForwarder.init(forwarder.destination());

        clones[address(forwarder)].push(address(cloneForwarder));
    }

    function flushAll(address forwarderAddress, address tokenContractAddress) public {
        address[] memory clonesForwarder = clones[forwarderAddress];
        require(clonesForwarder.length != 0, "there is no forwarder");

        IERC20 tokenContract = IERC20(tokenContractAddress);

        for (uint index = 0; index < clonesForwarder.length; index++) {
            address cloneAddress = clonesForwarder[index];
            if (tokenContract.balanceOf(cloneAddress) <= 0) {
                continue;
            }

            // balance not zero
            Forwarder(cloneAddress).flushERC20(tokenContractAddress);
        }
    }
}
