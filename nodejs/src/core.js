const Category = Object.freeze({
  Pop: "Pop",
  Science: "Science",
  Sports: "Sports",
  Rock: "Rock",
});

class Question {
  constructor(category, id) {
    this.category = category;
    this.id = id;
  }

  toString() {
    return `${this.category} Question ${this.id}`;
  }
}

class QuestionsPool {
  #questions = new Map(
    [Category.Pop, []],
    [Category.Science, []],
    [Category.Sports, []],
    [Category.Rock, []]
  );

  addLast(category, id) {
    const question = new Question(category, id).toString();
    const pool = this.#questions.get(category) ?? [];
    this.#questions.set(category, [...pool, question]);
  }

  takeFirst(category) {
    const pool = this.#questions.get(category);
    return pool.shift();
  }
}

module.exports = {
  Category,
  Question,
  QuestionsPool,
};
