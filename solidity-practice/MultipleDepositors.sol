// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract Competitors {
    address owner;
    address depositor1;
    address depositor2;
    uint256 totalBalance;
    address maxDepositor;
    bool withdrew;
    mapping(address => uint256) depositors;

    constructor() {
        owner = msg.sender;
    }

    function deposit() external payable {
        require(msg.value == 1 ether, "Allowed to deposit only 1 ether");
        require(totalBalance < 3 ether, "no more deposits accepted");
        // when called for 1st time, depositor1 is empty, i.e it has address 0.
        // that is what we are checking if depositor1 is assigned to some address or it is still 0
        // if not empty, then the caller's address becomes depositor1 and he becomes one of the depositor
        if (depositor1 == address(0)) {
            depositor1 = msg.sender;
        }
        // 2nd time function is called, depositor1 is not empty, but depositor2 is
        // so we assign the caller's address as 2nd depositor
        else if (depositor2 == address(0)) {
            depositor2 = msg.sender;
        }
        //next time whenever calls function to deposit, unless it is depositor1 or depositor2, they cannot deposit
        if (msg.sender == depositor1) {
            depositors[depositor1] += msg.value;
            totalBalance += msg.value;
        }
        else if (msg.sender == depositor2) {
            depositors[depositor2] += msg.value;
            totalBalance += msg.value;
        }
        // only first 2 callers can deposit.
        else {
            revert("you are not the depositor");
        }
        if (totalBalance == 3 ether) {
            if (depositors[depositor1] > depositors[depositor2]) {
                maxDepositor = depositor1;
            }
            else {
                maxDepositor = depositor2;
            }
        } 
    }

    function withdraw() external payable {
        require(totalBalance == 3 ether, "contract needs 3 ethers to withdraw");
        require(msg.sender == maxDepositor); 
        withdrew = true;
        (bool success, ) = maxDepositor.call{value: 3 ether}("");
        require(success);
    }

    function destroy() public {
        require(msg.sender == owner, "only owner can destroy");
        require(withdrew == true);
        selfdestruct (payable(msg.sender));
    }
}