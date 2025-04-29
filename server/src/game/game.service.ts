import { Injectable } from '@nestjs/common';
import { WebSocketServer } from '@nestjs/websockets';
import { cert, getApps, initializeApp } from 'firebase-admin/app';
import { Firestore, getFirestore } from 'firebase-admin/firestore';
import { Server } from 'socket.io';

const serviceAccount = require('../../secrets/serviceAccountKey.json');

@Injectable()
export class GameService {
  @WebSocketServer()
  private server: Server;
  private firestore: Firestore;

  constructor() {
    if (getApps().length === 0) {
      initializeApp({
        credential: cert(serviceAccount),
      });
    }
    this.firestore = getFirestore();
  }

  async makeMove(gameId: string, userId: string, move: any) {
    let newGameState: any;
    const gameRef = this.firestore.collection('users').doc(gameId);
    await this.firestore.runTransaction(async (transaction) => {
      const gameDoc = await transaction.get(gameRef);

      if (!gameDoc.exists) {
        throw new Error(`Game ${gameId} not found`);
      }

      const moves = gameDoc.data()?.moves || [];
      const newMoves = [...moves, move];

      newGameState = { ...gameDoc.data(), moves: newMoves };

      transaction.update(gameRef, newGameState);
    });
    return newGameState;
  }

  async emitGameState(gameId: string, gameState: any) {
    this.server.to(gameId).emit('move-made', gameState);
  }
}
