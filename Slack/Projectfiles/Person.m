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

static Person* sharedPerson;
+(Person*) sharedPerson
{
	NSAssert(sharedPerson != nil, @"GameScene instance not yet initialized!");
	return sharedPerson;
}

+ (id) person {
    return [[self alloc] initWithPersonImage];
}

- (id) initWithPersonImage {
    
    if ((self = [super initWithFile:@"lowerBod0.png"]))
	{
        screenSize = [[CCDirector sharedDirector] winSize];
        sharedPerson=self;
        
        count=0;
        [self legs];
    
        upperbody = [CCSprite spriteWithFile:@"upperBod0.png"];
        upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        [self addChild:upperbody z:1 tag:1];
        
        
        [self performSelector:@selector(moveArms) withObject:nil afterDelay:5.0f];
        [self scheduleUpdate];
    }
    return self;
}

- (void) legs {
    NSString* personAnimName = @"lowerBod";
    NSLog(@"%@",personAnimName);
    CCAnimation* anim = [CCAnimation animationWithFile:personAnimName frameCount:16 delay:0.14f];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:anim name:personAnimName];
    myAction= [CCAnimate actionWithAnimation:anim];
    
   
}

- (void) walk {
    
    CCAnimation* anim = [[CCAnimationCache sharedAnimationCache] animationByName:@"lowerBod"];
    if ([myAction isDone] || count < 1){
        myAction= [CCAnimate actionWithAnimation:anim];
        [self runAction:myAction];
        count++;
        //performSelector:@selector(changeScene:) withObject:[MainMenuLayer scene] afterDelay:3.0
        [[PlayLayer sharedPlayLayer] incrementScore];
    }
}

- (void) moveArms {
    [self removeChild:upperbody];
    upperbody = [CCSprite spriteWithFile:@"upperBod9.png"];
    upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
    [self addChild:upperbody];
}

-(void) update:(ccTime)delta
{
    
}

@end
