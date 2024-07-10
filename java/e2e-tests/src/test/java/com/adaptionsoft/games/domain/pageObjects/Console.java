package com.adaptionsoft.games.domain.pageObjects;

import com.microsoft.playwright.ConsoleMessage;
import com.microsoft.playwright.Page;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Console {
    private final List<ConsoleMessage> currentScenarioLogs = new ArrayList<>();

    public Console(Page page) {
        page.onConsoleMessage(e -> {
            System.out.println("coucou log: %s".formatted(e.text()));
            getCurrentScenarioLogs().add(e);
        });
    }

    public synchronized List<ConsoleMessage> getCurrentScenarioLogs() {
        return currentScenarioLogs;
    }

    public List<String> getErrorLogs() {
        return getCurrentScenarioLogs().stream()
                .filter(consoleMessage -> Objects.equals("error", consoleMessage.type()))
                .map(ConsoleMessage::text)
                .toList();
    }

    public void clearLogs() {
        getCurrentScenarioLogs().clear();
    }
}
