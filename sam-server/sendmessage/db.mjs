import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  QueryCommand,
  TransactWriteCommand,
  PutCommand,
  GetCommand,
  UpdateCommand,
} from "@aws-sdk/lib-dynamodb";
import { v4 as uuidv4 } from "uuid";

const { MATCHMAKING_TABLE_NAME, GAMES_TABLE_NAME, AWS_REGION } = process.env;
const client = new DynamoDBClient({ region: AWS_REGION });
const docClient = DynamoDBDocumentClient.from(client);

export const getWaitingPlayer = async () => {
  const getWaitingQueryParams = {
    TableName: MATCHMAKING_TABLE_NAME,
    IndexName: "status-index",
    KeyConditionExpression: "#status = :waiting",
    ExpressionAttributeNames: {
      "#status": "status",
    },
    ExpressionAttributeValues: {
      ":waiting": "waiting",
    },
    ScanIndexForward: true,
    Limit: 1,
  };

  const queryResult = await docClient.send(
    new QueryCommand(getWaitingQueryParams)
  );
  return queryResult;
};

export const matchPlayers = async (waitingConnectionId, callerConnectionId) => {
  const transactParams = {
    TransactItems: [
      {
        Update: {
          TableName: MATCHMAKING_TABLE_NAME,
          Key: {
            connectionId: waitingConnectionId,
          },
          UpdateExpression: "SET #status = :matched",
          ConditionExpression: "#status = :waiting",
          ExpressionAttributeNames: {
            "#status": "status",
          },
          ExpressionAttributeValues: {
            ":matched": "matched",
            ":waiting": "waiting",
          },
        },
      },
      {
        Put: {
          TableName: MATCHMAKING_TABLE_NAME,
          Item: {
            connectionId: callerConnectionId,
            status: "matched",
            timestamp: Date.now(),
          },
        },
      },
    ],
  };

  await docClient.send(new TransactWriteCommand(transactParams));
};

export const addToMatchmakingQueue = async (connectionId) => {
  const putParams = {
    TableName: MATCHMAKING_TABLE_NAME,
    Item: {
      connectionId,
      status: "waiting",
      timestamp: Date.now(),
    },
  };

  await docClient.send(new PutCommand(putParams));
};

export const createGame = async (playerXId, playerOId) => {
  const gameId = uuidv4();
  const putParams = {
    TableName: GAMES_TABLE_NAME,
    Item: {
      gameId,
      playerXId,
      playerOId,
      board: Array(9).fill(""),
      turn: "X",
      status: "in_progress",
      createdAt: Date.now(),
      updatedAt: Date.now(),
    },
  };

  await docClient.send(new PutCommand(putParams));
  return gameId;
};

export const fetchGame = async (gameId) => {
  const getParams = {
    TableName: GAMES_TABLE_NAME,
    Key: { gameId },
  };

  const gameResult = await docClient.send(new GetCommand(getParams));
  return gameResult;
};

export const updateGameWon = async (gameId, board, symbol) => {
  const endGameParams = {
    TableName: GAMES_TABLE_NAME,
    Key: { gameId },
    UpdateExpression:
      "SET board = :board, turn = :turn, winner = :winner, #status = :status, updatedAt = :updatedAt",
    ExpressionAttributeNames: {
      "#status": "status",
    },
    ExpressionAttributeValues: {
      ":board": board,
      ":turn": "N/A",
      ":winner": symbol,
      ":status": "completed",
      ":updatedAt": Date.now(),
    },
  };
  await docClient.send(new UpdateCommand(endGameParams));
};

export const updateGameOver = async (gameId, board) => {
  const endGameParams = {
    TableName: GAMES_TABLE_NAME,
    Key: { gameId },
    UpdateExpression:
      "SET board = :board, turn = :turn, #status = :status, updatedAt = :updatedAt",
    ExpressionAttributeNames: {
      "#status": "status",
    },
    ExpressionAttributeValues: {
      ":board": board,
      ":turn": "N/A",
      ":status": "completed",
      ":updatedAt": Date.now(),
    },
  };
  await docClient.send(new UpdateCommand(endGameParams));
};

export const updateGameTurn = async (gameId, board, symbol) => {
  const updateGameParams = {
    TableName: GAMES_TABLE_NAME,
    Key: {
      gameId,
    },
    UpdateExpression:
      "SET board = :board, turn = :turn, updatedAt = :updatedAt",
    ExpressionAttributeValues: {
      ":board": board,
      ":turn": symbol,
      ":updatedAt": Date.now(),
    },
  };

  await docClient.send(new UpdateCommand(updateGameParams));
};
