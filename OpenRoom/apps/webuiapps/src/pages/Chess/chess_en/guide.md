# Chess Guide

This guide explains how to use the Chess skill within OpenRoom.

## Overview

The Chess skill allows agents to play chess. It integrates with a chess engine to provide game logic and strategy.

## Features

- **Play Chess:** Agents can play chess against users or other agents.
- **Board Representation:** Visualizes the chessboard in a user-friendly format.
- **Move Validation:** Ensures all moves are legal according to chess rules.
- **Game State Management:** Tracks the current state of the game, including turn, captured pieces, and game history.
- **AI Opponent:** Configurable AI difficulty levels for opponent agents.

## How to Play

1.  **Start a Game:**
    Use the command `chess play <opponent>` to start a new game.
    -   `<opponent>` can be `human` (to play against another user) or an agent name (e.g., `claude-chess-bot`).

2.  **Making a Move:**
    Moves are entered in standard algebraic notation (e.g., `e2e4`, `Nb1c3`, `O-O`).

3.  **Game Controls:**
    -   `undo`: Revert the last move.
    -   `resign`: Forfeit the current game.
    -   `board`: Display the current board state.
    -   `help`: Show available commands.

## AI Opponent Configuration

You can configure the difficulty of the AI opponent by adjusting parameters such as:
- **Search Depth:** How many moves ahead the AI looks.
- **Evaluation Function:** The logic used to assess board positions.
- **Opening Book:** Pre-defined opening moves.

## Limitations

- **Real-time Play:** This skill is designed for turn-based play. Real-time chess is not supported.
- **Complex Endgames:** Very complex endgame scenarios may take longer to compute.

## Contributing

If you have ideas for improving the Chess skill or want to contribute, please refer to the OpenRoom contribution guidelines.

---

*Enjoy your game!*