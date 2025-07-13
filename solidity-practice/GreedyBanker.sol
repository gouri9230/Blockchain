// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;
/*
Allows users to deposit funds directly to contract address
User: 
a) gets 1 free deposit
b) afterwards all deposits have a fee of 1000 wei
c) allowed to withdraw deposited ammount
Owner:
a) collects all fees and can withdraw whenever needed
b) fallback to handle if user sends invalid funds
*/
contract GreedyBanker {
    address owner;
    mapping(address => uint256) balances;
    mapping(address => uint256) counter;
    mapping(address => uint256) totalFeesCollected;
    uint256 constant fees = 1000 wei;

    constructor() {
        owner = msg.sender;
    }
    receive() external payable {
        if (counter[msg.sender] == 0) {
            balances[msg.sender] += msg.value;
            counter[msg.sender]++;
        }
        else {
            require(msg.value >= fees, "please pay minimum 1000 wei fee to deposit");
            uint256 deposited = msg.value - fees;
            balances[msg.sender] += deposited;
            totalFeesCollected[owner] += fees;
            counter[msg.sender]++;
        }
    }

    fallback() external payable {
        totalFeesCollected[owner] += msg.value;     
    }

    function withdraw(uint256 amount) external payable {
        require(balances[msg.sender] >= amount, "you do not have enough balance to withdraw");
        balances[msg.sender] -= amount;
        (bool success,) = msg.sender.call{value: amount}("");
        require(success);
    }

    function collectFees() external {
        require(msg.sender == owner, "you are not the owner of the contract");
        uint256 fee = totalFeesCollected[owner];
        totalFeesCollected[owner] = 0;
        (bool success,) = owner.call{value: fee}("");
        require(success, "withdrawal failed");
    }

    function getBalance() public view returns (uint256) {
        return balances[msg.sender];
    }
}