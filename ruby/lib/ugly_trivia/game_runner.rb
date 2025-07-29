require_relative 'game'
require_relative 'input'
require_relative 'output'

module UglyTrivia
  class GameRunner
    def initialize(input = RandomInput.new, output = ConsoleOutput.new)
      @input = input
      @output = output
    end

    def run
      not_a_winner = false

      game = Game.new(@output)

      game.add 'Chet'
      game.add 'Pat'
      game.add 'Sue'

      begin
        game.roll(@input.die)

        if @input.response_correct?
          not_a_winner = game.was_correctly_answered
        else
          not_a_winner = game.wrong_answer
        end

      end while not_a_winner
    end

    def self.main
      new.run
    end
  end
end