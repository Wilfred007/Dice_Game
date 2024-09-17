// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract pseudoRandomLudo {
    mapping(address => uint) public playerPositions;

    mapping(address => uint) public playerStatus;

    uint public numPlayers;

    uint public turnNumber;

    uint public seed;

    event DiceRolled(address player, uint roll);

    event PlayerMoved(address player, uint newPosition);

    event GameFinished(address player);

    constructor() {
        seed = block.timestamp;
    }

    function joinGame() public {
        require(numPlayers < 4, "Game is already full");

        playerPositions[msg.sender] = 0;
        playerStatus[msg.sender] = 1;
        numPlayers++;

        emit PlayerMoved(msg.sender, 0);
    }

    function rollDice() public {
        require(playerStatus[msg.sender] == 1, "You are not in the game or it's not your turn");

        uint roll = (seed + block.timestamp) % 6 + 1;

        seed = roll;

        emit DiceRolled(msg.sender, roll);

        movePlayer(roll);
    }

    function movePlayer(uint roll) internal {
        uint newPosition = playerPositions[msg.sender] + roll;

        if (newPosition >= 52) {
            playerStatus[msg.sender] = 2;

            emit GameFinished(msg.sender);
        } else {
            playerPositions[msg.sender] = newPosition;

            emit PlayerMoved(msg.sender, newPosition);
        }
    }
}