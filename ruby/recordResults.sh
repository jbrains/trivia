#!/bin/bash

for s in `seq 1 10`; do
  ./bin/trivia >res$s
done
