<?php

use PHPUnit\Framework\TestCase;

include_once __DIR__.'/GameRunner.php';

class FakeOutput {
    private $messages = array();
    
    function write($message) {
        array_push($this->messages, $message);
    }
    
    function actualMessages() {
        return implode("\n", $this->messages);
    }
    
    static function expectedMessages() {
        return trim(file_get_contents(__DIR__ . '/../reference/result.txt'));
    }
}

class FakeFileInput {
    private $diceSequence = array();
    private $responseSequence = array();
    
    function __construct() {
        $content = file_get_contents(__DIR__ . '/../reference/randomSeq.txt');
        $lines = explode("\n", $content);
        
        $this->responseSequence = $this->parseCommaSeparatedInts($lines[1]);
        $this->diceSequence = $this->parseCommaSeparatedInts($lines[4]);
    }
    
    private function parseCommaSeparatedInts($line) {
        $numbers = explode(',', $line);
        $result = array();
        foreach ($numbers as $num) {
            $trimmed = trim($num);
            if ($trimmed !== '') {
                array_push($result, intval($trimmed));
            }
        }
        return $result;
    }
    
    function die() {
        return array_shift($this->diceSequence);
    }
    
    function responseIsCorrect() {
        $nextResponse = array_shift($this->responseSequence);
        return $nextResponse != 7;
    }
}

class GameTest extends TestCase {
    
    public function testShouldReproduceReferenceOutput() {
        $fakeOutput = new FakeOutput();
        
        $runner = new GameRunner(new FakeFileInput(), $fakeOutput);
        $runner->run();
        
        $actual = $fakeOutput->actualMessages();
        $expected = FakeOutput::expectedMessages();
        
        $this->assertEquals($expected, $actual);
    }
}