#!/bin/bash
PLAYERS=()
PLACES=()
PURSES=()
INPENALTYBOX=()

POPQUESTIONS=()
SCIENCEQUESTIONS=()
SPORTSQUESTIONS=()
ROCKQUESTIONS=()

CURRENTPLAYER=0
CURRENTCATEGORY=
ISGETTINGOUTOFPENALTYBOX=
NOTAWINNER=1

for ((x=0; x < 50; x++)); do    
    POPQUESTIONS[$[${#POPQUESTIONS[@]}]]="Pop Question $x"
    SCIENCEQUESTIONS[$[${#SCIENCEQUESTIONS[@]}]]="Science Question $x"
    SPORTSQUESTIONS[$[${#SPORTSQUESTIONS[@]}]]="Sports Question $x"
    ROCKQUESTIONS[$[${#ROCKQUESTIONS[@]}]]="Rock Question $x"
done

function add {
    PLAYERS[$[${#PLAYERS[@]}]]=$1
    INPENALTYBOX[$[${#INPENALTYBOX[@]}]]=0
    PLACES[$[${#PLACES[@]}]]=0
    PURSES[$[${#PURSES[@]}]]=0
}

function isPlayable {
    if [ ${#PLAYERS[@]} -lt 2 ]; then
        return 0
    else
        return 1
    fi
}

function currentCategory {
    if [ ${PLACES[$CURRENTPLAYER]} -eq 0 ]; then
        CURRENTCATEGORY="Pop"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 4 ]; then
        CURRENTCATEGORY="Pop"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 8 ]; then
        CURRENTCATEGORY="Pop"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 1 ]; then
        CURRENTCATEGORY="Science"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 5 ]; then
        CURRENTCATEGORY="Science"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 9 ]; then
        CURRENTCATEGORY="Science"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 2 ]; then
        CURRENTCATEGORY="Sports"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 6 ]; then
        CURRENTCATEGORY="Sports"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 10 ]; then
        CURRENTCATEGORY="Sports"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 3 ]; then
        CURRENTCATEGORY="Rock"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -eq 7 ]; then
        CURRENTCATEGORY="Rock"
    fi
    if [ ${PLACES[$CURRENTPLAYER]} -gt 10 ]; then
        CURRENTCATEGORY="Rock"
    fi
}

function  askQuestion {
    if [ ${CURRENTCATEGORY} = "Pop" ]; then
        echo ${POPQUESTIONS[$((${#POPQUESTIONS[@]}-1))]}
        unset POPQUESTIONS[$((${#POPQUESTIONS[@]}-1))]
    fi
    if [ ${CURRENTCATEGORY} = "Science" ]; then
        echo ${SCIENCEQUESTIONS[$((${#SCIENCEQUESTIONS[@]}-1))]}
        unset SCIENCEQUESTIONS[$((${#SCIENCEQUESTIONS[@]}-1))]
    fi
    if [ ${CURRENTCATEGORY} = "Sports" ]; then
        echo ${SPORTSQUESTIONS[$((${#SPORTSQUESTIONS[@]}-1))]}
        unset SPORTSQUESTIONS[$((${#SPORTSQUESTIONS[@]}-1))]
    fi
    if [ ${CURRENTCATEGORY} = "Rock" ]; then
        echo ${ROCKQUESTIONS[$((${#ROCKQUESTIONS[@]}-1))]}
        unset ROCKQUESTIONS[$((${#ROCKQUESTIONS[@]}-1))]
    fi
}

function wrongAnswer {
    echo "Question was incorrectly answered" 
    echo "${PLAYERS[${CURRENTPLAYER}]} was sent to the penalty box" 
    INPENALTYBOX[${CURRENTPLAYER}]=1
    CURRENTPLAYER=$((${CURRENTPLAYER}+1))
    
    if [ ${CURRENTPLAYER} = ${#PLAYERS[@]} ]; then
        CURRENTPLAYER=0
    fi
}

function wasCorrectlyAnswered {
    if [ ${INPENALTYBOX[${CURRENTPLAYER}]} -eq 1 ]; then
        if [ $ISGETTINGOUTOFPENALTYBOX -eq 1 ]; then
            echo "Answer was correct!!"
            PURSES[${CURRENTPLAYER}]=$((${PURSES[${CURRENTPLAYER}]}+1))
            echo "${PLAYERS[${CURRENTPLAYER}]} now has ${PURSES[${CURRENTPLAYER}]} Gold Coins." 

            didPlayerWin
            NOTAWINNER=$?

            CURRENTPLAYER=$((${CURRENTPLAYER}+1))
            if [ ${CURRENTPLAYER} = ${#PLAYERS[@]} ]; then
                CURRENTPLAYER=0
            fi
        else
            CURRENTPLAYER=$((${CURRENTPLAYER}+1))
            if [ ${CURRENTPLAYER} = ${#PLAYERS[@]} ]; then
                CURRENTPLAYER=0
            fi
        fi
    else
        echo "Answer was corrent!!"
        PURSES[${CURRENTPLAYER}]=$((${PURSES[${CURRENTPLAYER}]}+1))
        echo "${PLAYERS[${CURRENTPLAYER}]} now has ${PURSES[${CURRENTPLAYER}]} Gold Coins." 

        didPlayerWin
        NOTAWINNER=$?

        CURRENTPLAYER=$((${CURRENTPLAYER}+1))
        if [ ${CURRENTPLAYER} = ${#PLAYERS[@]} ]; then
            CURRENTPLAYER=0
        fi
    fi
}

function didPlayerWin {
    if [ ${PURSES[${CURRENTPLAYER}]} -eq 6 ]; then
        return 0
    else
        return 1
    fi
}

function roll {
    echo "${PLAYERS[${CURRENTPLAYER}]} is the current player"
    echo "Player has rolled a $1"

    if [ ${INPENALTYBOX[$CURRENTPLAYER]} -ne 0 ]; then
        if [ $(($1 % 2)) -ne 0 ]; then
            ISGETTINGOUTOFPENALTYBOX=1
            echo "${PLAYERS[${CURRENTPLAYER}]} is getting out of the penalty box"
            PLACES[$CURRENTPLAYER]=$((${PLACES[$CURRENTPLAYER]}+$1))
            if [ ${PLACES[$CURRENTPLAYER]} -gt 11 ]; then
                PLACES[$CURRENTPLAYER]=$((${PLACES[$CURRENTPLAYER]}-12))
            fi
            echo "${PLAYERS[${CURRENTPLAYER}]}'s new location is ${PLACES[$CURRENTPLAYER]}"
            currentCategory
            echo "The category is ${CURRENTCATEGORY}"
            askQuestion
        else
            ISGETTINGOUTOFPENALTYBOX=0
            echo "${PLAYERS[${CURRENTPLAYER}]} is not getting out of the penalty box"
        fi
    else
        PLACES[$CURRENTPLAYER]=$((${PLACES[$CURRENTPLAYER]}+$1))
        if [ ${PLACES[$CURRENTPLAYER]} -gt 11 ]; then
            PLACES[$CURRENTPLAYER]=$((${PLACES[$CURRENTPLAYER]}-12))
        fi
        echo "${PLAYERS[${CURRENTPLAYER}]}'s new location is ${PLACES[$CURRENTPLAYER]}"
        currentCategory
        echo "The category is ${CURRENTCATEGORY}"
        askQuestion
    fi
}

####### runner ######

add "Chet"
add "Pat"
add "Sue"

while [ ${NOTAWINNER} -eq 1 ]; do
    roll $((RANDOM%6+1))
    
    if  [ $((RANDOM%9+1)) -eq 7 ]; then
        wrongAnswer
    else
        wasCorrectlyAnswered
    fi
done