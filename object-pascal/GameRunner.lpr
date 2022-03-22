{$mode objfpc}{$H+}{$J-} // Just use this line in all modern sources

program Trivia;

uses
  SysUtils,
  Game;

var 
  aGame : TGame;
  notAWinner : boolean;
  roll : Integer;
  
begin
   Randomize;
   aGame := TGame.Create();

   aGame.add('Chet');
   aGame.add('Pat');
   aGame.add('Sue');

   repeat
      begin
         roll := Random(32767) mod 5 + 1;
         aGame.roll(roll);

         if (Random(32767) mod 9) = 7 then
            notAWinner := aGame.wrongAnswer()
         else
            notAWinner := aGame.wasCorrectlyAnswered();
      end;
   until notAWinner = false;

end.

