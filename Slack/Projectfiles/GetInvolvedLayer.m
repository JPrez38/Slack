//
//  GetInvolvedLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GetInvolvedLayer.h"
#import "MainMenuLayer.h"


@implementation GetInvolvedLayer

- (id) init {
    
    if ((self = [super init]))
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
		background = [CCSprite spriteWithFile:@"plainBackGround.png"];
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
        
        NSLog(@"About Screen Called");
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Get Involved" fontName:@"Marker Felt" fontSize:64];
		CGSize size = [CCDirector sharedDirector].winSize;
		label.position = CGPointMake(size.width / 2, size.height*.9);
        label.color = ccc3(0,0,0);
		[self addChild:label];
        [self setUpMenus];
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [GetInvolvedLayer node];
    [scene addChild:layer];
    return scene;
}

-(void) setUpMenus
{
    
	// Create some menu items
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"main_menu_icon.png"
                                                         selectedImage: @"main_menu_icon2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    menuItem1.tag=1;
    
	// Create a menu and add menu items to it
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
    
    CGSize size = [CCDirector sharedDirector].winSize;
    menuItem1.position = ccp(size.width*.5, size.height*.1);
    myMenu.position = ccp(0,0);
    
	// add the menu to your scene
	[self addChild:myMenu];
    
    //add get involved text
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Go to http://www.gibbonslacklines.com/us/ for more info" fontName:@"Marker Felt" fontSize:12];
    CGSize size2 = [CCDirector sharedDirector].winSize;
    label.position = CGPointMake(size2.width * 0.5, size2.height * 0.4);
    [self addChild:label];
    
}

- (void) doSomething: (CCMenuItem  *) menuItem
{
	int parameter = menuItem.tag;
    
    if (parameter==1) {
        [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]];
        
    }
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end
