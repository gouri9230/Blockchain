// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <=0.8.17;

abstract contract Game {
    string homeTeam; 
    string awayTeam;
    
    constructor(string memory _homeTeam, string memory _awayTeam) {
        homeTeam = _homeTeam;
        awayTeam = _awayTeam;
    }
    function getHomeTeamScore() public view virtual returns(uint256);
    function getAwayTeamScore() public view virtual returns(uint256);
    function getWinningTeam() public view returns(string memory) {
        if (getAwayTeamScore() > getHomeTeamScore()) {
            return awayTeam;
        }
        else {
            return homeTeam;
        }
    }
}

contract BasketballGame is Game {
    uint256 awayScoreB;
    uint256 homeScoreB;

    constructor(string memory _homeTeam, string memory _awayTeam) Game(_homeTeam, _awayTeam) {}

    function getHomeTeamScore() public view override returns(uint256) {
        return homeScoreB;
    }
    function getAwayTeamScore() public view override returns(uint256) {
        return  awayScoreB;
    }
    function homeTeamScored(uint256 score) external {
        require(score < 4, "only 1,2,3 scores are allowed");
        homeScoreB += score;
    }
    function awayTeamScored(uint256 score) external {
        require(score < 4, "only 1,2,3 scores are allowed");
        awayScoreB += score;
    }
}

contract SoccerGame is Game {
    uint256 awayScoreS;
    uint256 homeScoreS;

    constructor(string memory _homeTeam, string memory _awayTeam) Game(_homeTeam, _awayTeam) {}
    
    function getHomeTeamScore() public view override returns(uint256) {
        return homeScoreS;
    }
    function getAwayTeamScore() public view override returns(uint256) {
        return  awayScoreS;
    }
    function homeTeamScored() external {
        homeScoreS += 1;
    }
    function awayTeamScored() external {
        awayScoreS += 1;
    }         
}
