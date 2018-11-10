'use strict'

const Player = require('./Player.js')
const QUESTIONS_COUNT = 50
const PLACE_COUNT = 12
const COINS_TO_WIN = 6
const CATEGORIES = [
  'Pop',
  'Science',
  'Sports',
  'Rock',
]
const DEFAULT_LOGGER = console.log.bind(console)

/**
 * Game class
 *
 */
class Game {
  constructor({
    log = DEFAULT_LOGGER,
    questionCount = QUESTIONS_COUNT,
    coinsToWin = COINS_TO_WIN,
    places = PLACE_COUNT
  }) {
    this.questionCount = questionCount
    this.places = places
    this.coinsToWin = coinsToWin
    this.players = []
    this.currentPlayer = 0
    this.questions = {}
    this.log = log

    if (places % CATEGORIES.length !== 0) 
      this.log('Warning: Questions from some categories would be asked more often than others')

    CATEGORIES.forEach((category) => {
      const emptyArray = new Array(QUESTIONS_COUNT)
      const getQuestion = (ignored, index) => `${category} Question ${index}`
      this.questions[category] = Array.from(emptyArray, getQuestion)
    })
  }

  /**
   * Returns the current player item
   *
   * @returns {Player}
   */
  getCurrentPlayer() {
    return this.players[this.currentPlayer]
  }

  /**
   * Changes current player to the next player in the list
   *
   * @returns {undefined}
   */
  changeCurrentPlayer() {
    this.currentPlayer = (this.currentPlayer + 1) % this.getPlayerCount()
  }

  /**
   * Returns question category for given player
   *
   * @returns {String}
   */
  getCurrentCategory() {
    const place = this.getCurrentPlayer().place % CATEGORIES.length
    return CATEGORIES[place]
  }

  /**
   * Returns number of players in the game
   *
   * @returns {int}
   */
  getPlayerCount() {
    return this.players.length
  }

  /**
   * Can the game be started
   *
   * @returns {boolean}
   */
  isPlayable() {
    return this.getPlayerCount() > 1
  }

  /**
   * Add a player to the game
   *
   * @param {string} name Player name
   * @returns {undefined}
   */
  add(name) {
    const player = new Player({ 
      name, 
      log: this.log, 
      places: this.places,
      coinsToWin: this.coinsToWin,
    })
    this.players.push(player)

    this.log(`${player.name} was added`)
    this.log(`There are ${this.getPlayerCount()} players`)
  }

  /**
   * Ask a question
   *
   * @returns {undefined}
   */
  askQuestion() {
    const category = this.getCurrentCategory()
    const questions = this.questions[category]

    if (!questions.length) 
      throw new Error('Out of questions')

    this.log(`The category is ${category}`)
    this.log(questions.shift())
  }

  /**
   * Player rolls given and value and answers a question if they are not in penalty
   *
   * @param {int} roll Player dice roll value
   * @param {boolean} correctAnswer Did player answer the question correctly
   * @returns {boolean} Has a player won the game
   */
  roll(roll, correctAnswer) {

    if (!this.isPlayable()) 
      throw new Error(`Not enough players to start the game`)

    const player = this.getCurrentPlayer()
    this.log(`${player.name} is the current player`)
    this.log(`They have rolled a ${roll}`)

    player.roll(roll)

    if (!player.isInPenalty()) {
      this.askQuestion()
      if (correctAnswer) {
        this.log('Answer was correct!!!!')
        player.winReward()
      } else {
        this.log('Question was incorrectly answered')
        player.moveToPenalty()
      }
    }
    
    this.changeCurrentPlayer()
    return player.hasWonGame()
  }
}

module.exports = Game
