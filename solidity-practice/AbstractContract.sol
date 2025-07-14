// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

/*
Users can deposit money in a bank and get signup bonus if the initial amount deposited is more than the BonusRequirements
They can withdraw amount anytime they want.
Usage of abstract constracts. 
*/
abstract contract SignUpBonus {
    mapping (address => uint256) balances;
    mapping(address => bool) userDepoisted;
    function getBonusAmount() public virtual view returns(uint256);
    function getBonusRequirements() public virtual view returns(uint256);

    function deposit() public payable {
        if (!userDepoisted[msg.sender]) {
            if (msg.value >= getBonusRequirements()) {
                balances[msg.sender] += msg.value + getBonusAmount(); 
                userDepoisted[msg.sender] = true;
            }
            else {
                balances[msg.sender] += msg.value;
                userDepoisted[msg.sender] = true;
            }
        }
        else {
            balances[msg.sender] += msg.value; 
        }
    }
    function withdraw(uint256 amount) public {
        require(balances[msg.sender] >= amount, "not enough balance");
        balances[msg.sender] -= amount;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent);
    }
    function getBalance() public view returns(uint256) {
        return balances[msg.sender];
    }
}

contract Bank is SignUpBonus {
    uint256 bonusReq = 1000 wei;
    uint256 bonus = 150 wei;

    function getBonusAmount() public override view returns(uint256) {
        return bonus;
    }

    function getBonusRequirements() public override view returns(uint256) {
        return bonusReq;
    }
}