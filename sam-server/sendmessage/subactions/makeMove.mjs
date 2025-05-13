import {
  fetchGame,
  updateGameOver,
  updateGameTurn,
  updateGameWon,
} from "../db.mjs";
import {
  sendErrorMessage,
  sendGameLostMessage,
  sendGameOverMessage,
  sendGameWonMessage,
  sendMoveMadeMessage,
} from "../message.mjs";
import { isGameOver, isGameWon } from "../utils.mjs";

export const makeMove = async (event) => {
  const callerConnectionId = event.requestContext.connectionId;
  const {
    data: { gameId, move },
  } = JSON.parse(event.body || "{}");

  const gameResult = await fetchGame(gameId);

  if (gameResult.Item) {
    const game = gameResult.Item;
    const board = game.board;

    let symbol;
    if (game.playerXId === callerConnectionId) {
      symbol = "X";
    } else if (game.playerOId === callerConnectionId) {
      symbol = "O";
    } else {
      await sendErrorMessage(event, callerConnectionId, "Not your game.");
      return { statusCode: 403, body: "Not your game." };
    }

    if (game.status === "completed") {
      await sendErrorMessage(event, callerConnectionId, "Game is over.");
      return { statusCode: 400, body: "Game is over." };
    }

    if (game.turn !== symbol) {
      await sendErrorMessage(event, callerConnectionId, "Not your turn.");
      return { statusCode: 400, body: "Not your turn." };
    }

    if (board[move] !== "" || move > 8 || move < 0) {
      await sendErrorMessage(event, callerConnectionId, "Illegal move.");
      return { statusCode: 400, body: "Illegal move." };
    }

    const newBoard = [...board];
    newBoard[move] = symbol;

    if (isGameWon(newBoard)) {
      await updateGameWon(gameId, newBoard, symbol);
      const winnerConnectionId =
        symbol === "X" ? game.playerXId : game.playerOId;
      const loserConnectionId =
        symbol === "X" ? game.playerOId : game.playerXId;
      await sendGameWonMessage(event, winnerConnectionId, gameId, newBoard);
      await sendGameLostMessage(event, loserConnectionId, gameId, newBoard);
      return { statusCode: 200, body: "Game won." };
    }

    if (isGameOver(newBoard)) {
      await updateGameOver(gameId, newBoard);
      await sendGameOverMessage(event, game.playerXId, gameId, newBoard);
      await sendGameOverMessage(event, game.playerOId, gameId, newBoard);
      return { statusCode: 200, body: "Game over." };
    }

    const nextSymbol = symbol === "X" ? "O" : "X";

    await updateGameTurn(gameId, newBoard, nextSymbol);
    await sendMoveMadeMessage(
      event,
      game.playerXId,
      gameId,
      newBoard,
      nextSymbol
    );
    await sendMoveMadeMessage(
      event,
      game.playerOId,
      gameId,
      newBoard,
      nextSymbol
    );
    return { statusCode: 200, body: "Move made." };
  } else {
    await sendErrorMessage(event, callerConnectionId, "Game not found.");
    return { statusCode: 404, body: "Game not found." };
  }
};
