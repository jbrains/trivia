(ns trivia.Game)

(def players (atom []))
(def places (atom [0] ))
(def purses (atom [0]))
(def inPenaltyBox (atom [false]))
(def popQuestions (atom []))
(def scienceQuestions (atom []))
(def sportsQuestions (atom []))
(def rockQuestions (atom []))
(def currentPlayer (atom 0))
(def isGettingOutOfPenaltyBox (atom false))

(defn createRockQuestion [index] (str "Rock Question " index))

(defn initialize []
  (dotimes [i 50]
    (swap! popQuestions conj (str "Pop Question " i))
    (swap! scienceQuestions conj (str "Science Question " i))
    (swap! sportsQuestions conj (str "Sports Question " i))
    (swap! rockQuestions conj (createRockQuestion i))))

(initialize)

(defn howManyPlayers [] (count @players))

(defn isPlayable [] (>= (howManyPlayers) 2))

(defn add [playerName]
  (swap! players conj playerName)
  (swap! places assoc (howManyPlayers) 0)
  (swap! purses assoc (howManyPlayers) 0)
  (swap! inPenaltyBox assoc (howManyPlayers) false)
  (println playerName "was added")
  (println "They are player number " (count @players)))

(defn currentCategory []
  (cond (= (nth @places @currentPlayer) 0) "Pop"
        (= (nth @places @currentPlayer) 4) "Pop"
        (= (nth @places @currentPlayer) 8) "Pop"
        (= (nth @places @currentPlayer) 1) "Science"
        (= (nth @places @currentPlayer) 5) "Science"
        (= (nth @places @currentPlayer) 9) "Science"
        (= (nth @places @currentPlayer) 2) "Sports"
        (= (nth @places @currentPlayer) 6) "Sports"
        (= (nth @places @currentPlayer) 10) "Sports"
        :else "Rock"))

(defn askQuestion []
  (cond (= (currentCategory) "Pop") (do (println (first @popQuestions)) (swap! popQuestions #(drop 1 %)))
        (= (currentCategory) "Science") (do (println (first @scienceQuestions)) (swap! scienceQuestions #(drop 1 %)))
        (= (currentCategory) "Sports") (do (println (first @sportsQuestions)) (swap! sportsQuestions #(drop 1 %)))
        (= (currentCategory) "Rock") (do (println (first @rockQuestions)) (swap! rockQuestions #(drop 1 %)))))

(defn roll [roll]
  (println (nth @players @currentPlayer) "is the current player")
  (println "They have rolled a" roll)
  (if (nth @inPenaltyBox @currentPlayer)
    (if (not= 0 (mod roll 2))
      (do (reset! isGettingOutOfPenaltyBox true)
          (println (nth @players @currentPlayer) "is getting out of the penalty box")
          (swap! places assoc @currentPlayer (+ (@places @currentPlayer) roll))
          (if (> (nth @places @currentPlayer) 11)
            (swap! places assoc @currentPlayer (- (nth @places @currentPlayer) 12)))
          (println (str (nth @players @currentPlayer) "'s new location is") (nth @places @currentPlayer))
          (println "The category is" (currentCategory))
          (askQuestion))
      (do (println (nth @players @currentPlayer) "is not getting out of the penalty box")
          (reset! isGettingOutOfPenaltyBox false)))
    (do (swap! places assoc @currentPlayer (+ (@places @currentPlayer) roll))
        (if (> (nth @places @currentPlayer) 11)
          (swap! places assoc @currentPlayer (- (nth @places @currentPlayer) 12)))
        (println (str (nth @players @currentPlayer) "'s new location is") (nth @places @currentPlayer))
        (println "The category is" (currentCategory))
        (askQuestion))))

(defn didPlayerWin []
  (not (= (nth @purses @currentPlayer) 6)))

(defn wasCorrectlyAnswered []
  (if (nth @inPenaltyBox @currentPlayer)
    (if @isGettingOutOfPenaltyBox
      (do (println "Answer was correct!!!!")
          (swap! purses assoc @currentPlayer (inc (nth @purses @currentPlayer)))
          (println (nth @players @currentPlayer) "now has" (nth @purses @currentPlayer) "Gold Coins.")
          (let [winner (didPlayerWin)]
            (swap! currentPlayer inc)
            (if (= @currentPlayer (count @players)) (reset! currentPlayer 0))
            winner))
      (do (swap! currentPlayer inc)
          (if (= @currentPlayer (count @players)) (reset! currentPlayer 0))
          true))
    (do (println "Answer was corrent!!!!")
        (swap! purses assoc @currentPlayer (inc (nth @purses @currentPlayer)))
        (println (nth @players @currentPlayer) "now has" (nth @purses @currentPlayer) "Gold Coins.")
          (let [winner (didPlayerWin)]
            (swap! currentPlayer inc)
            (if (= @currentPlayer (count @players)) (reset! currentPlayer 0))
            winner))))

(defn wrongAnswer []
  (println "Question was incorrectly answered")
  (println (nth @players @currentPlayer) "was sent to the penalty box")
  (swap! inPenaltyBox assoc @currentPlayer true)
  (swap! currentPlayer inc)
  (if (= @currentPlayer (count @players)) (reset! currentPlayer 0))
  true)
