import { joinGame } from "./subactions/joinGame.mjs";
import { makeMove } from "./subactions/makeMove.mjs";

export const handler = async (event) => {
  try {
    const { subaction } = JSON.parse(event.body || "{}");

    if (subaction === "joinGame") {
      const resp = await joinGame(event);
      return resp;
    } else if (subaction === "makeMove") {
      const resp = await makeMove(event);
      return resp;
    }
  } catch (err) {
    console.error("Failed to handle event", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Internal server error" }),
    };
  }
};
