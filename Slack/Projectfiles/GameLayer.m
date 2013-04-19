//
//  GameLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "AboutLayer.h"
#import "PlayLayer.h"
#import "HelpLayer.h"


@implementation GameLayer

+ (id) scene{
    CCScene *scene = [CCScene node];
    CCLayer* layer = [GameLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init {
    
    if ((self = [super init]))
    {
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
    menuItem1.tag=1;
    menuItem2.tag=2;
    menuItem3.tag=3;
    
    
	// Create a menu and add your menu items to it
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
    
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
        [[CCDirector sharedDirector] replaceScene: [PlayLayer scene]];
        
    }
    
    if (parameter==2) {
        [[CCDirector sharedDirector] replaceScene: [AboutLayer scene]];

    }
    
    if (parameter==3) {
        [[CCDirector sharedDirector] replaceScene: [HelpLayer scene]];
        
    }
}

-(void) dealloc
{
    CCLOG(@"%@: %@", NSStringFromSelector(_cmd), self);
}

@end
