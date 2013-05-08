//
//  MainMenuLayer.h
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer {
    CCSprite* background;
    CCSprite* personTop;
    CCSprite* personBottom;
    CGSize screenSize;
}

+ (id) scene;

@end
