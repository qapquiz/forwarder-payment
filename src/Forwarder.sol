// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract Forwarder {
    address public destination;

    constructor(address _destination) {
        destination = _destination;
    }

    function flushERC20(address tokenContractAddress) public {
        IERC20 tokenContract = IERC20(tokenContractAddress);
        uint256 forwarderBalance = tokenContract.balanceOf(address(this));
        tokenContract.transfer(destination, forwarderBalance);
    }
}