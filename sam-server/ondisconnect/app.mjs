import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, DeleteCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(client);

export const handler = async (event) => {
  const deleteParams = {
    TableName: process.env.CONNECTIONS_TABLE_NAME,
    Key: { connectionId: event.requestContext.connectionId },
  };
  const deleteMatchmakingParams = {
    TableName: MATCHMAKING_TABLE_NAME,
    Key: { connectionId: event.requestContext.connectionId },
    ConditionExpression: "#s = :expectedStatus",
    ExpressionAttributeNames: {
      "#s": "status",
    },
    ExpressionAttributeValues: {
      ":expectedStatus": "waiting",
    },
  };

  try {
    await docClient.send(new DeleteCommand(deleteParams));
    await docClient.send(new DeleteCommand(deleteMatchmakingParams));
  } catch (err) {
    return {
      statusCode: 500,
      body: "Failed to disconnect: " + JSON.stringify(err),
    };
  }

  return { statusCode: 200, body: "Disconnected." };
};
