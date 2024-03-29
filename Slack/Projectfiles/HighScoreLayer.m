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
    
    //NSAssert(sharedHighScoreLayer != nil, @"GameScene instance not yet initialized!");
	return sharedHighScoreLayer;
}

+ (id) highScoreLayer {
    return [[self alloc] init];
}

- (id) init {
    
    if ((self = [super init]))
    {
        screenSize = [[CCDirector sharedDirector] winSize];
        sharedHighScoreLayer=self;
        [self setUpBackground];
        [self setUpMenus];
        
        // Global Variables
        maxScoresDisplayed = 6;
        
        // Get data from plist
        NSMutableArray *scores = [self readStoredScores];
        
        scores = [self readStoredScores];
        NSLog(@"Displayed Scores: %@", scores);
        [self displayScores:scores];
    }
    return self;
}

- (void) setUpBackground {
    //background images
    
    background = [CCSprite spriteWithFile:@"backgroundStretched.png"];
    background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    [self addChild:background z:-1];
    
    CCLabelTTF* labelTop = [CCLabelTTF labelWithString:@"High Scores" fontName:@"Marker Felt" fontSize:64];
    CGSize sizeTop = [CCDirector sharedDirector].winSize;
    labelTop.position = CGPointMake(sizeTop.width / 2, sizeTop.height*.9);
    labelTop.color = ccc3(255,140,0);
    [self addChild:labelTop];
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [HighScoreLayer node];
    [scene addChild:layer];
    return scene;
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
    int baseHeightPosition = screenSize.height * 0.72;
    int heightSpacing = screenSize.height * 0.1;
    int firstColumnPosition = screenSize.width * 0.3;
    int secondColumnPosition = screenSize.width * 0.72;
    
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
        nameLabel.color = ccc3(0,100,0);
        [self addChild:nameLabel];
        
        CCLabelTTF* scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", userScore] fontName:@"Marker Felt" fontSize:24];
        scoreLabel.position = CGPointMake(secondColumnPosition, heightPosition);
        scoreLabel.color = ccc3(0,100,0);
        [self addChild:scoreLabel];
    }
}

-(void) setUpMenus
{
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"main_menu_icon.png"
                                                         selectedImage: @"main_menu_icon2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    menuItem1.tag=1;
    
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
    menuItem1.position = ccp(screenSize.width*.5, screenSize.height*.1);
    myMenu.position = ccp(0,0);
	[self addChild:myMenu];
}

- (void) doSomething: (CCMenuItem  *) menuItem
{
	int parameter = menuItem.tag;
    
    if (parameter==1) {
        [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]];
        
    }
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end