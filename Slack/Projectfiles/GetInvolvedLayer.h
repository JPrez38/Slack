//
//  GetInvolvedLayer.h
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GetInvolvedLayer : CCLayer {
    
    CCSprite* background;
    CCSprite* personBottom;
    CCSprite* personTop;
}

+ (id) scene;

@end
