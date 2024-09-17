// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract Ludo {
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

        // Emit an event to indicate that the player has joined the game
        emit PlayerMoved(msg.sender, 0);
    }

    // Function to roll the dice
    function rollDice() public {
        // Check if the player is in the game and it's their turn
        require(playerStatus[msg.sender] == 1, "You are not in the game or it's not your turn");

        // Generate a pseudorandom number between 1 and 6
        uint roll = (seed + block.timestamp) % 6 + 1;

        // Update the seed for the pseudorandom generator
        seed = roll;

        // Emit an event to indicate that the player has rolled the dice
        emit DiceRolled(msg.sender, roll);

        // Move the player on the board
        movePlayer(roll);
    }

    // Function to move a player on the board
    function movePlayer(uint roll) internal {
        // Calculate the new position of the player
        uint newPosition = playerPositions[msg.sender] + roll;

        // Check if the player has finished the game
        if (newPosition >= 52) {
            // Update the player's status to finished
            playerStatus[msg.sender] = 2;

            // Emit an event to indicate that the player has finished the game
            emit GameFinished(msg.sender);
        } else {
            playerPositions[msg.sender] = newPosition;

            emit PlayerMoved(msg.sender, newPosition);
        }
    }
}