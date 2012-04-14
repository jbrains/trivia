#!/bin/bash

for s in `seq 1 10`; do
  java -cp . com.adaptionsoft.games.trivia.runner.GameRunner > res$s
done
