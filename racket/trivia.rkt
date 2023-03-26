#lang racket

(require data/queue)

(define players null)
(define places null)
(define purses null)
(define in-penalty-box? null)

(define pop-questions null)
(define science-questions null)
(define sports-questions null)
(define rock-questions null)

(define current-player null)
(define is-getting-out-of-penalty-box? null)

(define (reset-all)
  (set! players empty)
  (set! places (make-vector 6))
  (set! purses (make-vector 6))
  (set! in-penalty-box? (make-vector 6))

  (set! pop-questions (make-queue))
  (set! science-questions (make-queue))
  (set! sports-questions (make-queue))
  (set! rock-questions (make-queue))

  (set! current-player 0)
  (set! is-getting-out-of-penalty-box? #f)

  (for ([i (in-range 50)])
    (enqueue! pop-questions (~a "Pop Question " i))
    (enqueue! science-questions (~a "Science Question " i))
    (enqueue! sports-questions (~a "Sports Question " i))
    (enqueue! rock-questions (create-rock-question i))))

(define (create-rock-question i)
  (~a "Rock Question " i))

(reset-all)

(define (playable?)
  (>= how-many-players 2))

(define (print . args)
  (define s (apply ~a args))
  (displayln s))

(define (add player-name)
  (vector-set! places (how-many-players) 0)
  (vector-set! purses (how-many-players) 0)
  (vector-set! in-penalty-box? (how-many-players) #f)
  (set! players (append players (list player-name)))

  (print player-name " was added")
  (print "They are player number " (length players)))

(define (how-many-players)
  (length players))

(define (roll roll)
  (print (list-ref players current-player) " is the current player")
  (print "They have rolled a " roll)

  (if (vector-ref in-penalty-box? current-player)
      (cond [(odd? roll)
             (set! is-getting-out-of-penalty-box? #t)
            
             (print (list-ref players current-player)
                    " is getting out of the penalty box")
             (vector-set! places current-player
                          (+ roll (vector-ref places current-player)))
             (when (> (vector-ref places current-player) 11)
               (vector-set! places current-player
                            (- (vector-ref places current-player) 12)))

             (print (list-ref players current-player)
                    "'s new location is "
                    (vector-ref places current-player))
             (print "The category is " (current-category))
             (ask-question)]
            [else
             (print (list-ref players current-player)
                    " is not getting out of the penalty box")
             (set! is-getting-out-of-penalty-box? #f)])
      (begin
        (vector-set! places current-player
                     (+ roll (vector-ref places current-player)))
        (when (> (vector-ref places current-player) 11)
          (vector-set! places current-player
                       (- (vector-ref places current-player) 12)))
        
        (print (list-ref players current-player)
               "'s new location is "
               (vector-ref places current-player))
        (print "The category is " (current-category))
        (ask-question))))

(define (ask-question)
  (cond [(equal? (current-category) "Pop")
         (print (dequeue! pop-questions))]
        [(equal? (current-category) "Science")
         (print (dequeue! science-questions))]
        [(equal? (current-category) "Sports")
         (print (dequeue! sports-questions))]
        [(equal? (current-category) "Rock")
         (print (dequeue! rock-questions))]))

(define (current-category)
  (cond [(= (vector-ref places current-player) 0) "Pop"]
        [(= (vector-ref places current-player) 4) "Pop"]
        [(= (vector-ref places current-player) 8) "Pop"]
        [(= (vector-ref places current-player) 1) "Science"]
        [(= (vector-ref places current-player) 5) "Science"]
        [(= (vector-ref places current-player) 9) "Science"]
        [(= (vector-ref places current-player) 2) "Sports"]
        [(= (vector-ref places current-player) 6) "Sports"]
        [(= (vector-ref places current-player) 10) "Sports"]
        [else "Rock"]))

(define (was-correctly-answered?)
  (define winner null)
  (if (vector-ref in-penalty-box? current-player)
      (cond [is-getting-out-of-penalty-box?
             (print "Answer was correct!!!!")
             (vector-set! purses current-player (+ 1 (vector-ref purses current-player)))
             (print (list-ref players current-player) " now has "
                    (vector-ref purses current-player) " Gold Coins.")

             (set! winner (did-player-win?))
             (set! current-player (+ current-player 1))
             (when (= current-player (length players))
               (set! current-player 0))
             winner]
            [else (set! current-player (+ current-player 1))
                  (when (= current-player (length players))
                    (set! current-player 0))
                  #t])
      (begin
        (print "Answer was corrent!!!!")
        (vector-set! purses current-player (+ 1 (vector-ref purses current-player)))
        (print (list-ref players current-player) " now has "
               (vector-ref purses current-player) " Gold Coins.")

        (set! winner (did-player-win?))
        (set! current-player (+ current-player 1))
        (when (= current-player (length players))
          (set! current-player 0))
        winner)))
        

(define (wrong-answer)
  (print "Question was incorrectly answered")
  (print  (list-ref players current-player) " was sent to the penalty box")
  (vector-set! in-penalty-box? current-player #t)

  (set! current-player (+ current-player 1))
  (when (= current-player (length players))
    (set! current-player 0))
  #t)

(define (did-player-win?)
  (not (= (vector-ref purses current-player) 6)))                 


; GAME LOOP

(define (play-game . players)
  (reset-all)

  (for ([p players])
    (add p))
  (define not-a-winner #f)

  (let G ()
    (roll (+ (random 6) 1))
    (set! not-a-winner
          (if (= (random 10) 7)
              (wrong-answer)
              (was-correctly-answered?)))

    (when not-a-winner
      (G))))


(play-game "Chet" "Pat" "Sue")
