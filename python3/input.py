from random import randrange

class RandomInput:
    def die(self) -> int:
        return randrange(6) + 1

    def response_is_correct(self) -> bool:
        return randrange(10) != 7
