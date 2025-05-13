import {
  ApiGatewayManagementApiClient,
  PostToConnectionCommand,
} from "@aws-sdk/client-apigatewaymanagementapi";

const sendMessage = async (event, connectionId, message) => {
  const domainName = event.requestContext.domainName;
  const stage = event.requestContext.stage;
  const callbackUrl = `https://${domainName}/${stage}`;

  const client = new ApiGatewayManagementApiClient({
    endpoint: callbackUrl,
  });

  const command = new PostToConnectionCommand({
    ConnectionId: connectionId,
    Data: Buffer.from(JSON.stringify(message)),
  });

  try {
    await client.send(command);
  } catch (err) {
    console.error("Failed to send message", err);
  }
};

export const sendJoinedGameMessage = (event, connectionId, gameId, symbol) => {
  return sendMessage(event, connectionId, {
    event: "joinedGame",
    data: { gameId, symbol, turn: "X" },
  });
};

export const sendPlacedInQueueMessage = (event, connectionId) => {
  return sendMessage(event, connectionId, { event: "placedInQueue" });
};

export const sendGameWonMessage = (event, connectionId, gameId, board) => {
  return sendMessage(event, connectionId, {
    event: "gameWon",
    data: { gameId, board },
  });
};

export const sendGameLostMessage = (event, connectionId, gameId, board) => {
  return sendMessage(event, connectionId, {
    event: "gameLost",
    data: { gameId, board },
  });
};

export const sendGameOverMessage = (event, connectionId, gameId, board) => {
  return sendMessage(event, connectionId, {
    event: "gameOver",
    data: { gameId, board },
  });
};

export const sendMoveMadeMessage = (
  event,
  connectionId,
  gameId,
  board,
  turn
) => {
  return sendMessage(event, connectionId, {
    event: "moveMade",
    data: { gameId, board, turn },
  });
};

export const sendErrorMessage = (event, connectionId, message) => {
  return sendMessage(event, connectionId, {
    event: "error",
    data: { message },
  });
};
