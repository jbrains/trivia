'use strict'


const PLAYER_STATES = {
  FREE: {
    roll: function(roll) {
      this.updatePlace(roll)
    },
  },
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

  updatePlace(value) {
    this.place = (this.place + value) % this.places
    this.log(`${this.name}'s new location is ${this.place}`)
  }

  hasWonGame() {
    return this.purse >= this.coinsToWin
  }

  winReward() {
    this.purse++
    this.log(`${this.name} now has ${this.purse} Gold coins.`)
  }

  moveToPenalty() {
    if (this.state === PLAYER_STATES.IN_PENALTY)
      throw new Error('Already in Penaly')

    this.log(`${this.name} was sent to the penalty box`)
    this.state = PLAYER_STATES.IN_PENALTY
  }

  roll(roll) {
    this.state.roll.call(this, roll)
  }

  isInPenalty() {
    return this.state === PLAYER_STATES.IN_PENALTY
  }

  moveToOutOfPenalty() {
    if (this.state !== PLAYER_STATES.IN_PENALTY)
      throw new Error('Player is already free')

    this.log(`${this.name} is getting out of the penalty box`)
    this.state = PLAYER_STATES.FREE
  }
}

module.exports = Player
