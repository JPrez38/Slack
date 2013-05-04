//
//  HighScoreLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HighScoreLayer.h"
#import "MainMenuLayer.h"


@implementation HighScoreLayer

static HighScoreLayer* sharedHighScoreLayer;
+(HighScoreLayer*) sharedHighScoreLayer
{
	if (sharedHighScoreLayer ==nil)
        [self scene];
	return sharedHighScoreLayer;
}

- (id) init {
    
    if ((self = [super init]))
    {
        sharedHighScoreLayer=self;
        // Global Variables
        maxScoresDisplayed = 6;
        
        // High Score Label
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"High Scores" fontName:@"Marker Felt" fontSize:32];
		CGSize size = [CCDirector sharedDirector].winSize;
		label.position = CGPointMake(size.width * 0.5, size.height * 0.9);
		[self addChild:label];
        
        // Get data from plist
        NSMutableArray *scores = [self readStoredScores];
        [self submitNameToHighScore:@"Abe Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        [self submitNameToHighScore:@"Bob Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        [self submitNameToHighScore:@"Cat Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        [self submitNameToHighScore:@"Dylan Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        [self submitNameToHighScore:@"Bob Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        [self submitNameToHighScore:@"Cat Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        [self submitNameToHighScore:@"Dylan Dudley" withScore:[NSNumber numberWithInt:arc4random() % 10]];
        
        scores = [self readStoredScores];
        NSLog(@"Displayed Scores: %@", scores);
        [self displayScores:scores];
        
        [self setReturnToMainButton];
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [HighScoreLayer node];
    [scene addChild:layer];
    return scene;
}

-(void) setReturnToMainButton
{
    
	// Create some menu items
    SEL setMainMenuSelector = sel_registerName("setReturnToMainAction:");
	CCMenuItemImage * returnMenuItem = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png" selectedImage: @"SlacklineMenu2.png"                                                                 target:self selector:setMainMenuSelector];
    
    returnMenuItem.tag=1;
    CGSize size = [CCDirector sharedDirector].winSize;
    returnMenuItem.position = CGPointMake(size.width * .5, size.height *.2);
    
    
	// add the menu to your scene
	[self addChild:returnMenuItem];
}

- (void) returnToMainAction: (CCMenuItem  *) menuItem
{
	[[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]];
}

- (NSMutableArray*) readStoredScores
{
    // Access the high scores plist
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"highscore.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"highscore" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    // Read the plist
    NSMutableArray *scores = [[NSMutableArray alloc] initWithContentsOfFile: path];
    //    NSLog(@"Scores: %@", scores);
    return scores;
}

- (void) submitNameToHighScore:(NSString*)username withScore:(NSNumber*)userscore
{
    // Access the high scores plist
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"highscore.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"highscore" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error:&error];
    }
    
    NSMutableArray *scores = [[NSMutableArray alloc] initWithContentsOfFile: path];
    NSLog(@"Old Scores: %@", scores);
    
    // Checks if score qualifies to be submitted to high scored
    int scoreIndex;
    NSMutableDictionary *newScore = [[NSMutableDictionary alloc] init];
    [newScore setObject:username forKey:@"Name"];
    [newScore setObject:userscore forKey:@"Score"];
    
    if (scores.count == 0) {
        [scores insertObject:newScore atIndex:0];
    }
    else {
        NSMutableDictionary *lowestScorer = [scores objectAtIndex:scores.count - 1];
        NSNumber *lowestScore = [lowestScorer objectForKey:@"Score"];
        if (userscore >= lowestScore || scores.count < maxScoresDisplayed) {
            scoreIndex = scores.count;
            
            for (int i = scores.count - 1; i >=0; i--) {
                scoreIndex = i;
                int currentScore = [[[scores objectAtIndex:i] valueForKey:@"Score"] intValue];
                if (currentScore >= [userscore intValue]) {
                    scoreIndex = i + 1;
                    break;
                }
            }
            
            [scores insertObject:newScore atIndex:scoreIndex];
        }
    }
    
    NSRange theRange;
    theRange.location = 0;
    theRange.length = min([scores count], maxScoresDisplayed);
    
    scores = [[scores subarrayWithRange:theRange] mutableCopy];
    [scores writeToFile:path atomically:YES];
    NSLog(@"New Scores: %@", scores);
}

- (void) displayScores: (NSMutableArray*) scores
{
    CGSize size = [CCDirector sharedDirector].winSize;
    int baseHeightPosition = size.height * 0.8;
    int heightSpacing = size.height * 0.1;
    int firstColumnPosition = size.width * 0.3;
    int secondColumnPosition = size.width * 0.8;
    
    int numScoresDisplayed = maxScoresDisplayed;
    if (scores.count < maxScoresDisplayed) numScoresDisplayed = scores.count;
    
    for (int i = 0; i < numScoresDisplayed; i++)
    {
        NSMutableDictionary *scoreDict = [scores objectAtIndex:i];
        
        NSString* userName = [scoreDict objectForKey:@"Name"];
        NSNumber* userScore = [scoreDict objectForKey:@"Score"];
        
        int heightPosition = baseHeightPosition - heightSpacing * i;
        
        CCLabelTTF* nameLabel = [CCLabelTTF labelWithString:userName fontName:@"Marker Felt" fontSize:24];
        nameLabel.position = CGPointMake(firstColumnPosition, heightPosition);
        [self addChild:nameLabel];
        
        CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", userScore] fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = CGPointMake(secondColumnPosition, heightPosition);
        [self addChild:scoreLabel];
    }
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end