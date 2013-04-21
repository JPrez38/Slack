//
//  LoadingScreen.h
//  Slack
//
//  Created by Jacob Preston on 4/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LoadingScreen : CCScene
{
    id targetScene;
}
+(id) sceneWithTargetScene:(id)sceneType;
-(id) initWithTargetScene:(id)sceneType;

@end
