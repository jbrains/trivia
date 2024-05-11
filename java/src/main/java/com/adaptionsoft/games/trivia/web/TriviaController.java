package com.adaptionsoft.games.trivia.web;

import com.adaptionsoft.games.trivia.domain.Game;
import com.adaptionsoft.games.trivia.domain.GameFactory;
import com.adaptionsoft.games.trivia.domain.GameRepository;
import com.adaptionsoft.games.trivia.domain.Player;
import com.adaptionsoft.games.trivia.domain.exception.GameNotFoundException;
import com.adaptionsoft.games.trivia.domain.exception.PlayerNotFoundInGameException;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springdoc.core.converters.ResponseSupportConverter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.Arrays;
import java.util.Collection;
import java.util.Optional;
import java.util.stream.IntStream;

import static org.springframework.http.HttpStatus.NOT_FOUND;

@RequiredArgsConstructor
@RestController
@RequestMapping("/games")
@CrossOrigin(origins = "${application.allowed-origins}")
public class TriviaController {

    private static final Logger log = LoggerFactory.getLogger(TriviaController.class);
    private final GameRepository gameRepository;
    private final GameFactory gameFactory;
    private final SimpMessagingTemplate template;
    private final ResponseSupportConverter responseSupportConverter;

    @PostConstruct
    public void postConstruct() {
        Player[] game1Players = IntStream.rangeClosed(1, 3).mapToObj(value -> new Player(value, "player-" + value)).toArray(Player[]::new);
        Player[] game2Players = IntStream.rangeClosed(4, 6).mapToObj(value -> new Player(value, "player-" + value)).toArray(Player[]::new);
        Game game1 = gameFactory.create("game-1", game1Players[0], Arrays.copyOfRange(game1Players, 1, game1Players.length));
        Game game2 = gameFactory.create("game-2", game2Players[0], Arrays.copyOfRange(game2Players, 1, game2Players.length));
        gameRepository.save(game1);
        gameRepository.save(game2);
    }

    @GetMapping
    public Collection<GameResponseDto> listGames() {
        return gameRepository.list().stream().map(GameResponseDto::from).toList();
    }

    @Operation(summary = "get a game by its id")
    @ApiResponse(
            responseCode = "200",
            content = {
                    @Content(
                            mediaType = MediaType.APPLICATION_JSON_VALUE,
                            schema = @Schema(implementation = GameResponseDto.class)
                    )
            }
    )
    @ApiResponse(
            responseCode = "404",
            description = "game not found",
            content = {
                    @Content(
                            mediaType = MediaType.APPLICATION_PROBLEM_JSON_VALUE,
                            examples = {
                                    @ExampleObject(value = "{\"type\":\"about:blank\",\"title\":\"Not Found\",\"status\":404,\"instance\":\"/games/777\"}")
                            }
                    )
            }
    )
    @GetMapping("/{gameId}")
    public GameResponseDto getGameById(@PathVariable("gameId") int gameId) {
        return gameRepository.findById(gameId).map(GameResponseDto::from).orElseThrow(() -> new ResponseStatusException(NOT_FOUND));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public GameResponseDto createGame(@RequestBody CreateGameRequestDto requestDto) {
        Game game = gameFactory.create(requestDto.gameName(), requestDto.toDomain());
        gameRepository.save(game);
        return GameResponseDto.from(game);
    }

    @PostMapping("/{gameId}/players/{playerId}/join")
    // FIXME map path param to method parameter, validate & test
    @ResponseStatus(HttpStatus.CREATED)
    public GameResponseDto addPlayerToGame(@PathVariable("gameId") Integer gameId,
                                           @RequestBody UserDto userDto) {
        Game game = findGameOrThrow(gameId);
        game.addPlayer(new Player(userDto.id(), userDto.name()));
        gameRepository.save(game);
        return GameResponseDto.from(game);
    }

    @PostMapping("/{gameId}/players/{playerId}/start")
    public GameResponseDto startGame(@PathVariable("gameId") Integer gameId,
                                     @PathVariable("playerId") Integer playerId) {
        Game game = findGameOrThrow(gameId);
        Player player = findPlayerOrThrow(game, playerId);
        game.startBy(player);
        gameRepository.save(game);
        return GameResponseDto.from(game);
    }

    @PostMapping("/{gameId}/players/{playerId}/playTurn")
    public GameResponseDto playTurn(@PathVariable("gameId") Integer gameId,
                                    @PathVariable("playerId") Integer playerId) {
        Game game = findGameOrThrow(gameId);
        Player player = findPlayerOrThrow(game, playerId);
        game.playTurnBy(player);
        gameRepository.save(game);
        return GameResponseDto.from(game);
    }

    @GetMapping("/test-ws/{gameId}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void hello(@PathVariable("gameId") Integer gameId) {
        log.info("test ws pour la partie %s".formatted(gameId));
        new Thread(() -> {
            try {
                Thread.sleep(1000);
                template.convertAndSend("/topic/game/%d".formatted(gameId), "hello websocket - game #%d".formatted(gameId));
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }).start();
    }

    private Game findGameOrThrow(Integer gameId) {
        return gameRepository.findById(gameId).orElseThrow(() -> new GameNotFoundException(gameId));
    }

    private Player findPlayerOrThrow(Game game, Integer playerId) {
        return game.findPlayerById(playerId).orElseThrow(() -> new PlayerNotFoundInGameException(game.getId(), playerId));
    }
}
