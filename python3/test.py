import trivia
import unittest

import random
random.seed(1337)

class Snapshot():
    @staticmethod
    def get():
        snapshot = Snapshot.read("snapshot.md")
        test_snapshot = Snapshot.read("test_snapshot.md")
        return snapshot, test_snapshot

    @staticmethod
    def write(data, filename = "snapshot.md"):
        with open(filename, "w") as file:
            file.write(data)

    @staticmethod
    def read(filename = "snapshot.md"):
        with open(filename) as f:
            return f.read()


# py trivia.py > test_snapshot.md && py test.py
# test_snapshot = Snapshot.read("test_snapshot.md")

class Test(unittest.TestCase):
    def test_original_snapshot_matched_by_test_snapshot(self):
        expected, actual = Snapshot.get()
        self.assertEqual(expected, actual)

if __name__ == '__main__':
    unittest.main()
