package com.adaptionsoft.games.uglytrivia.event;

import com.adaptionsoft.games.uglytrivia.Player;
import lombok.EqualsAndHashCode;

@EqualsAndHashCode(callSuper = true)
public class PlayerAddedEvent extends PlayerEvent {
    public PlayerAddedEvent(Player player, int playersCount) {
        super(player, buildStringValue(player, playersCount));
    }

    private static String buildStringValue(Player player, int playersCount) {
        return "%s was added%nThey are player number %d".formatted(player.getName(), playersCount);
    }
}
