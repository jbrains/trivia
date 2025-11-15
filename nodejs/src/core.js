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

module.exports = {
  Category,
  Question,
};
