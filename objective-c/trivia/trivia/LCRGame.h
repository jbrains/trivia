@interface LCRGame : NSObject

-(void)roll:(int)aRoll;
-(BOOL)wasCorrectlyAnswered;
-(BOOL)wrongAnswer;
-(BOOL)addPlayerNamed:(NSString *)aPlayerName;

@end
