{$mode objfpc}{$H+}{$J-}
unit Game;

interface
uses SysUtils, Classes;

type
   
  TGame         = class
   private
   places       : array[0..5] of integer;
   purses       : array[0..5] of integer;
   inPenaltyBox : array[0..5] of boolean;

   currentPlayer : longword;
   isGettingOutOfPenaltyBox : boolean;
   players : TStringList;
   popQuestions : TStringList;
   scienceQuestions : TStringList;
   sportsQuestions : TStringList;
   rockQuestions : TStringList;
   
   public
     constructor Create;
     function createRockQuestion(const index: integer): string;
     function isPlayable() : boolean;
     function add(const name: string): boolean;
     function howManyPlayers(): integer;
     procedure roll(const value: integer);

  private
     procedure askQuestion();
     function currentCategory(): string;

  public
     function wrongAnswer(): boolean;
     function wasCorrectlyAnswered(): boolean;

   private
     function didPlayerWin(): boolean;
  end;

implementation
   constructor TGame.Create;
   var
      i : integer;
      pop, science, sports : string;
      s : string;
   begin
      players := TStringList.Create();
      popQuestions := TStringList.Create();
      sportsQuestions := TStringList.Create();
      scienceQuestions := TStringList.Create();
      rockQuestions := TStringList.Create();
      
      pop := 'Pop Question ';
      science := 'Science Question ';
      sports := 'Sports Question ';
      
      for i := 0 to 49 do
      begin
         s := pop;
         AppendStr(s, IntToStr(i));
         popQuestions.Add(s);
         
         s := science;
         AppendStr(s, IntToStr(i));
         scienceQuestions.Add(s);
         
         s := sports;
         AppendStr(s, IntToStr(i));
         sportsQuestions.Add(s);
         
         rockQuestions.Add(createRockQuestion(i));
      end;
             
      currentPlayer := 0;
   end;

   function TGame.createRockQuestion(const index: integer): string;
   var
      s : string;
   begin
      s := 'Rock Question ';
      AppendStr(s, IntToStr(index));
      Result := s;
   end;

   function TGame.isPlayable() : boolean;
   begin
      Result := (howManyPlayers() >= 2);
   end;
   
   function TGame.add(const name: string): boolean;
   begin
      players.Add(name);
      places[howManyPlayers()] := 0;
      purses[howManyPlayers()] := 0;
      inPenaltyBox[howManyPlayers()] := false;

      WriteLn(name, ' was added');
      WriteLn('They are player number ', players.Count);
      
      Result := true;
   end;

   function TGame.howManyPlayers() : integer;
   begin
      Result := players.Count;
   end;

   procedure TGame.roll(const value: Integer);
   begin
      WriteLn(players[currentPlayer], ' is the current player');
      WriteLn('They have rolled a ', value);

      if inPenaltyBox[currentPlayer] then
      begin
         if value mod 2 <> 0 then
           begin
             isGettingOutOfPenaltyBox := true;

             WriteLn(players[currentPlayer], ' is getting out of the penalty box');
             places[currentPlayer] := places[currentPlayer] + value;
             if places[currentPlayer] > 11 then
               places[currentPlayer] := places[currentPlayer] - 12;

             WriteLn(players[currentPlayer], 's new location is ', places[currentPlayer]);
             WriteLn('The category is ', currentCategory());
             askQuestion();
           end
         else
           begin
              WriteLn(players[currentPlayer], ' is not getting out of the penalty box');
              isGettingOutOfPenaltyBox := false;
           end;
         end
  else
    begin
       places[currentPlayer] := places[currentPlayer] + value;
       if places[currentPlayer] > 11 then
          places[currentPlayer] := places[currentPlayer] - 12;

       WriteLn(players[currentPlayer], 's new location is ', places[currentPlayer]);
       WriteLn('The category is ', currentCategory());
       askQuestion();
    end;
  
  end;

   procedure TGame.askQuestion();
   begin
      if (currentCategory() = 'Pop') then
      begin
         WriteLn(popQuestions[0]);
         popQuestions.Delete(0);
      end;

      if (currentCategory() = 'Science') then
      begin
         WriteLn(scienceQuestions[0]);
         scienceQuestions.Delete(0);
      end;

      if (currentCategory() = 'Sports') then
      begin
         WriteLn(sportsQuestions[0]);
         sportsQuestions.Delete(0);
      end;

      if (currentCategory() = 'Rock') then
      begin
         WriteLn(rockQuestions[0]);
         rockQuestions.Delete(0);
      end;
   end;

   function TGame.currentCategory(): string;
   begin
      Result := 'Rock';
      
      if places[currentPlayer] = 0 then Result := 'Pop';
      if places[currentPlayer] = 4 then Result := 'Pop';
      if places[currentPlayer] = 8 then Result := 'Pop';

      if places[currentPlayer] = 1 then Result := 'Science';
      if places[currentPlayer] = 5 then Result := 'Science';
      if places[currentPlayer] = 9 then Result := 'Science';

      if places[currentPlayer] = 2 then Result := 'Sports';
      if places[currentPlayer] = 6 then Result := 'Sports';
      if places[currentPlayer] = 10 then Result := 'Sports';
   end;

   function TGame.wasCorrectlyAnswered(): boolean;
   var
      winner : boolean;
   begin
      if inPenaltyBox[currentPlayer] then
        begin
           if isGettingOutOfPenaltyBox then
             begin
                WriteLn('Answer was correct!!!!');
                purses[currentPlayer] := purses[currentPlayer] + 1;
                WriteLn(players[currentPlayer], ' now has ', purses[currentPlayer], ' Gold Coins.');
                winner := didPlayerWin();
                currentPlayer := currentPlayer + 1;
                if currentPlayer = players.Count then
                   currentPlayer := 0;
                Result := winner
             end
           else
             begin
               currentPlayer := currentPlayer + 1;
               if currentPlayer = players.Count then
                 currentPlayer := 0;
               Result := true;
             end;
        end
      else
      begin
         WriteLn('Answer was corrent!!!!');
         purses[currentPlayer] := purses[currentPlayer] + 1;
         WriteLn(players[currentPlayer], ' now has ', purses[currentPlayer], ' Gold Coins.');
         winner := didPlayerWin();
         currentPlayer := currentPlayer + 1;
         if currentPlayer = players.Count then
            currentPlayer := 0;

         Result := winner;
      end; 
   end;
   
   function TGame.wrongAnswer(): boolean;
   begin
      WriteLn('Question was incrrectly answered');
      WriteLn(players[currentPlayer], ' was sent to the penalty box');
      inPenaltyBox[currentPlayer] := true;
      currentPlayer := currentPlayer + 1;
      if (currentPlayer = players.Count) then
         currentPlayer := 0;
      
      Result := true;
   end;


   function TGame.didPlayerWin(): boolean;
   begin
     Result := not (purses[currentPlayer] = 6);
   end;
end.      
