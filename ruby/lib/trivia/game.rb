module UglyTrivia
  class Game

  CATEGORY_POP = "Pop"
  CATEGORY_SCIENCE = "Science"
  CATEGORY_SPORTS = "Sports"
  CATEGORY_ROCK = "Rock"

  POP_POSITIONS = [0,4,8]
  SCIENCE_POSITIONS = [1,5,9]
  SPORTS_POSITIONS = [2,6,10]
  ROCK_POSITIONS = [3,7,11]

    def  initialize
      @positions = {
        "0" => CATEGORY_POP,
        "1" => CATEGORY_SCIENCE,
        "2" => CATEGORY_SPORTS, 
        "3" => CATEGORY_ROCK,
        "4" => CATEGORY_POP,
        "5" => CATEGORY_SCIENCE,
        "6" => CATEGORY_SPORTS,
        "7" => CATEGORY_ROCK,
        "8" => CATEGORY_POP,
        "9" => CATEGORY_SCIENCE,
        "10" => CATEGORY_SPORTS,
        "11" => CATEGORY_ROCK
      }

      @players = []
      @places = Array.new(6, 0)
      @purses = Array.new(6, 0)
      @in_penalty_box = Array.new(6, nil)

      @pop_questions = []
      @science_questions = []
      @sports_questions = []
      @rock_questions = []

      @current_player = 0
      @is_getting_out_of_penalty_box = false

      50.times do |i|
        @pop_questions.push "Pop Question #{i}"
        @science_questions.push "Science Question #{i}"
        @sports_questions.push "Sports Question #{i}"
        @rock_questions.push create_rock_question(i)
      end
    end

    def create_rock_question(index)
      "Rock Question #{index}"
    end

    def is_playable?
      how_many_players >= 2
    end

    def create_player_message(player_name)
      "#{player_name} was added"      
    end

    def print_player_message(message)
      puts message
    end

    def add_and_log_player(player_name)
      @players.push player_name
      @places[how_many_players] = 0
      @purses[how_many_players] = 0
      @in_penalty_box[how_many_players] = false

      print_player_message(create_player_message(player_name))
      # puts "#{player_name} was added"
      puts "They are player number #{@players.length}"

      true
    end

    def how_many_players
      @players.length
    end

    def roll(roll)
      puts "#{@players[@current_player]} is the current player"
      puts "They have rolled a #{roll}"

      if @in_penalty_box[@current_player]
        if roll % 2 != 0
          @is_getting_out_of_penalty_box = true

          puts "#{@players[@current_player]} is getting out of the penalty box"
          @places[@current_player] = @places[@current_player] + roll
          @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11

          puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
          puts "The category is #{current_category}"
          ask_question
        else
          puts "#{@players[@current_player]} is not getting out of the penalty box"
          @is_getting_out_of_penalty_box = false
          end

      else

        @places[@current_player] = @places[@current_player] + roll
        @places[@current_player] = @places[@current_player] - 12 if @places[@current_player] > 11

        puts "#{@players[@current_player]}'s new location is #{@places[@current_player]}"
        puts "The category is #{current_category}"
        ask_question
      end
    end

  private

    def ask_question
      puts @pop_questions.shift if current_category == CATEGORY_POP
      puts @science_questions.shift if current_category == CATEGORY_SCIENCE
      puts @sports_questions.shift if current_category == CATEGORY_SPORTS
      puts @rock_questions.shift if current_category == CATEGORY_ROCK
    end

    def current_category
      @positions[@places[@current_player].to_s]
    end

  public

    def was_correctly_answered
      if @in_penalty_box[@current_player]
        if @is_getting_out_of_penalty_box
          puts 'Answer was correct!!!!'
          @purses[@current_player] += 1
          puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

          winner = did_player_win()
          @current_player += 1
          @current_player = 0 if @current_player == @players.length

          winner
        else
          @current_player += 1
          @current_player = 0 if @current_player == @players.length
          true
        end



      else

        puts "Answer was corrent!!!!"
        @purses[@current_player] += 1
        puts "#{@players[@current_player]} now has #{@purses[@current_player]} Gold Coins."

        winner = did_player_win
        @current_player += 1
        @current_player = 0 if @current_player == @players.length

        return winner
      end
    end

    def wrong_answer
  		puts 'Question was incorrectly answered'
  		puts "#{@players[@current_player]} was sent to the penalty box"
  		@in_penalty_box[@current_player] = true

      @current_player += 1
      @current_player = 0 if @current_player == @players.length
  		return true
    end

  private

    def did_player_win
      !(@purses[@current_player] == 6)
    end
  end
end
