package com.adaptionsoft.games.uglytrivia;

import java.util.ArrayList;
import java.util.List;

// Orquestra uma partida de Trivia: mantém a lista de jogadores, controla de
// quem é a vez e aplica as regras de cada rodada (rolar o dado, responder certo
// ou errado). A geração e a entrega das perguntas ficam em QuestionDeck e o
// estado individual de cada jogador em Player.
// Author: lukasnascimento1
public class Game {

    private static final int BOARD_SIZE = 12;

    private final List<Player> players = new ArrayList<>();
    private final QuestionDeck questions = new QuestionDeck();

    private int currentPlayer = 0;

    public boolean isPlayable() {
        return howManyPlayers() >= 2;
    }

    public boolean add(String playerName) {
        players.add(new Player(playerName));

        System.out.println(playerName + " was added");
        System.out.println("They are player number " + players.size());
        return true;
    }

    public int howManyPlayers() {
        return players.size();
    }

    public void roll(int roll) {
        Player player = currentPlayer();

        System.out.println(player + " is the current player");
        System.out.println("They have rolled a " + roll);

        if (player.isInPenaltyBox() && !leavesPenaltyBox(player, roll)) {
            return;
        }

        movePlayerAndAskQuestion(player, roll);
    }

    public boolean wasCorrectlyAnswered() {
        Player player = currentPlayer();

        if (player.isInPenaltyBox() && !player.isGettingOutOfPenaltyBox()) {
            nextPlayer();
            return true;
        }

        rewardCorrectAnswer(player);

        boolean notAWinner = !player.hasWon();
        nextPlayer();
        return notAWinner;
    }

    public boolean wrongAnswer() {
        Player player = currentPlayer();

        System.out.println("Question was incorrectly answered");
        System.out.println(player + " was sent to the penalty box");
        player.sendToPenaltyBox();

        nextPlayer();
        return true;
    }

    // Decide, pelo dado, se o jogador sai da penalty box nesta rodada.
    private boolean leavesPenaltyBox(Player player, int roll) {
        player.tryToLeavePenaltyBox(roll);

        if (!player.isGettingOutOfPenaltyBox()) {
            System.out.println(player + " is not getting out of the penalty box");
            return false;
        }

        System.out.println(player + " is getting out of the penalty box");
        return true;
    }

    private void movePlayerAndAskQuestion(Player player, int roll) {
        player.move(roll, BOARD_SIZE);
        Category category = Category.fromPlace(player.getPlace());

        System.out.println(player + "'s new location is " + player.getPlace());
        System.out.println("The category is " + category);
        System.out.println(questions.nextQuestion(category));
    }

    // Mensagem preservada do código original (inclusive o erro de digitação "corrent").
    private void rewardCorrectAnswer(Player player) {
        System.out.println(player.isInPenaltyBox()
                ? "Answer was correct!!!!"
                : "Answer was corrent!!!!");

        player.addCoin();
        System.out.println(player + " now has " + player.getPurse() + " Gold Coins.");
    }

    private Player currentPlayer() {
        return players.get(currentPlayer);
    }

    private void nextPlayer() {
        currentPlayer = (currentPlayer + 1) % players.size();
    }
}
