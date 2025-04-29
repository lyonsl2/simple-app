import {
  WebSocketGateway,
  SubscribeMessage,
  MessageBody,
  ConnectedSocket,
  OnGatewayConnection,
  OnGatewayDisconnect,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { AuthService } from 'src/auth/auth.service';
import { MatchmakingService } from 'src/matchmaking/matchmaking.service';
import { GameService } from './game.service';

@WebSocketGateway({ cors: true })
export class GameGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  constructor(
    private authService: AuthService,
    private matchmakingService: MatchmakingService,
    private gameService: GameService,
  ) {}

  async handleConnection(client: Socket) {
    console.log('handleConnection!!!');
    const token = client.handshake.auth?.token;
    console.log(token);
    console.log(client.handshake);
    if (!token) client.disconnect();

    try {
      const decodedToken = await this.authService.verifyAndDecodeToken(token);
      console.log(decodedToken);
      client.data.userId = decodedToken.uid;
    } catch {
      client.disconnect();
    }
  }

  async handleDisconnect(client: Socket) {
    console.log('handleDisconnect!!!');
    const userId = client.data.userId;
    if (userId) {
      this.matchmakingService.removePlayer(userId);
    }
  }

  @SubscribeMessage('searchForGame')
  async searchForGame(@ConnectedSocket() client: Socket) {
    const userId = client.data.userId;
    this.matchmakingService.addPlayer(userId, client);
  }

  @SubscribeMessage('makeMove')
  async makeMove(
    @MessageBody() data: { gameId: string; move: any },
    @ConnectedSocket() client: Socket,
  ) {
    const { gameId, move } = data;
    const userId = client.data.userId;

    const gameState = await this.gameService.makeMove(gameId, userId, move);
    this.gameService.emitGameState(gameId, gameState);
  }
}
