import { Module } from '@nestjs/common';
import { GameGateway } from './game.gateway';
import { GameService } from './game.service';
import { AuthService } from 'src/auth/auth.service';
import { MatchmakingService } from 'src/matchmaking/matchmaking.service';

@Module({
  providers: [GameGateway, GameService, AuthService, MatchmakingService],
  exports: [GameService],
})
export class GameModule {}
