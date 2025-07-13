// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract EtherElection {
    uint256 etherReceived;
    mapping(address => bool) candidateAdded;
    uint8 candidatesCount;
    address owner;
    address winnerOfElection;
    uint256 feesCollected;
    bool votingEnded;
    uint256 constant fees = 10000 wei;
    mapping(address => uint8) votesReceived;
    mapping(address => bool) userVoted;

    constructor() {
        owner = msg.sender;
    }
    
    // candidates enroll for election by depositing 1 ether
    // only 3 candidates can enroll
    function enroll() public payable {
        require(msg.value == 1 ether, "deposit 1 ether to enroll as candidate");
        require(candidatesCount < 3, "candidates selection already completed");
        require(candidateAdded[msg.sender] == false, "you are already a candidate. cannot re-register");
        etherReceived += msg.value;
        candidatesCount++;
        candidateAdded[msg.sender] = true;
    }

    // users can vote to any 3 candidates, 1 vote per user
    // voting fees = 10000 wei
    function vote(address candidate) public payable {
        require(msg.value == fees, "send 10000 wei as fees to vote");
        require(userVoted[msg.sender] == false, "one vote per user. cannot re-vote");
        require(candidateAdded[candidate], "the address you have chosen to vote is not a candidate");
        require(!votingEnded, "voting is completed");
        userVoted[msg.sender] = true;
        feesCollected += msg.value;
        //once any candidate receives exactly 5 votes, they are declared as winner 
        if (votesReceived[candidate] < 5) {
            votesReceived[candidate]++;
            if (votesReceived[candidate] == 5) {
                winnerOfElection = candidate;
                votingEnded = true;
            }
        }
    }

    // if the voting has ended, declare the winner
    function getWinner() public view returns (address) {
        require(votingEnded, "winner has not yet been declared");
        return winnerOfElection;
    }

    // winner can claim the reward if the voting is concluded
    function calimReward() public {
        require(msg.sender == winnerOfElection, "you cannot claim reward as you are not the winner");
        require(votingEnded, "winner has not yet been declared");
        require(etherReceived != 0, "already withdrawn prize");
        etherReceived = 0;
        (bool sent, ) = payable(winnerOfElection).call{value: 3 ether}("");
        require(sent, "sent failed");
    }

    //owner of the contract can collect the fees and destroy the contract
    function collectFees() public {
        require(msg.sender == owner, "only owner can collect fees");
        require(votingEnded, "winner has not yet been declared");
        require(etherReceived == 0, "winner has not yet withdrawn prize");
        feesCollected = 0;
        selfdestruct(payable(owner)); 
    }
}