class RandomInput {
  die() {
    return Math.floor(Math.random() * 6) + 1;
  }

  responseIsCorrect() {
    return Math.floor(Math.random() * 10) !== 7;
  }
}

module.exports = RandomInput;