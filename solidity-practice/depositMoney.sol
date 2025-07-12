// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract Funds {

    address public owner;
    mapping (address => uint) public balances;

    event displayResult(address indexed user, uint amount);

    constructor() {
        owner = msg.sender; 
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        emit displayResult(msg.sender, msg.value);
    }

    function checkBalance(address sender) public view returns(uint) {
        return balances[sender]; 
    }
    function withdrawal(uint amount) public {
        require(balances[msg.sender] >= amount, "insufficient balance");
        balances[msg.sender] -= amount;
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "withdrawal fail");
    } 
}

contract Caller {
    address public owner;
    Funds public funds;

    constructor(address _funds) {
        owner = msg.sender;
        funds = Funds(_funds);
    }

    function sendFunds() public payable {
        require(msg.value >= 1 ether, "send atleast 1 ether");
        funds.deposit{value: msg.value}();
        //funds.withdrawal(msg.value);
    }

    receive() external payable {
        if (funds.checkBalance(address(this)) >= 1 ether) {
            funds.withdrawal(1 ether);
        }
    }
    
}