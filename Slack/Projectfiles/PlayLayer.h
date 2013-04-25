//
//  PlayLayer.h
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayLayer : CCLayer {
    CCSprite* player;
    CCSprite* leftStoppedBar;
    CCSprite* rightStoppedBar;
    CCSprite* leftMovingBar;
    CCSprite* rightMovingBar;
    CCSprite* slackline;
    CGPoint playerVelocity;
    CCSprite* background;
    int score;
	CCNode<CCLabelProtocol>* scoreLabel;
    Boolean gameOver;
    Boolean swaying;
    Boolean blowing;
    int frameCount;
    NSString *direction;
}

+ (id) scene;

@end
