//
//  Person.m
//  Slack
//
//  Created by Jacob Preston on 5/1/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "CCAnimationHelper.h"
#import "PlayLayer.h"


@implementation Person

+ (id) person {
    return [[self alloc] initWithPersonImage];
}

- (id) initWithPersonImage {
    
    if ((self = [super initWithFile:@"lowerBod0.png"]))
	{
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
        NSString* personAnimName = @"lowerBod";
        NSLog(@"%@",personAnimName);
		CCAnimation* anim = [CCAnimation animationWithFile:personAnimName frameCount:16 delay:0.14f];
		
		// run the animation by using the CCAnimate action
		CCAnimate* animate = [CCAnimate actionWithAnimation:anim];
		CCRepeatForever* repeat = [CCRepeatForever actionWithAction:animate];
		[self runAction:repeat];
		
        // call "update" for every frame
		[self scheduleUpdate];
        
    
        upperbody = [CCSprite spriteWithFile:@"upperBod0.png"];
        [self addChild:upperbody z:1 tag:1];
        upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
    }
    return self;
}

- (id) walking {
    
}

@end
