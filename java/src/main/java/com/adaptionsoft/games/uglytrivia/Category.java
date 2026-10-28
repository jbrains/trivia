package com.adaptionsoft.games.uglytrivia;

// Categorias de pergunta do tabuleiro. Cada casa do tabuleiro pertence a uma
// categoria, definida pelo resto da divisão da posição por 4. Centraliza a
// regra que antes vivia como strings soltas dentro de Game.
// Author: lukasnascimento1
public enum Category {
    POP("Pop"),
    SCIENCE("Science"),
    SPORTS("Sports"),
    ROCK("Rock");

    private final String displayName;

    Category(String displayName) {
        this.displayName = displayName;
    }

    // Mapeia a posição no tabuleiro para a categoria da casa.
    public static Category fromPlace(int place) {
        return values()[place % values().length];
    }

    @Override
    public String toString() {
        return displayName;
    }
}
