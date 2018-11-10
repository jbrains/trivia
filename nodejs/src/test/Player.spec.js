const {assert} = require('chai')
const sinon = require('sinon')
const Player = require('./../Player.js')

describe('Player.js', () => {
  let player, logger

  beforeEach(() => {
    logger = sinon.stub()
    player = new Player({
      name: 'Iain Banks',
      places: 12,
      log: logger,
      coinsToWin: 3
    })
  })

  it('updatePlace', () => {
    assert.equal(player.place, 0)
    player.updatePlace(11)
    assert.equal(player.place, 11)
    player.updatePlace(2)
    assert.equal(player.place, 1)
    player.moveToPenalty()
    assert.throws(() => player.updatePlace(2))
    assert.throws(() => player.updatePlace(2))
  })

  it('hasWonGame', () => {
    while (player.purse < 3) {
      assert.isFalse(player.hasWonGame())
      player.winReward()
    }

    assert.isTrue(player.hasWonGame())
    player.winReward()
    assert.isTrue(player.hasWonGame())
  })

  it('winReward', () => {
    assert.equal(player.purse, 0)
    player.winReward()
    assert.equal(player.purse, 1)
    player.winReward()
    assert.equal(player.purse, 2)
  })

  it('moveToPenalty', () => {
    assert.isFalse(player.isInPenalty())
    player.moveToPenalty()
    assert.isTrue(player.isInPenalty())
    assert.throws(() => player.moveToPenalty())
  })

  it('moveToOutOfPenalty', () => {
    assert.isFalse(player.isInPenalty())
    player.moveToPenalty()
    assert.isTrue(player.isInPenalty())
    player.moveToOutOfPenalty()
    assert.isFalse(player.isInPenalty())
    assert.throws(() => player.moveToOutOfPenalty())
  })

  it('roll', () => {
    assert.equal(player.place, 0)
    assert.isFalse(player.isInPenalty())
    player.roll(2)
    assert.equal(player.place, 2)
    assert.isFalse(player.isInPenalty())

    player.moveToPenalty()
    player.roll(2)
    assert.equal(player.place, 2)
    assert.isTrue(player.isInPenalty())
    player.roll(3)
    assert.equal(player.place, 5)
    assert.isFalse(player.isInPenalty())
  })

})