import { Injectable } from '@nestjs/common';
import { WebSocketServer } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';

@Injectable()
export class MatchmakingService {
  @WebSocketServer()
  private server: Server;
  private waitingPlayers: Map<string, Socket> = new Map();

  addPlayer(userId: string, socket: Socket) {
    this.waitingPlayers.set(userId, socket);
    this.tryMatchPlayers();
  }

  removePlayer(userId: string) {
    this.waitingPlayers.delete(userId);
  }

  private tryMatchPlayers() {
    if (this.waitingPlayers.size > 1) {
      const players = Array.from(this.waitingPlayers.entries());

      const player1Id = players[0][0];
      const player1Socket = players[0][1];
      const player2Id = players[1][0];
      const player2Socket = players[1][1];

      const gameId = this.generateGameId();

      player1Socket.join(gameId);
      player2Socket.join(gameId);
      this.server.to(gameId).emit('match-found');

      this.waitingPlayers.delete(player1Id);
      this.waitingPlayers.delete(player2Id);
    }
  }

  private generateGameId(): string {
    return Math.random().toString(36).substr(2, 9);
  }
}
