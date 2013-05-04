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
        foot=@"rightfoot";
        [self legs];
    
        upperbody = [CCSprite spriteWithFile:@"upperBod9.png"];
        upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        [self addChild:upperbody z:1 tag:1];
        
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:10] afterDelay:3.0f];
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:14] afterDelay:4.0f];
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:4] afterDelay:7.0f];
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:8] afterDelay:8.0f];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void) legs {
    NSString* personAnimName = @"lowerBod";
    NSLog(@"%@",personAnimName);
    CCAnimation* rightanim = [CCAnimation animationWithFile:personAnimName frameCount:16 delay:0.14f];
    CCAnimation* leftanim = [CCAnimation animationWithFile:personAnimName frameCount:8 delay:0.14f];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:rightanim name:@"rightfoot"];
    //[[CCAnimationCache sharedAnimationCache] addAnimation:leftanim name:@"leftfoot"];
    myAction= [CCAnimate actionWithAnimation:rightanim];
    
   
}

- (void) scheduleFalling:(NSString *) side {
    
}

- (void) walk {
    
    CCAnimation* anim = [[CCAnimationCache sharedAnimationCache] animationByName:foot];
    if ([myAction isDone] || count < 1){
        myAction= [CCAnimate actionWithAnimation:anim];
        [self runAction:myAction];
        count++;
        //performSelector:@selector(changeScene:) withObject:[MainMenuLayer scene] afterDelay:3.0
        [[PlayLayer sharedPlayLayer] incrementScore];
        /*if ([foot isEqual:@"rightfoot"]) {
            foot=@"leftfoot";
        }
        if ([foot isEqualToString:@"leftfoot"]){
            foot=@"rightfoot";
        }*/
    }
}

- (void) moveArms:(NSNumber*) position {
    [self removeChild:upperbody];
    NSString *image = [NSString stringWithFormat:@"upperBod%@.png", position];
    upperbody = [CCSprite spriteWithFile:image];
    upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
    [self addChild:upperbody];
}

-(void) update:(ccTime)delta
{
    
}

@end
