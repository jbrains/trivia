var aGame = require('./game'),
    notAWinner;

aGame.add('Chet');
aGame.add('Pat');
aGame.add('Sue');

do
{

    aGame.roll(randomizer(5) + 1);

    if (randomizer(9) == 7) {
        notAWinner = aGame.wrongAnswer();
    }
    else {
        notAWinner = aGame.wasCorrectlyAnswered();
    }

} while (notAWinner);

function randomizer(seed) {
    var randomNumber = Math.random() * seed;
    return Math.ceil(randomNumber);    
}