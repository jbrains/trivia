require 'spec_helper'
require 'approvals/rspec'
require 'ugly_trivia/game'

describe "spec test" do
  it "should pass" do
    expect(true).to eq(true)
  end
end

describe "golden master test" do
  it "should record and verify golden master" do
  	play(1040)
  	verify :format => :txt do
  		"text"
  	end
  end
end

def play(seed)

	puts "seed: #{seed}"
	srand(seed)
	puts rand(seed)
	for i in 1..10
		puts rand i
	end

	# not_a_winner = false

	# game = UglyTrivia::Game.new
	# game.add 'Chet'
	# game.add 'Pat'
	# game.add 'Sue'

	# begin
	  
	#   game.roll(rand(5) + 1)
	  
	#   if rand(9) == 7
	#     not_a_winner = game.wrong_answer
	#   else
	#     not_a_winner = game.was_correctly_answered
	#   end
	  
	# end while not_a_winner
end