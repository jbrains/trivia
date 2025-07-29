#!/usr/bin/env python3

import os
import unittest
from trivia import GameRunner


class FakeOutput:
    def __init__(self):
        self.messages = []

    def write(self, message: str) -> None:
        self.messages.append(message)

    def actual_messages(self) -> str:
        return '\n'.join(self.messages) + '\n'

    @staticmethod
    def expected_messages() -> str:
        with open(os.path.join(os.path.dirname(__file__), '..', 'reference', 'result.txt'), 'r') as f:
            return f.read()


class FakeFileInput:
    def __init__(self):
        reference_path = os.path.join(os.path.dirname(__file__), '..', 'reference', 'randomSeq.txt')
        with open(reference_path, 'r') as f:
            lines = f.readlines()

        self.responses = self.parse_line(lines[1])
        self.dice_rolls = self.parse_line(lines[4])

    def parse_line(self, line):
        return [int(x) for x in line.strip().split(',') if x.strip().isdigit()]

    def die(self) -> int:
        return self.dice_rolls.pop(0)

    def response_is_correct(self) -> bool:
        return self.responses.pop(0) != 7



class TestTrivia(unittest.TestCase):
    
    def test_should_reproduce_reference_output(self):
        fake_output = FakeOutput()
        
        GameRunner(
            FakeFileInput(),
            fake_output
        ).run()
        
        self.assertEqual(fake_output.actual_messages(), FakeOutput.expected_messages())


if __name__ == '__main__':
    unittest.main()