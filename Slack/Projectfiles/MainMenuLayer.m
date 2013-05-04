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
		background = [CCSprite spriteWithFile:@"main_menu_bkgd1.png"];
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        //background.opacity=156;
		[self addChild:background z:-1];
        [self setUpMenus];
        
        personBottom = [CCSprite spriteWithFile:@"menuLowerBod.png"];
        [self addChild:personBottom z:0 tag:1];
        personBottom.position = CGPointMake(screenSize.width / 2, screenSize.height*.7);
        
        personTop = [CCSprite spriteWithFile:@"menuUpperBod.png"];
        [self addChild:personTop z:0 tag:1];
        personTop.position = CGPointMake(screenSize.width / 2, screenSize.height*.7);
    }
    return self;
}

-(void) setUpMenus
{
	// Create some menu items
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"main_menu_SLACK_01.png"
                                                         selectedImage: @"main_menu_SLACK_02.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    /*
     CCMenuItemImage * menuItem5 = [CCMenuItemImage itemWithNormalImage:@"SlacklineMenu2.png"
     selectedImage: @"SlacklineMenu2.png"
     target:self
     selector:@selector(doSomething:)];
     */
	CCMenuItemImage * menuItem2 = [CCMenuItemImage itemWithNormalImage:@"main_menu_SETTINGS_01.png"
                                                         selectedImage: @"main_menu_SETTINGS_02.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    
    CCMenuItemImage * menuItem3 = [CCMenuItemImage itemWithNormalImage:@"main_menu_HIGHSCORES_01.png"
                                                         selectedImage: @"main_menu_HIGHSCORES_02.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    
    CCMenuItemImage * menuItem4 = [CCMenuItemImage itemWithNormalImage:@"main_menu_GETINVOLVED_01.png"
                                                         selectedImage: @"main_menu_GETINVOLVED_02.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    menuItem1.tag=1;    //slack
    //menuItem5.tag=5;
    menuItem2.tag=2;    //how to
    menuItem3.tag=3;    //high scores
    menuItem4.tag=4;    //get involved
    
    
	// Create a menu and add your menu items to it
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, menuItem4, nil];
    
    CGSize size = [CCDirector sharedDirector].winSize;
    NSLog(@"HEIGHT: %f", size.height);
    NSLog(@"WIDTH: %f", size.width);
    
    menuItem1.position = ccp(size.width*.5, size.height*.45);
    menuItem2.position = ccp(size.width*.25, size.height*.25);
    menuItem3.position = ccp(size.width*.75, size.height*.25);
    menuItem4.position = ccp(size.width*.5, size.height*.09);
    myMenu.position = ccp(0,0);
    
	// add the menu to scene
	[self addChild:myMenu];
    
}

- (void) doSomething: (CCMenuItem  *) menuItem
{
	int parameter = menuItem.tag;
    
    if (parameter==1) {
        [self changeScene:[PlayLayer scene]];
    }
    // if (parameter==5) {
    //     [self changeScene:[AchievementModeLayer scene]];
    // }
    if (parameter==2) {
        [self changeScene:[HowToLayer scene]];
    }
    if (parameter==3) {
        [self changeScene:[HighScoreLayer scene]];
    }
    if (parameter==4) {
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
