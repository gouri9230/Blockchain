// SPDX-License-Identifier: MIT
pragma solidity <= 0.8.12;

contract Friends {
    mapping (address => address[]) following;

    function follow(address toFollow) public {
        require (following[msg.sender].length < 3, "you can only follow 3 friends");
        require(msg.sender != toFollow, "you cannot follow yourself");
        following[msg.sender].push(toFollow);
    }

    function getFollowing(address addr) external view returns(address[] memory) {
        return following[addr];
    }

    function clearFollowing() public {
        delete following[msg.sender];
    }

}