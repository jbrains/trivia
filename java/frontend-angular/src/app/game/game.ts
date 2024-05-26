import {Player} from "../user/player";
import {GameResponseDto} from "../openapi-generated";
import {playerDtoToPlayer, playerToPlayerDto} from "../common/helpers";

export class Game {
  id: number
  name: string
  state: string;
  turn: number;
  creator: Player;
  currentPlayer: Player;
  players: Player[];
  winner?: Player

  constructor(id: number, name: string, state: string, turn: number, creator: Player, currentPlayer: Player, players: Player[], winner?: Player) {
    this.id = id;
    this.name = name;
    this.state = state;
    this.turn = turn;
    this.creator = creator;
    this.currentPlayer = currentPlayer;
    this.players = players;
    this.winner = winner;
  }

  static fromDto(dto: GameResponseDto): Game {
    return new Game(dto.id,
      dto.name,
      dto.state,
      dto.turn,
      playerDtoToPlayer(dto.creator),
      playerDtoToPlayer(dto.currentPlayer),
      dto.players.map(
        playerDto => playerDtoToPlayer(playerDto)
      ),
      dto.winner ? playerDtoToPlayer(dto.winner) : undefined
    )
  }

  toDto(): GameResponseDto {
    return {
      id: this.id,
      name: this.name,
      state: this.state,
      turn: 0,
      creator: playerToPlayerDto(this.creator),
      currentPlayer: playerToPlayerDto(this.currentPlayer),
      players: this.players.map(player => playerToPlayerDto(player))
    }
  }
}
