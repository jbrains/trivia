<?php

function echoln($string) {
    echo $string."\n";
}

class ConsoleOutput {
    function write($message) {
        echoln($message);
    }
}