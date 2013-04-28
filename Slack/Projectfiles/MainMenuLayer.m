//
//  MainMenuLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainMenuLayer.h"
#import "PlayLayer.h"
#import "AchievementModeLayer.h"
#import "HowToLayer.h"
#import "HighScoreLayer.h"
#import "GetInvolvedLayer.h"
#import "LoadingScreen.h"

@implementation MainMenuLayer

+ (id) scene{
    CCScene *scene = [CCScene node];
    CCLayer* layer = [MainMenuLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init {
    
    if ((self = [super init]))
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
		//
		background = [CCSprite spriteWithFile:@"MainMenu1.png"];
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        //background.opacity=156;
		[self addChild:background z:-1];
        [self setUpMenus];
    }
    return self;
}

-(void) setUpMenus
{
    
	// Create some menu items
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png"
                                                         selectedImage: @"SlacklineMenu2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    
	CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png"
                                                         selectedImage: @"SlacklineMenu2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    
    
	CCMenuItemImage * menuItem3 = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png"
                                                         selectedImage: @"SlacklineMenu2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    CCMenuItemImage * menuItem4 = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png"
                                                         selectedImage: @"SlacklineMenu2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    CCMenuItemImage * menuItem5 = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png"
                                                         selectedImage: @"SlacklineMenu2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    menuItem1.tag=1;
    menuItem2.tag=2;
    menuItem3.tag=3;
    menuItem4.tag=4;
    menuItem5.tag=5;
    
    
	// Create a menu and add your menu items to it
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3,menuItem4,menuItem5, nil];
    
	// Arrange the menu items vertically
	[myMenu alignItemsVertically];
    
	// add the menu to your scene
	[self addChild:myMenu];
}

- (void) doSomething: (CCMenuItem  *) menuItem
{
	int parameter = menuItem.tag;
    //psst! you can create a wrapper around your init method to pass in parameters
    if (parameter==1) {
        [self changeScene:[PlayLayer scene]];
    }
    if (parameter==2) {
        [self changeScene:[AchievementModeLayer scene]];
    }
    if (parameter==3) {
        [self changeScene:[HowToLayer scene]];
    }
    if (parameter==4) {
        [self changeScene:[HighScoreLayer scene]];
    }
    if (parameter==5) {
        [self changeScene:[GetInvolvedLayer scene]];
    }
}

-(void) changeScene: (id) layer
{
	BOOL useLoadingScene = YES;
	if (useLoadingScene)
	{
		[[CCDirector sharedDirector] replaceScene:[LoadingScreen sceneWithTargetScene:layer]];
	}
	else
	{
		[[CCDirector sharedDirector] replaceScene:layer];
	}
}

-(void) onEnter
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onEnter];
}

-(void) onEnterTransitionDidFinish
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onEnterTransitionDidFinish];
}

-(void) onExit
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onExit];
}

-(void) onExitTransitionDidStart
{
	CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
	
	// must call super here:
	[super onExitTransitionDidStart];
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}


@end
