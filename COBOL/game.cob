       IDENTIFICATION DIVISION.
       PROGRAM-ID. GAME.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
      *>
       WORKING-STORAGE SECTION.
      *>
       01 WS-MISC.

         05 DID-PLAYER-WIN        PIC X.

         05 PLAYERS               PIC X(10) OCCURS 100.
         05 PLACES 		  PIC 9(2) OCCURS 6.
         05 PURSES                PIC 9(2) OCCURS 6.

         05 IN-PENALTY-BOX        PIC X OCCURS 6.
	    88 IN-PENALTY-BOX-YES VALUE 'Y'.
	    88 IN-PENALTY-BOX-NO  VALUE 'N'.

         05 POP-QUESTION          PIC X(30) OCCURS 50.
         05 POP-QUESTION-IDX      PIC 9(2) VALUE 0.

         05 SCIENCE-QUESTION      PIC X(30) OCCURS 50.
         05 SCIENCE-QUESTION-IDX  PIC 9(2) VALUE 0.

         05 SPORTS-QUESTION       PIC X(30) OCCURS 50.
         05 SPORTS-QUESTION-IDX   PIC 9(2) VALUE 0.

         05 ROCK-QUESTION         PIC X(30) OCCURS 50.
         05 ROCK-QUESTION-IDX     PIC 9(2) VALUE 0.

         05 CURRENT-PLAYER        PIC 9.
         05 PLAYER-COUNT          PIC 9 VALUE 0.

         05 GETTING-OUT-OF-PENALTY-BOX PIC X.
            88 GETTING-OUT-OF-PENALTY-BOX-YES VALUE 'Y'.
            88 GETTING-OUT-OF-PENALTY-BOX-NO VALUE 'N'.

         05 IDX                   PIC 9(2) VALUE 0.

         05 IS-PLAYABLE           PIC X.
            88 IS-PLAYABLE-YES    VALUE 'Y'.
            88 IS-PLAYABLE-NO     VALUE 'N'.

         05 PLAYER-TO-ADD         PIC X(10).

         05 ROLL                  PIC 9.

         05 ANSWER                PIC 9.

         05 CURRENT-CATEGORY             PIC X(10).
            88 CURRENT-CATEGORY-POP      VALUE 'Pop'.
            88 CURRENT-CATEGORY-SCIENCE  VALUE 'Science'.
            88 CURRENT-CATEGORY-SPORTS   VALUE 'Sports'.
            88 CURRENT-CATEGORY-ROCK     VALUE 'Rock'.

         05 NOT-A-WINNER          PIC X.

         05 NOTHING PIC 9.
         05 RANDOM-RESULT PIC S9V9(10).
          
         05 CUR-DATE. 
            10 FILLER                PIC X(14).
            10 SEED                  PIC 9(2).

       PROCEDURE DIVISION.
      *>
       MAIN SECTION.
            PERFORM INITIALIZATION
            MOVE 'Chet' TO PLAYER-TO-ADD
            PERFORM A1000-ADD-PLAYER
            MOVE 'Pat' TO PLAYER-TO-ADD
            PERFORM A1000-ADD-PLAYER
            MOVE 'Sue' TO PLAYER-TO-ADD
            PERFORM A1000-ADD-PLAYER
            MOVE 1 TO CURRENT-PLAYER

            PERFORM UNTIL NOT-A-WINNER = 'F'
              COMPUTE ROLL = FUNCTION RANDOM() * 5 + 1
              PERFORM A2000-ROLL
              COMPUTE ANSWER = FUNCTION RANDOM() * 9 + 1
              DISPLAY 'Answer: ' ANSWER
              IF (ANSWER = 7) THEN
                PERFORM A5000-WRONG-ANSWER
              ELSE
                PERFORM A4000-WAS-CORRECTLY-ANSWERED
              END-IF
              MOVE DID-PLAYER-WIN TO NOT-A-WINNER

            END-PERFORM
            DISPLAY 'Game over'
            GOBACK.

       INITIALIZATION SECTION.
            
            PERFORM
            VARYING IDX
            FROM 1 BY 1
            UNTIL IDX > 50
              STRING 'Pop Question ' DELIMITED SIZE
              IDX DELIMITED SIZE
              INTO POP-QUESTION(IDX)
              STRING 'Science Question ' DELIMITED SIZE
              IDX DELIMITED SIZE
              INTO SCIENCE-QUESTION(IDX)
              STRING 'Sports Question ' DELIMITED SIZE
              IDX DELIMITED SIZE
              INTO SPORTS-QUESTION(IDX)
              PERFORM I1000-CREATE-ROCK-QUESTION
            END-PERFORM      
            PERFORM R0000-GET-RANDOM-NUMBER      
            .

        I1000-CREATE-ROCK-QUESTION SECTION.
            STRING 'Rock Question ' DELIMITED SIZE
            IDX DELIMITED SIZE
            INTO ROCK-QUESTION(IDX)
            .

      * TODO, this should return a boolean?       
        A1000-ADD-PLAYER SECTION.
            ADD 1 TO PLAYER-COUNT
            MOVE PLAYER-TO-ADD TO PLAYERS(PLAYER-COUNT)
            MOVE 0 TO PLACES(PLAYER-COUNT)
            MOVE 0 TO PURSES(PLAYER-COUNT)
            SET IN-PENALTY-BOX-NO(PLAYER-COUNT) TO TRUE
            DISPLAY 'Player ' PLAYER-TO-ADD ' was added'
            DISPLAY 'They are player number ' PLAYER-COUNT
            .
        A2000-ROLL SECTION.
            DISPLAY PLAYERS(CURRENT-PLAYER) ' is the current player'
            DISPLAY 'They have rolled a ' ROLL
            IF IN-PENALTY-BOX-YES(CURRENT-PLAYER) THEN
              IF (FUNCTION MOD(ROLL,2) NOT = 0) THEN
                SET GETTING-OUT-OF-PENALTY-BOX-YES TO TRUE
                DISPLAY PLAYERS(CURRENT-PLAYER) 
                ' is getting out of the penalty box'
                COMPUTE PLACES(CURRENT-PLAYER) = 
                PLACES(CURRENT-PLAYER) + ROLL
                IF (PLACES(CURRENT-PLAYER) > 11) THEN 
                   COMPUTE PLACES(CURRENT-PLAYER) = 
                   PLACES(CURRENT-PLAYER) - 12
                END-IF
                DISPLAY PLAYERS(CURRENT-PLAYER) "'s new location is "
                PLACES(CURRENT-PLAYER)
                PERFORM Q2000-GET-CATEGORY
                DISPLAY 'The category is ' CURRENT-CATEGORY
                PERFORM A3000-ASK-QUESTION
              ELSE
                DISPLAY PLAYERS(CURRENT-PLAYER) 
                ' is not getting out of the penalty box'
                SET GETTING-OUT-OF-PENALTY-BOX-NO TO TRUE 
              END-IF
            ELSE
              COMPUTE PLACES(CURRENT-PLAYER) = 
              PLACES(CURRENT-PLAYER) + ROLL
              IF (PLACES(CURRENT-PLAYER) > 11) THEN 
                 COMPUTE PLACES(CURRENT-PLAYER) = 
                 PLACES(CURRENT-PLAYER) - 12
              END-IF
              DISPLAY PLAYERS(CURRENT-PLAYER) " new location is "
              PLACES(CURRENT-PLAYER)
              PERFORM Q2000-GET-CATEGORY
              DISPLAY 'The category is ' CURRENT-CATEGORY
              PERFORM A3000-ASK-QUESTION
            END-IF
            .
        A3000-ASK-QUESTION SECTION.
            PERFORM Q2000-GET-CATEGORY
            IF (CURRENT-CATEGORY-POP) THEN
              ADD 1 TO POP-QUESTION-IDX
              DISPLAY POP-QUESTION(POP-QUESTION-IDX)
            END-IF
            IF (CURRENT-CATEGORY-SCIENCE) THEN
              ADD 1 TO SCIENCE-QUESTION-IDX
              DISPLAY SCIENCE-QUESTION(SCIENCE-QUESTION-IDX)
            END-IF
            IF (CURRENT-CATEGORY-SPORTS) THEN
              ADD 1 TO SPORTS-QUESTION-IDX
              DISPLAY SPORTS-QUESTION(SPORTS-QUESTION-IDX)
            END-IF
            IF (CURRENT-CATEGORY-ROCK) THEN
              ADD 1 TO ROCK-QUESTION-IDX
              DISPLAY ROCK-QUESTION(ROCK-QUESTION-IDX)
            END-IF
            .
        A4000-WAS-CORRECTLY-ANSWERED SECTION.
            IF (IN-PENALTY-BOX-YES(CURRENT-PLAYER)) THEN
              IF (GETTING-OUT-OF-PENALTY-BOX-YES) THEN
                 DISPLAY 'Answer was correct!!!!'
                 ADD 1 TO PURSES(CURRENT-PLAYER)
                 DISPLAY PLAYERS(CURRENT-PLAYER) ' now has '
                 PURSES(CURRENT-PLAYER) ' Gold Coins.'
                 PERFORM Q3000-DID-PLAYER-WIN
                 ADD 1 TO CURRENT-PLAYER
                 IF (CURRENT-PLAYER = PLAYER-COUNT) THEN
                   MOVE 1 TO CURRENT-PLAYER
                 END-IF 
              ELSE
                ADD 1 TO CURRENT-PLAYER
                IF (CURRENT-PLAYER = PLAYER-COUNT) THEN
                 MOVE 1 TO CURRENT-PLAYER
                END-IF 
              END-IF
            ELSE
              DISPLAY 'Answer was corrent!!!!'
              ADD 1 TO PURSES(CURRENT-PLAYER)
              DISPLAY PLAYERS(CURRENT-PLAYER) ' now has '
              PURSES(CURRENT-PLAYER) ' Gold Coins.'
              PERFORM Q3000-DID-PLAYER-WIN
              ADD 1 TO CURRENT-PLAYER
              IF (CURRENT-PLAYER = PLAYER-COUNT) THEN
                MOVE 1 TO CURRENT-PLAYER
              END-IF               
            END-IF
            .
        A5000-WRONG-ANSWER SECTION.
            DISPLAY 'Question was incorrectly answered'
            DISPLAY PLAYERS(CURRENT-PLAYER) 
            ' was sent to the penalty box'
            SET IN-PENALTY-BOX-YES(CURRENT-PLAYER) TO TRUE
            MOVE '1' TO DID-PLAYER-WIN
            ADD 1 TO CURRENT-PLAYER
            IF (CURRENT-PLAYER = PLAYER-COUNT) THEN
               MOVE 1 TO CURRENT-PLAYER
            END-IF 
            .
        Q1000-CHECK-IS-PLAYABLE SECTION.
            IF (PLAYER-COUNT >= 2) THEN
              SET IS-PLAYABLE-YES TO TRUE
            ELSE
              SET IS-PLAYABLE-NO TO TRUE
            END-IF
            .
        Q2000-GET-CATEGORY SECTION.
            IF (PLACES(CURRENT-PLAYER) = 0) THEN 
              SET CURRENT-CATEGORY-POP TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 4) THEN
              SET CURRENT-CATEGORY-POP TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 8) THEN
              SET CURRENT-CATEGORY-POP TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 1) THEN
              SET CURRENT-CATEGORY-SCIENCE TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 5) THEN
              SET CURRENT-CATEGORY-SCIENCE TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 9) THEN
              SET CURRENT-CATEGORY-SCIENCE TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 2) THEN
              SET CURRENT-CATEGORY-SPORTS TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 6) THEN
              SET CURRENT-CATEGORY-SCIENCE TO TRUE
            ELSE IF (PLACES(CURRENT-PLAYER) = 10) THEN
              SET CURRENT-CATEGORY-SCIENCE TO TRUE
            ELSE
              SET CURRENT-CATEGORY-ROCK TO TRUE
            END-IF
            END-IF
            END-IF
            END-IF
            END-IF
            END-IF
            END-IF
            END-IF
            END-IF
            .            
        Q3000-DID-PLAYER-WIN SECTION.
            IF NOT (PURSES(CURRENT-PLAYER) = 6)
               MOVE 'T' TO DID-PLAYER-WIN
            ELSE
               MOVE 'F' TO DID-PLAYER-WIN
            END-IF
            .
 
        R0000-GET-RANDOM-NUMBER SECTION.
            MOVE FUNCTION CURRENT-DATE TO CUR-DATE
            COMPUTE RANDOM-RESULT = FUNCTION RANDOM(SEED)
            .











