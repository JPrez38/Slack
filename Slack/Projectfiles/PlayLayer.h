//
//  PlayLayer.h
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Person.h"

@interface PlayLayer : CCLayer {
    CCSprite* player;
    CCSprite* leftStoppedBar;
    CCSprite* rightStoppedBar;
    CCSprite* leftMovingBar;
    CCSprite* rightMovingBar;
    CCSprite* slackline;
    CCSprite* lowerbody;
    CCSprite* upperbody;
    Person* person;
    NSMutableArray* trees;
    CCSprite* tree1;
    CCSprite* tree2;
    CCSprite* tree3;
    CGPoint playerVelocity;
    CCSprite* background;
    int score;
	CCNode<CCLabelProtocol>* scoreLabel;
    Boolean gameOver;
    Boolean swaying;
    Boolean blowing;
    int frameCount;
    NSString *direction;
    int count;
    int balBar;
    NSMutableArray* environmentObjects;
    float speed;
    
    
}

+ (id) scene;
- (void) incrementScore;
+ (PlayLayer *) sharedPlayLayer;
- (Boolean) isGameOver;

@end