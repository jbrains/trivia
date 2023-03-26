(ns trivia.Gamerunner
  (:require [trivia.Game :refer :all])
  (:gen-class))

(defn -main
  [& args]
  (add "Chet")
  (add "Pat")
  (add "Sue")
  
  (loop [notAWinner true]
    (if notAWinner
      (do
        (roll (inc (int (rand 5))))
        (if (= (int (rand 9)) 7)
          (recur (wrongAnswer))
          (recur (wasCorrectlyAnswered)))))))
