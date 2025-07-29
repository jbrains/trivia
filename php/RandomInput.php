<?php

class RandomInput {
    function die() {
        return rand(1, 6);
    }
    
    function responseIsCorrect() {
        return rand(0, 9) != 7;
    }
}