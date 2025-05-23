const winningCombinations = [
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  [0, 4, 8],
  [2, 4, 6],
];

export const isGameWon = (board) => {
  for (let i = 0; i < winningCombinations.length; i++) {
    const [a, b, c] = winningCombinations[i];
    if (board[a] && board[b] === board[a] && board[c] === board[a]) {
      return true;
    }
  }
};

export const isGameOver = (board) => {
  return board.every((cell) => cell !== "");
};
