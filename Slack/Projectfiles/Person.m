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
        
        NSString* fallingLeft = @"falling_02_";
        NSString* fallingRight = @"falling_01_";
        CCAnimation* rightFallanim = [CCAnimation animationWithFile:fallingRight frameCount:18 delay:0.07f];
        CCAnimation* leftFallanim = [CCAnimation animationWithFile:fallingLeft frameCount:18 delay:0.07f];
        
        [[CCAnimationCache sharedAnimationCache] addAnimation:rightFallanim name:@"rightFall"];
        [[CCAnimationCache sharedAnimationCache] addAnimation:leftFallanim name:@"leftFall"];
        
        
        //[self performSelector:@selector(scheduleFalling:) withObject:@"left" afterDelay:4.0f];
        
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:10] afterDelay:3.0f];
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:14] afterDelay:4.0f];
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:4] afterDelay:7.0f];
        //[self performSelector:@selector(moveArms:) withObject:[NSNumber numberWithInt:8] afterDelay:8.0f];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void) legs {
    NSString* rightStep = @"rightStep";
    NSString* leftStep = @"leftStep";
    CCAnimation* rightStepAnim = [CCAnimation animationWithFile:rightStep frameCount:8 delay:0.08f];
    CCAnimation* leftStepAnim = [CCAnimation animationWithFile:leftStep frameCount:8 delay:0.08f];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:rightStepAnim name:@"rightfoot"];
    [[CCAnimationCache sharedAnimationCache] addAnimation:leftStepAnim name:@"leftfoot"];
    myAction= [CCAnimate actionWithAnimation:rightStepAnim];
    
   
}

- (void) walk {
    
    if ([[PlayLayer sharedPlayLayer] isGameOver]) {
        [self stopAction:myAction];
    }
    
    CCAnimation* anim = [[CCAnimationCache sharedAnimationCache] animationByName:foot];
    if (([myAction isDone] || count < 1) && (![[PlayLayer sharedPlayLayer] isGameOver])){
        myAction= [CCAnimate actionWithAnimation:anim];
        [self runAction:myAction];
        count++;
        //performSelector:@selector(changeScene:) withObject:[MainMenuLayer scene] afterDelay:3.0
        [[PlayLayer sharedPlayLayer] incrementScore];
        if ([foot isEqualToString:@"rightfoot"]) {
            foot=@"leftfoot";
        }
        else {
            foot=@"rightfoot";
        }
    }
}

- (void) scheduleFalling:(NSString *) side {
    CCAnimation *anim;
    CCAction *action;
    if ([side isEqualToString:@"right"]) {
        anim = [[CCAnimationCache sharedAnimationCache] animationByName:@"rightFall"];
        action = [CCAnimate actionWithAnimation:anim];
        [self runAction:action];
    }

    if ([side isEqualToString:@"left"]){
         anim = [[CCAnimationCache sharedAnimationCache] animationByName:@"leftFall"];
         action = [CCAnimate actionWithAnimation:anim];
         [self runAction:action];
    }
    
    
    
}



- (void) moveArms:(NSNumber*) position {
    [self removeChild:upperbody];
    if (![[PlayLayer sharedPlayLayer] isGameOver]){
        
        NSString *image = [NSString stringWithFormat:@"upperBod%@.png", position];
        upperbody = [CCSprite spriteWithFile:image];
        upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        [self addChild:upperbody];
    }
}

-(void) update:(ccTime)delta
{
    
}

@end
