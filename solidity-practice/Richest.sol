// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract Richest {
    mapping (address => uint256) users;
    address richest;
    uint256 amountSent;

    function becomeRichest() external payable returns (bool) {
        require (msg.value > amountSent, "send more ether to become richest");

        users[richest] += amountSent;
        richest = msg.sender;
        amountSent = msg.value;
        return true;
    }

    function withdraw() external {
        uint256 amount = users[msg.sender];
        users[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "cannot withdraw funds");
    }

    function getRichest() public view returns(address) {
        return richest;
    }
}