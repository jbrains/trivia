package com.adaptionsoft.games.trivia.domain.event;

import com.adaptionsoft.games.trivia.microarchitecture.EventListener;
import com.adaptionsoft.games.trivia.microarchitecture.EventPublisher;
import lombok.Getter;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class MockEventPublisher implements EventPublisher {
    @Getter
    private final List<Event> events = new ArrayList<>();
    private final List<EventListener> listeners = new ArrayList<>();

    @Override
    public void publish(Event... events) {
        publish(Arrays.asList(events));
    }

    @Override
    public void publish(Collection<Event> events) {
        this.events.addAll(events);
        events.forEach(event ->
                listeners.stream()
                        .filter(eventListener -> eventListener.accept(event))
                        .forEach(eventListener -> eventListener.handle(event))
        );
    }

    @Override
    public void register(EventListener listener) {
        this.listeners.add(listener);
    }

    public void clearEvents() {
        events.clear();
    }
}
