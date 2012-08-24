#include "LCRGame.h"

int main(int argc, const char * argv[])
{
    srand ( (int)time(NULL) );
    
    @autoreleasepool {
        BOOL notAWinner;
        
        LCRGame *aGame = [[LCRGame alloc] init];
        
        [aGame addPlayerNamed:@"Chet"];
        [aGame addPlayerNamed:@"Pat"];
        [aGame addPlayerNamed:@"Sue"];
        
		do {
            
            [aGame roll:(rand() % 5) + 1];
            
			if ((rand() % 9) == 7) {
				notAWinner = [aGame wrongAnswer];
			} else {
				notAWinner = [aGame wasCorrectlyAnswered];
			}
            
            
		} while (notAWinner);
        
    }
    return 0;
}

