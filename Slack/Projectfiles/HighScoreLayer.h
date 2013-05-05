//
//  HighScoreLayer.h
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HighScoreLayer : CCLayer {
    unsigned int maxScoresDisplayed;
    CCSprite *background;
    //    CCSprite *personBottom;
    //    CCSprite *personTop;
}

- (NSMutableArray*) readStoredScores;
- (void) submitNameToHighScore:(NSString*)username withScore:(NSNumber*)userscore;
- (void) displayScores:(NSMutableArray*) scores;

+ (id) scene;
+ (HighScoreLayer*) sharedHighScoreLayer;
+ (id) highScoreLayer;


@end
