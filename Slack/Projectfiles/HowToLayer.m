//
//  HowToLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/19/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HowToLayer.h"
#import "MainMenuLayer.h"

@implementation HowToLayer

- (id) init {
    
    if ((self = [super init]))
    {
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"How to Play!" fontName:@"Marker Felt" fontSize:64];
		CGSize size = [CCDirector sharedDirector].winSize;
		label.position = CGPointMake(size.width / 2, size.height / 2+80);
		[self addChild:label];
        [self setUpMenus];
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [HowToLayer node];
    [scene addChild:layer];
    return scene;
}

-(void) setUpMenus
{
    
	// Create some menu items
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"main_menu_icon"
                                                         selectedImage: @"main_menu_icon2"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    menuItem1.tag=1;
    
    
	// Create a menu and add your menu items to it
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
    
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
        [[CCDirector sharedDirector] replaceScene: [MainMenuLayer scene]];
        
    }
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end
