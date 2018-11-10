const { assert } = require('chai')
const sinon = require('sinon')
const Game = require('./../Game.js')
const Player = require('./../Player.js')

describe('Game.js', () => {
  let player, logger, game

  beforeEach(() => {
    logger = sinon.stub()
    game = new Game({
      places: 12,
      questionCount: 3,
      coinsToWin: 3,
      places: 5,
      log: logger,
    })
    player = sinon.createStubInstance(Player)
    player.place = 0
    player.isInPenalty.returns(false)
    player.hasWonGame.returns(false)
    sinon.stub(game, 'getCurrentPlayer').returns(player)
    game.add('Asimov')
    game.add('Clarke')
  })

  it('changeCurrentPlayer', () => {
    assert.equal(game.currentPlayer, 0)
    game.changeCurrentPlayer()
    assert.equal(game.currentPlayer, 1)
    game.changeCurrentPlayer()
    assert.equal(game.currentPlayer, 0)
  })

  it('getPlayerCount', () => {
    assert.equal(game.getPlayerCount(), 2)
    game.add('Stephenson')
    game.add('Dick')
    assert.equal(game.getPlayerCount(), 4)
  })

  it('isPlayable', () => {
    assert.isTrue(game.isPlayable())
    game = new Game({
      log: logger
    })
    assert.isFalse(game.isPlayable())
    game.add('Stephenson')
    assert.isFalse(game.isPlayable())
    game.add('Dick')
    assert.isTrue(game.isPlayable())
    game.add('Gibson')
    assert.isTrue(game.isPlayable())
  })

  it('askQuestion', () => {
    const callCount = logger.callCount
    assert.doesNotThrow(() => game.askQuestion())
    sinon.assert.callCount(logger, callCount + 2)
    assert.doesNotThrow(() => game.askQuestion())
    assert.doesNotThrow(() => game.askQuestion())
    sinon.assert.callCount(logger, callCount + 6)
    assert.throws(() => game.askQuestion())
    assert.throws(() => game.askQuestion())
  })

  describe('roll', () => {

    it('When Game has no players', () => {
      const emptyGame = new Game({})
      assert.throws(() => emptyGame.roll())
    })

    it('When player is in penalty', () => {
      player.isInPenalty.returns(true)
      sinon.stub(game, 'askQuestion')
      assert.isFalse(game.roll(42, true))
      sinon.assert.notCalled(game.askQuestion)
      assert.isFalse(game.roll(42, false))
      sinon.assert.notCalled(game.askQuestion)
    })

    it('When player can answer question', () => {
      sinon.stub(game, 'askQuestion')
      assert.isFalse(game.roll(42, true))

      sinon.assert.calledOnce(game.askQuestion)
      sinon.assert.calledOnce(player.winReward)
      assert.isFalse(game.roll(42, false))
      sinon.assert.calledTwice(game.askQuestion)
      sinon.assert.calledOnce(player.moveToPenalty)
    })

    it('When a player has won the game', () => {
      player.hasWonGame.returns(true)
      assert.isTrue(game.roll(42, false))
    })
  })
})