package com.adaptionsoft.games.uglytrivia;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.EnumMap;
import java.util.Map;

// Baralho de perguntas do jogo, separado por categoria. Extraído de Game para
// que ela não precise conhecer como as perguntas são geradas e armazenadas,
// apenas pedir a próxima pergunta de uma categoria.
// Author: lukasnascimento1
public class QuestionDeck {

    private static final int QUESTIONS_PER_CATEGORY = 50;

    private final Map<Category, Deque<String>> questionsByCategory = new EnumMap<>(Category.class);

    public QuestionDeck() {
        for (Category category : Category.values()) {
            questionsByCategory.put(category, createQuestions(category));
        }
    }

    // Retira e devolve a próxima pergunta da categoria, na ordem em que foram criadas.
    public String nextQuestion(Category category) {
        return questionsByCategory.get(category).removeFirst();
    }

    private Deque<String> createQuestions(Category category) {
        Deque<String> questions = new ArrayDeque<>();
        for (int i = 0; i < QUESTIONS_PER_CATEGORY; i++) {
            questions.addLast(category + " Question " + i);
        }
        return questions;
    }
}
