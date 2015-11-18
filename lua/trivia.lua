local Game = {}
Game.__index = Game
function Game:new()
	local instance = {}
	setmetatable(instance, Game)

	instance.players = {}
	instance.places = {0, 0, 0, 0, 0, 0}
	instance.purses = {0, 0, 0, 0, 0, 0}
	instance.in_penalty_box = {0, 0, 0, 0, 0, 0}

	instance.questions = {
		pop = {},
		rock = {},
		science = {},
		sports = {}
	}
	instance.current_player = 1
	instance.is_getting_out_of_penalty_box = false

	for i = 1, 51 do
		for key, value in pairs(instance.questions) do
			value[i] = instance:create_question(key, i)
		end
   end

   return instance
end

function Game:create_question(name, index)
   return ("%s Question %d"):format(name, index)
end

function Game:is_playable()
   return self:how_many_players() - 1 >= 2
end

function Game:add(name)
   table.insert(self.players, name)
   self.places[self:how_many_players()] = 0
   self.purses[self:how_many_players()] = 0
   self.in_penalty_box[self:how_many_players()] = false

   print(name.." was added")
   print("They are player number "..tostring(#self.players))

   return true
end

function Game:how_many_players()
   return #self.players
end

function Game:roll(roll)
   print(self.players[self.current_player].." is the current player")
   print("They have rolled a "..tostring(roll))

   if self.in_penalty_box[self.current_player] then
      if roll % 2 ~= 0 then
         self.is_getting_out_of_penalty_box = true
         print(self.players[self.current_player].." is getting out of the penalty box")
         self.places[self.current_player] = self.places[self.current_player] + roll
         if self.places[self.current_player] > 11 then
            self.places[self.current_player] = self.places[self.current_player] - 12
         end

         print(self.players[self.current_player].."'s new location is "..tostring(self.places[self.current_player]))
         print("The category is "..self:current_category())
         self:ask_question()
      else
         print(self.players[self.current_player].." is not getting out of the penalty box")
         self.is_getting_out_of_penalty_box = false
      end
   else
      self.places[self.current_player] = self.places[self.current_player] + roll
      if self.places[self.current_player] > 11 then
         self.places[self.current_player] = self.places[self.current_player] - 12
      end
      print(self.players[self.current_player].."'s new location is "..tostring(self.places[self.current_player]))
      print("The category is "..self:current_category())
      self:ask_question()
   end
end

function Game:ask_question()
	local category = self:current_category()
	print( table.remove(self.questions[category:lower()],1) )
end

Game.current_category = (function()
	local lookup = {
		"Pop",
		"Science",
		"Sports",
		"Rock"
	}
	return function(self)
		return lookup[(self.current_player % 4) + 1]
	end
end)()

function Game:was_correctly_answered()
   if self.in_penalty_box[self.current_player] then
      if self.is_getting_out_of_penalty_box then
         print('Answer was correct!!!!')
         self.purses[self.current_player] = self.purses[self.current_player] + 1
         print (self.players[self.current_player]..' now has '..tostring(self.purses[self.current_player])..' Gold Coins.')

         winner = self:did_player_win()
         self.current_player = self.current_player + 1
         if self.current_player == #(self.players) + 1 then self.current_player = 1 end

         return winner
      else
         self.current_player = self.current_player + 1
         if self.current_player == #(self.players) + 1 then self.current_player = 1 end
         return true
      end
   else
      print('Answer was corrent!!!!')
      self.purses[self.current_player] = self.purses[self.current_player] + 1
      print (self.players[self.current_player]..' now has '..tostring(self.purses[self.current_player])..' Gold Coins.')

      winner = self:did_player_win()
      self.current_player = self.current_player + 1
      if self.current_player == #(self.players) + 1 then self.current_player = 1 end

      return winner
   end
end

function Game:wrong_answer()
   print('Question was incorrectly answered')
   print(self.players[self.current_player].." was sent to the penalty box")

   self.in_penalty_box[self.current_player] = true
   self.current_player = self.current_player + 1
   if self.current_player == #(self.players) + 1 then self.current_player = 1 end
   return true
end

function Game:did_player_win()
   return not (self.purses[self.current_player] == 6)
end

math.randomseed(os.time())

not_a_winner = false

game = Game.new()

game:add('Chet')
game:add('Pat')
game:add('Sue')

while true do
    game:roll(math.random(0,5) + 1)

    if math.random(0,9) == 7 then
       not_a_winner = game:wrong_answer()
    else
       not_a_winner = game:was_correctly_answered()
    end
    if not not_a_winner then break end
end

