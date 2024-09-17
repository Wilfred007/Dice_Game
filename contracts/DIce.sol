// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract Ludo {
    // Mapping of players to their current position on the board
    mapping(address => uint) public playerPositions;

    // Mapping of players to their game status (0 - not started, 1 - in progress, 2 - finished)
    mapping(address => uint) public playerStatus;

    // The number of players in the game
    uint public numPlayers;

    // The current turn number
    uint public turnNumber;

    // The seed for the pseudorandom generator
    uint public seed;

    // Event emitted when a player rolls the dice
    event DiceRolled(address player, uint roll);

    // Event emitted when a player moves on the board
    event PlayerMoved(address player, uint newPosition);

    // Event emitted when a player finishes the game
    event GameFinished(address player);

    // Constructor to initialize the game
    constructor() {
        // Initialize the seed for the pseudorandom generator
        seed = block.timestamp;
    }

    // Function to add a player to the game
    function joinGame() public {
        // Check if the game is already full
        require(numPlayers < 4, "Game is already full");

        // Add the player to the game
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
            // Update the player's position
            playerPositions[msg.sender] = newPosition;

            // Emit an event to indicate that the player has moved
            emit PlayerMoved(msg.sender, newPosition);
        }
    }
}