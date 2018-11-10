'use strict'


/**
 * Player state classes
 *
 */
const PLAYER_STATES = {
  /**
   * Player moves the given number of steps
   *
   * @param {int} roll number of steps to move
   * @returns {undefined}
   */
  FREE: {
    roll: function(roll) {
      this.updatePlace(roll)
    },
  },
  /**
   * Player moves out of penalty box and the given number of steps if roll value is odd, else they are struck in the box
   *
   * @param {int} roll number of steps to move
   * @returns {undefined}
   */
  IN_PENALTY: {
    roll: function (roll) {
      if (roll % 2) {
        this.moveToOutOfPenalty()
        this.updatePlace(roll)
      } else {
        this.log(`${this.name} is not getting out of the penalty box`)
      }
    },
  }
}


/**
 * Player class
 *
 */
class Player {
  constructor({ 
    name, 
    places, 
    log, 
    coinsToWin,
    place=0, 
    purse=0, 
  }) {
    this.name = name
    this.place = place
    this.purse = purse
    this.coinsToWin = coinsToWin
    this.state = PLAYER_STATES.FREE
    this.places = places
    this.log = log
  }


  /**
   * Updates the players location
   *
   * @param {int} value number of steps to move
   * @returns {undefined}
   */
  updatePlace(value) {
    this.place = (this.place + value) % this.places
    this.log(`${this.name}'s new location is ${this.place}`)
  }

  /**
   * Has the given player won the game
   *
   * @returns {boolean}
   */
  hasWonGame() {
    const hasPlayerWon = this.purse >= this.coinsToWin
    if (hasPlayerWon) this.log(`${this.name} has won the game`)
    return hasPlayerWon
  }

  /**
   * Reward player a gold coin
   *
   * @returns {undefined}
   */
  winReward() {
    this.purse++
    this.log(`${this.name} now has ${this.purse} Gold coins.`)
  }

  /**
   * Move player to the penalty
   *
   * @returns {undefined}
   */
  moveToPenalty() {
    if (this.state === PLAYER_STATES.IN_PENALTY)
      throw new Error('Already in Penaly')

    this.log(`${this.name} was sent to the penalty box`)
    this.state = PLAYER_STATES.IN_PENALTY
  }

  /**
   * Player rolls the dice and acts upon it based on his state
   *
   * @param {int} roll number of steps to move
   * @returns {undefined}
   */
  roll(roll) {
    this.state.roll.call(this, roll)
  }

  /**
   * Check if player is in penalty
   *
   * @returns {boolean}
   */
  isInPenalty() {
    return this.state === PLAYER_STATES.IN_PENALTY
  }

  /**
   * Move player out of penalty
   *
   * @returns {undefined}
   */
  moveToOutOfPenalty() {
    if (this.state !== PLAYER_STATES.IN_PENALTY)
      throw new Error('Player is already free')

    this.log(`${this.name} is getting out of the penalty box`)
    this.state = PLAYER_STATES.FREE
  }
}

module.exports = Player
