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
    CGPoint playerVelocity;
}

+ (id) scene;

@end
