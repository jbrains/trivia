<?php

include_once __DIR__.'/Game.php';
include_once __DIR__.'/RandomInput.php';

class GameRunner {
    private $input;
    private $output;
    
    function __construct($input, $output) {
        $this->input = $input;
        $this->output = $output;
    }
    
    function run() {
        $notAWinner;
        
        $aGame = new Game($this->output);
        
        $aGame->add("Chet");
        $aGame->add("Pat");
        $aGame->add("Sue");
        
        do {
            $aGame->roll($this->input->die());
            
            if (!$this->input->responseIsCorrect()) {
                $notAWinner = $aGame->wrongAnswer();
            } else {
                $notAWinner = $aGame->wasCorrectlyAnswered();
            }
        } while ($notAWinner);
    }
    
    static function main() {
        $runner = new GameRunner(new RandomInput(), new ConsoleOutput());
        $runner->run();
    }
}

if (basename(__FILE__) == basename($_SERVER['SCRIPT_FILENAME'])) {
    GameRunner::main();
}
  
