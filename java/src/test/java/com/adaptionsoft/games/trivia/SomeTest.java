package com.adaptionsoft.games.trivia;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

import com.adaptionsoft.games.trivia.runner.GameRunner;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class SomeTest {

    private static class FakeOutput implements Output {
        private final List<String> messages = new ArrayList<>();

        @Override
        public void write(String message) {
            messages.add(message);
        }

        public String actualMessages() {
            return String.join("\n", messages);
        }

        public static String expectedMessages() throws IOException {
            return Files.readString(Paths.get("../reference/result.txt")).trim();
        }
    }

    private static class FakeFileInput implements Input {
        private final List<Integer> rolls;
        private final List<Integer> responses;
        private int rollIndex = 0;
        private int responseIndex = 0;

        public FakeFileInput() throws IOException {
            List<String> lines = Files.readAllLines(Paths.get("../reference/randomSeq.txt"));
            this.responses = parseLine(lines.get(1));
            this.rolls = parseLine(lines.get(4));
        }

        @Override
        public int die() {
            return rolls.get(rollIndex++);
        }

        @Override
        public boolean responseIsCorrect() {
            return responses.get(responseIndex++) != 7;
        }

        private List<Integer> parseLine(String line) {
            return Arrays.stream(line.split(","))
                    .map(String::trim)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
        }
    }

    @Test
    public void should_reproduce_reference_output() throws Exception {
        FakeOutput fakeOutput = new FakeOutput();

        new GameRunner(
            new FakeFileInput(),
            fakeOutput
        ).run();

        assertEquals(FakeOutput.expectedMessages(), fakeOutput.actualMessages());
    }
}
