module UglyTrivia
  class StringIOBasedGameCommentator
    def initialize
      @commentary = StringIO.new
    end

    def commentary
      @commentary.string.split("\n")
    end

    def die_rolled(roll, trivia_player)
      display "#{trivia_player.name} is the current player"
      display "They have rolled a #{roll}"
    end

    def moved(trivia_player)
      display "#{trivia_player.name}'s new location is #{trivia_player.location}"
    end

    def answer_was_correct
      display "Answer was correct!!!!"
    end

    def question_answered_incorrectly
      display 'Question was incorrectly answered'
    end

    def sent_to_penalty_box(trivia_player)
      display "#{trivia_player.name} was sent to the penalty box"
    end

    def gold_coin_awarded_to(trivia_player)
      display "#{trivia_player.name} now has #{trivia_player.gold_coins} Gold Coins."
    end

    def display(message)
      puts message
    end

    def puts(message)
      @commentary.puts(message)
    end
  end
end
