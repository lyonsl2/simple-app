import {
  addToMatchmakingQueue,
  createGame,
  getWaitingPlayer,
  matchPlayers,
} from "../db.mjs";
import {
  sendJoinedGameMessage,
  sendPlacedInQueueMessage,
} from "../message.mjs";

export const joinGame = async (event) => {
  const callerConnectionId = event.requestContext.connectionId;
  const waitingPlayer = await getWaitingPlayer();

  if (waitingPlayer.Items && waitingPlayer.Items.length > 0) {
    const existingPlayer = waitingPlayer.Items[0];
    await matchPlayers(existingPlayer.connectionId, callerConnectionId);

    const gameId = await createGame(
      callerConnectionId,
      existingPlayer.connectionId
    );
    await sendJoinedGameMessage(event, callerConnectionId, gameId, "X");
    await sendJoinedGameMessage(
      event,
      existingPlayer.connectionId,
      gameId,
      "O"
    );
    return { statusCode: 200, body: "Joined." };
  } else {
    await addToMatchmakingQueue(callerConnectionId);
    await sendPlacedInQueueMessage(event, callerConnectionId);
    return { statusCode: 200, body: "Placed in queue." };
  }
};
