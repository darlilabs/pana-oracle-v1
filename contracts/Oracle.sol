// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract OracleFactory {
    address public immutable governanceToken;
    address[] public oracles;

    event OracleCreated(address oracle);

    constructor(address _governanceToken) {
        governanceToken = _governanceToken;
    }

    function createOracle() external returns (address) {
        Oracle oracle = new Oracle(governanceToken, msg.sender);
        oracles.push(address(oracle));
        emit OracleCreated(address(oracle));
        return address(oracle);
    }

    function getOracles() external view returns (address[] memory) {
        return oracles;
    }
}

contract Oracle is Ownable {
    struct Vote {
        uint256 price;
        uint256 stake;
    }

    address public immutable governanceToken;
    mapping(address => uint256) public stakes;
    mapping(address => Vote) public votes;
    uint256 public totalStaked;
    uint256 public totalPrice;
    uint256 public voteCount;

    event Staked(address indexed user, uint256 amount);
    event PriceVoted(address indexed user, uint256 price);
    event Unstaked(address indexed user, uint256 amount);

    constructor(address _governanceToken, address initialOwner) Ownable(initialOwner) {
        governanceToken = _governanceToken;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Stake amount must be greater than zero");
        IERC20(governanceToken).transferFrom(msg.sender, address(this), amount);
        
        if (stakes[msg.sender] == 0) {
            voteCount++;
        }

        stakes[msg.sender] += amount;
        totalStaked += amount;
        
        emit Staked(msg.sender, amount);
    }

    function vote(uint256 price) external {
        require(stakes[msg.sender] > 0, "Must stake tokens to vote");
        Vote storage userVote = votes[msg.sender];
        
        if (userVote.stake > 0) {
            totalPrice -= userVote.price * userVote.stake;
        }

        userVote.price = price;
        userVote.stake = stakes[msg.sender];

        totalPrice += price * userVote.stake;

        emit PriceVoted(msg.sender, price);
    }

    function unstake(uint256 amount) external {
        require(stakes[msg.sender] >= amount, "Insufficient stake to unstake");

        Vote storage userVote = votes[msg.sender];
        totalStaked -= amount;
        stakes[msg.sender] -= amount;

        if (stakes[msg.sender] == 0) {
            voteCount--;
            totalPrice -= userVote.price * userVote.stake;
            delete votes[msg.sender];
        } else {
            totalPrice -= userVote.price * amount;
            userVote.stake -= amount;
        }

        IERC20(governanceToken).transfer(msg.sender, amount);

        emit Unstaked(msg.sender, amount);
    }

    function getAveragePrice() external view returns (uint256) {
        require(totalStaked > 0, "No staked tokens");
        return totalPrice / totalStaked;
    }
}
