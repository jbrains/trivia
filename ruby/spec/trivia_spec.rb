require 'spec_helper'
require 'trivia/game'

describe "player" do
	it "should have name, position, purse and freedom_status" do
		@player = Trivia::Player.new("Merlin")
		expect(@player.name).to eq("Merlin")
		expect(@player.board_position).to be(0)
		expect(@player.gold_coins).to be(0)
		expect(@player.in_penalty_box).to be(false)
	end
end

describe "game" do
	it "should register exactly 4 players with numbers" do
		@game = Trivia::Game.new('One','Two','Three', 'Four')
		expect(@game.game_players.length).to be(4)
		expect(@game.game_players["0"]).to be(nil)
		expect(@game.game_players["1"]).to be_a_kind_of(Trivia::Player)
		expect(@game.game_players["2"]).to be_a_kind_of(Trivia::Player)
		expect(@game.game_players["3"]).to be_a_kind_of(Trivia::Player)
		expect(@game.game_players["4"]).to be_a_kind_of(Trivia::Player)
		expect(@game.game_players["5"]).to be(nil)
	end

	it "should create start set of questions" do
		game = Trivia::Game.new('One')
		question_pool = game.initialize_questions
		expect(question_pool.length).to be(4)
		expect(question_pool.keys).to eq([:Pop,:Science,:Sports,:Rock])
		expect(question_pool.values).to eq([0,0,0,0])
	end

	it "should create message containing question with number and category" do
		game = Trivia::Game.new('One')
		question_pool = game.initialize_questions
		expect(game.create_question_message(:Pop)).to eq("Pop Question 0")
		expect(game.create_question_message(:Science)).to eq("Science Question 0")
		expect(game.create_question_message(:Sports)).to eq("Sports Question 0")
		expect(game.create_question_message(:Rock)).to eq("Rock Question 0")
	end

end