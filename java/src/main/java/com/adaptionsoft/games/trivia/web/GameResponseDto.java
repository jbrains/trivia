package com.adaptionsoft.games.trivia.web;

import com.adaptionsoft.games.trivia.domain.Game;
import jakarta.validation.constraints.NotBlank;
import lombok.With;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@With
public record GameResponseDto(
        @NotBlank
        Integer id,
        @NotBlank
        String name,
        @NotBlank
        String state,
        @NotBlank
        int turn,
        @NotBlank
        PlayerDto creator,
        @NotBlank
        Collection<PlayerDto> players,
        @NotBlank
        PlayerDto currentPlayer,
        PlayerDto winner
) {

    public GameResponseDto(@NotBlank Integer id,
                           @NotBlank String name,
                           @NotBlank String state,
                           @NotBlank
                           int turn,
                           @NotBlank
                           PlayerDto creator,
                           Collection<PlayerDto> players,
                           @NotBlank
                           PlayerDto currentPlayer) {
        this(id,
                name,
                state,
                turn,
                creator,
                players,
                currentPlayer,
                null);
    }

    public static GameResponseDto from(Game game) {
        List<PlayerDto> playersDto = game.getPlayersList().stream().map(PlayerDto::from).toList();
        PlayerDto creatorDto = PlayerDto.from(game.getCreator());
        PlayerDto currentPlayerDto = Optional.ofNullable(game.getCurrentPlayer())
                .map(PlayerDto::from)
                .orElse(null);
        PlayerDto winnerDto = Optional.ofNullable(game.getWinner()).map(PlayerDto::from).orElse(null);
        return new GameResponseDto(game.getId().getValue(),
                game.getName(),
                game.getState().toString(),
                game.getTurn(),
                creatorDto,
                playersDto,
                currentPlayerDto,
                winnerDto);
    }

}
