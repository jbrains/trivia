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

# describe "add player" do
#   it "should return hashmap" do
#     expect(true).to eq(true)
#   end
# end