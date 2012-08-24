#import "LCRGame.h"

@implementation LCRGame{
    NSMutableArray * players;
    int places[6];
    int purses[6];
    BOOL inPenaltyBox[6];
    
    NSMutableArray *popQuestions;
    NSMutableArray *scienceQuestions;
    NSMutableArray *sportsQuestions;
    NSMutableArray *rockQuestions;

    int currentPlayer;
    BOOL isGettingOutOfPenaltyBox;
}

- (id)init
{
    self = [super init];
    if (self) {
        players = [NSMutableArray new];
        
        popQuestions = [[NSMutableArray alloc] init];
        scienceQuestions = [[NSMutableArray alloc] init];
        sportsQuestions = [[NSMutableArray alloc] init];
        rockQuestions = [[NSMutableArray alloc] init];
        
        currentPlayer = 0;
        isGettingOutOfPenaltyBox = NO;
        
        for (int i = 0; i < 50; i++) {
			[popQuestions addObject:[NSString stringWithFormat:@"Pop Question %d", i]];
            [scienceQuestions addObject:[NSString stringWithFormat:@"Science Question %d", i]];
            [sportsQuestions addObject:[NSString stringWithFormat:@"Sports Question %d", i]];
			[rockQuestions addObject:[self createRockQuestionWithIndex:i]];
    	}

    }
    return self;
}

-(NSMutableString *) createRockQuestionWithIndex:(int) anIndex
{
    return [NSString stringWithFormat:@"Rock Question %d",anIndex ];
}

-(BOOL)isPlayable
{
    return [self howManyPlayers] >= 2;
}

-(BOOL)addPlayerNamed:(NSString *)aPlayerName
{
    [players addObject:aPlayerName];
    places[[self howManyPlayers]] = 0;
    purses[[self howManyPlayers]] = 0;
    inPenaltyBox[[self howManyPlayers]] = NO;
    
    NSLog(@"%@ was added", aPlayerName);
    NSLog(@"They are player number %li", [players count]);

    return YES;
}
    	
-(int)howManyPlayers
{
    return (int)[players count];
}

-(void)roll:(int)aRoll
{
    NSLog(@"%@ is the current player", [players objectAtIndex:currentPlayer]);
    NSLog(@"They have rolled a %d", aRoll);
    
    if (inPenaltyBox[currentPlayer]){
        if (aRoll % 2 !=0){
            isGettingOutOfPenaltyBox = YES;
            
            NSLog(@"%@ is getting out of the pentaly box", [players objectAtIndex:currentPlayer]);
            places[currentPlayer] = places[currentPlayer] + aRoll;
            if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;
            
            NSLog(@"%@'s new location is %d", [players objectAtIndex:currentPlayer], places[currentPlayer]);
            NSLog(@"The category is %@", [self currentCategory]);
            
            [self askQuestion];
        } else {
            NSLog(@"%@ is not getting out of the penalty box", [players objectAtIndex:currentPlayer]);
            isGettingOutOfPenaltyBox = NO;
        }
    } else {
        places[currentPlayer] = places[currentPlayer] + aRoll;
        if (places[currentPlayer] > 11) places[currentPlayer] = places[currentPlayer] - 12;
        
        NSLog(@"%@'s new location is %d", [players objectAtIndex:currentPlayer], places[currentPlayer]);
        NSLog(@"The category is %@", [self currentCategory]);
        
        [self askQuestion];
    }
}

-(void)askQuestion
{
    if ([self currentCategory] == @"Pop"){
        NSLog(@"%@",[popQuestions objectAtIndex:0]); [popQuestions removeObjectAtIndex:0];
    }
    if ([self currentCategory] == @"Science"){
        NSLog(@"%@",[scienceQuestions objectAtIndex:0]); [scienceQuestions removeObjectAtIndex:0];
    }
    if ([self currentCategory] == @"Sports"){
        NSLog(@"%@",[sportsQuestions objectAtIndex:0]); [sportsQuestions removeObjectAtIndex:0];
    }
    if ([self currentCategory] == @"Rock"){
        NSLog(@"%@",[rockQuestions objectAtIndex:0]); [rockQuestions removeObjectAtIndex:0];
    }
}	
	
-(NSString *)currentCategory
{
    if (places[currentPlayer] == 0) return @"Pop";
    if (places[currentPlayer] == 4) return @"Pop";
    if (places[currentPlayer] == 8) return @"Pop";
    if (places[currentPlayer] == 1) return @"Science";
    if (places[currentPlayer] == 5) return @"Science";
    if (places[currentPlayer] == 9) return @"Science";
    if (places[currentPlayer] == 2) return @"Sports";
    if (places[currentPlayer] == 6) return @"Sports";
    if (places[currentPlayer] == 10) return @"Sports";
    return @"Rock";
}

-(BOOL)wasCorrectlyAnswered
{
    if (inPenaltyBox[currentPlayer]){
        if (isGettingOutOfPenaltyBox) {
            NSLog(@"Answer was correct!!!!");
            purses[currentPlayer]++;
            NSLog(@"%@ now has %d Gold Coins.",
                  [players objectAtIndex:currentPlayer], purses[currentPlayer]);
            
            BOOL winner = [self didPlayerWin];
            currentPlayer++;
            if(currentPlayer == [players count]) currentPlayer = 0;
            
            return winner;
        } else {
            currentPlayer++;
            if(currentPlayer == [players count]) currentPlayer = 0;
            return YES;
        }

    
    
    } else {
        
        NSLog(@"Answer was corrent!!!!");
        purses[currentPlayer]++;
        NSLog(@"%@ now has %d Gold Coins.",
              [players objectAtIndex:currentPlayer], purses[currentPlayer]);
        
        BOOL winner = [self didPlayerWin];
        currentPlayer++;
        if(currentPlayer == [players count]) currentPlayer = 0;
        return winner;
    }
}
    
-(BOOL)wrongAnswer
{
    NSLog(@"Question was incorrectly answered");
    NSLog(@"%@ was sent to the penalty box", [players objectAtIndex:currentPlayer]);
    inPenaltyBox[currentPlayer] = YES;
    
    currentPlayer++;
    if(currentPlayer == [players count]) currentPlayer = 0;
    return YES;
}
	    
-(BOOL)didPlayerWin
{
    return !(purses[currentPlayer] == 6);
}

@end

