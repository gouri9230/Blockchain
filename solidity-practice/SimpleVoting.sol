// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract Voting {
    uint8 mostVotes;
    uint8 winner;
    mapping(uint8 => uint8) VoteCounts;
    mapping(address => bool) voter;

    function getVotes(uint8 number) public view returns(uint8) {
        require(number >= 1 && number <= 5, "enter number within 1-5");
        return VoteCounts[number];
    }

    function vote(uint8 number) public {
        require(!voter[msg.sender], "you have already voted");
        require(number >= 1 && number <= 5, "enter number within 1-5");
        voter[msg.sender] = true;
        VoteCounts[number]++;
        if (mostVotes <= VoteCounts[number]) {
            winner = number;
            mostVotes = VoteCounts[number];
        }
    }

    function getCurrentWinner() public view returns(uint8) {
        if (winner == 0) {
            return 1;
        }
        else {
            return winner;
        }
    }
}