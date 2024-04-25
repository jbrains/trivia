import {Component} from '@angular/core';
import {GameServiceAbstract} from "./game-service-abstract";
import {GameResponseDto} from "./openapi-generated";
import {Router} from "@angular/router";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'frontend-angular';
  games: GameResponseDto[] = [];
  playerName: string = 'player';

  constructor(private service: GameServiceAbstract,
              private router: Router) {
  }

  ngOnInit(): void {
    console.log("trivia application up and running")
    this.service.getGames()
      .subscribe(games => {
        this.games = games;
        return this.games
      });
  }

  addGame(newGame: GameResponseDto) {
    console.log(`app.component.ts received game: ${newGame}`);
    this.games.push(newGame);
  }

  deleteGame(game: GameResponseDto) {
    console.log(`deleting game ${game.id}`)
  }

  joinGame(game: GameResponseDto) {
    console.log(`joining game ${game.id}`)
    this.router.navigate(['/game']);
  }

  isCurrentPlayerCreator(game: GameResponseDto): boolean {
    return game.creator.name === this.playerName;
  }
}
