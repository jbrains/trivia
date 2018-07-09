require_relative 'game_params'
require 'logger'

module Trivia

# ToDo ideas 
    # - questions: counter + question message creator, rather than array with message
    # - rename: "Answer was corrent!!!!" --> correct, needs update of golden master though

  class Player
    attr_reader :name
    attr_accessor :board_position, :gold_coins, :in_penalty_box
    def initialize(name)
      @name = name
      @board_position = GameParams::GAME_START_POSITION
      @gold_coins = GameParams::GAME_START_MONEY
      @in_penalty_box = GameParams::GAME_START_IN_PENALTY_BOX
    end
  end

  class Question
    attr_reader :category
    attr_accessor :count
    def initialize(category)
      @category = category.to_sym
      @count = GameParams::GAME_START_QUESTION_NUMBER
    end
  end

  class Game

    File.delete("logfile.log") if File.exist?("logfile.log")
    @@logger = Logger.new('logfile.log')

    include GameParams
    attr_reader :game_players

    def initialize(*gamers)
      @game_players = Hash.new
      gamers.each do |player_name|
        add_player(player_name)
      end
      
      @question_pool = initialize_questions

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
        @pop_questions.push "Pop #{GameParams::QUESTION_TEXT} #{i}"
        @science_questions.push "Science #{GameParams::QUESTION_TEXT} #{i}"
        @sports_questions.push "Sports #{GameParams::QUESTION_TEXT} #{i}"
        @rock_questions.push create_rock_question(i)
      end
    end

    def initialize_questions
      {
        CATEGORY_POP.to_sym => GameParams::GAME_START_QUESTION_NUMBER,
        CATEGORY_SCIENCE.to_sym => GameParams::GAME_START_QUESTION_NUMBER,
        CATEGORY_SPORTS.to_sym => GameParams::GAME_START_QUESTION_NUMBER,
        CATEGORY_ROCK.to_sym => GameParams::GAME_START_QUESTION_NUMBER
      }
    end

    def question_message(category)
      "#{category} #{GameParams::QUESTION_TEXT} #{@question_pool[category.to_sym]}"
    end

    def increment_question_count(category)
      count = @question_pool[category.to_sym].to_i
      count +1
    end

    def add_player(name)
      current_players_number = @game_players.length+1
      @game_players[current_players_number.to_s] = Player.new(name)
    end

    def create_rock_question(index)
      "Rock Question #{index}"
    end

    def print_added_player_message(player_name)
      puts "#{player_name} was added"
      puts "They are player number #{@players.length}"
    end

    def add_and_log_player(player_name)
      @players.push player_name
      @places[number_of_players] = 0
      @purses[number_of_players] = 0
      @in_penalty_box[number_of_players] = false

      print_added_player_message(player_name)

      true
    end

    def number_of_players
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
      # puts question_message(current_category)
      # @question_pool[current_category.to_sym] = increased_question_count(current_category)
      puts @pop_questions.shift if current_category == CATEGORY_POP
      puts @science_questions.shift if current_category == CATEGORY_SCIENCE
      puts @sports_questions.shift if current_category == CATEGORY_SPORTS
      puts @rock_questions.shift if current_category == CATEGORY_ROCK
    end

    def current_category
      POSITIONS[@places[@current_player].to_s]
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
