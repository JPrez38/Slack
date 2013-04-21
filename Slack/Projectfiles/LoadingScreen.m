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
#import "AchievementModeLayer.h"


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
        
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Loading ..." fontName:@"Marker Felt" fontSize:64];
		CGSize size = [CCDirector sharedDirector].winSize;
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label];
		
		// Must wait at least one frame before loading the target scene!
		// Two reasons: first, it would crash if not. Second, the Loading label wouldn't be displayed.
		// In this case delay is set to > 0.0f just so you can actually see the LoadingScene.
		// If you use the LoadingScene in your own code, be sure to set the delay to 0.0f
		[self scheduleOnce:@selector(loadScene:) delay:2.0f];
	}
	
	return self;
}

-(void) loadScene:(ccTime)delta
{
	// Decide which scene to load based on the TargetScenes enum.
	// You could also use TargetScene to load the same with using a variety of transitions.
    [[CCDirector sharedDirector] replaceScene:targetScene];
}

-(void) dealloc
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end
