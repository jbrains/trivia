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
  		old_stdout = $stdout
  		File.open('spec/fixtures/approvals/golden_master_test/runtime_output.txt', 'w') do |fo|
	  		$stdout = fo
	  		for i in 1..6
			  	play(26469*i)
			  	puts('**************************')
			  	puts('==========================')
			  	puts('**************************')
			  	puts('==========================')
				end
			end
			
			file = File.open($stdout)
			text_to_verify = ""
			file.each {|line|
			  text_to_verify << line
			}

			$stdout = old_stdout
  	verify :format => :txt do
  		text_to_verify
  	end
  end
end


def print_seed(seed)
	puts "seed: #{seed}"
	srand(seed)
	puts rand(seed)
	for i in 1..10
		puts rand i
	end
end


def play(seed)

	# print_seed(seed)

	not_a_winner = false

	game = UglyTrivia::Game.new
	game.add 'Chet'
	game.add 'Pat'
	game.add 'Sue'

	begin
	  game.roll(rand(5) + 1)
	  
	  if rand(9) == 7
	    not_a_winner = game.wrong_answer
	  else
	    not_a_winner = game.was_correctly_answered
	  end
	  
	end while not_a_winner

end