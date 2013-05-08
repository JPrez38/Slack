//
//  LoadingScreen.m
//  Slack
//
//  Created by Jacob Preston on 4/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "LoadingScreen.h"
#import "MainMenuLayer.h"
#import "HowToLayer.h"
#import "PlayLayer.h"


@interface LoadingScreen (PrivateMethods)
-(void) loadScene:(ccTime)delta;
@end

@implementation LoadingScreen

+(id) sceneWithTargetScene:(id)sceneType;
{
	CCLOG(@"===========================================");
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
    
	// This creates an autorelease object of self.
	// In class methods self refers to the current class and in this case is equivalent to LoadingScene.
	return [[self alloc] initWithTargetScene:sceneType];
}

-(id) initWithTargetScene:(id)sceneType
{
	if ((self = [super init]))
	{
		targetScene = sceneType;
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
		CCSprite *background = [CCSprite spriteWithFile:@"loading.png"];
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
		[self addChild:background z:-1];
    
		[self scheduleOnce:@selector(loadScene:) delay:0.0f];
	}
	
	return self;
}

/* loads the desired scene passed from previous layer */
-(void) loadScene:(ccTime)delta
{
    [[CCDirector sharedDirector] replaceScene:targetScene];
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end
