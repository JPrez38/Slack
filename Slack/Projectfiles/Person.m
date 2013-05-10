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
#import "LoadingScreen.h"


@implementation Person

static Person* sharedPerson;
+(Person*) sharedPerson
{
	NSAssert(sharedPerson != nil, @"Person instance not yet initialized!");
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
        
        [self initUpperBody];
        [self initLegs];
        [self initFallingAnimations];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void) initUpperBody {
    /* initializes the upperbody sprite with the middle most image */
    upperbody = [CCSprite spriteWithFile:@"upperBod9.png"];
    upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
    [self addChild:upperbody z:1 tag:1];
}

- (void) initFallingAnimations {
    NSString* fallingLeft = @"falling_02_";
    NSString* fallingRight = @"falling_01_";
    /* sets the falling animations, delay is used to adjust the speed of the fall */
    CCAnimation* rightFallanim = [CCAnimation animationWithFile:fallingRight frameCount:18 delay:0.07f];
    CCAnimation* leftFallanim = [CCAnimation animationWithFile:fallingLeft frameCount:18 delay:0.07f];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:rightFallanim name:@"rightFall"];
    [[CCAnimationCache sharedAnimationCache] addAnimation:leftFallanim name:@"leftFall"];
}

- (void) initLegs {
    foot=@"rightfoot";
    count=0;
    playerSpeed=.08f;
    NSString* rightStep = @"rightStep";
    NSString* leftStep = @"leftStep";
    /* initializes seperate right step and left step animations
     * delay sets the speed of the guy walking
     */
    CCAnimation* rightStepAnim = [CCAnimation animationWithFile:rightStep frameCount:8 delay:playerSpeed];
    CCAnimation* leftStepAnim = [CCAnimation animationWithFile:leftStep frameCount:8 delay:playerSpeed];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:rightStepAnim name:@"rightfoot"];
    [[CCAnimationCache sharedAnimationCache] addAnimation:leftStepAnim name:@"leftfoot"];
    myAction= [CCAnimate actionWithAnimation:rightStepAnim];
}

- (void) changeSpeed: (float) newSpeed {
    playerSpeed= max(newSpeed, .065);
    NSString* rightStep = @"rightStep";
    NSString* leftStep = @"leftStep";
    /* initializes seperate right step and left step animations
     * delay sets the speed of the guy walking
     */
    CCAnimation* rightStepAnim = [CCAnimation animationWithFile:rightStep frameCount:8 delay:playerSpeed];
    CCAnimation* leftStepAnim = [CCAnimation animationWithFile:leftStep frameCount:8 delay:playerSpeed];
    
    [[CCAnimationCache sharedAnimationCache] addAnimation:rightStepAnim name:@"rightfoot"];
    [[CCAnimationCache sharedAnimationCache] addAnimation:leftStepAnim name:@"leftfoot"];
}

- (float) getSpeed {
    return playerSpeed;
}

- (void) walk {
    
    if ([[PlayLayer sharedPlayLayer] isGameOver]) {
        [self stopAction:myAction];
    }
    /* loads the animation by foot name */
    CCAnimation* anim = [[CCAnimationCache sharedAnimationCache] animationByName:foot];
    /*runs the animation only after the action before is done or if no action has been performed
     * i.e., the very first step
     */
    if (([myAction isDone] || count < 1) && (![[PlayLayer sharedPlayLayer] isGameOver])){
        myAction= [CCAnimate actionWithAnimation:anim];
        [self runAction:myAction];
        count++;
        [[PlayLayer sharedPlayLayer] incrementScore]; //increments the score in the play layer
        /* changes the foot every step */
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
    /* runs the fall right animation */
    if ([side isEqualToString:@"right"]) {
        anim = [[CCAnimationCache sharedAnimationCache] animationByName:@"rightFall"];
        action = [CCAnimate actionWithAnimation:anim];
        [self runAction:action];
    }
    /* runs the fall left animation */
    if ([side isEqualToString:@"left"]){
         anim = [[CCAnimationCache sharedAnimationCache] animationByName:@"leftFall"];
         action = [CCAnimate actionWithAnimation:anim];
         [self runAction:action];
    }
}


/* arms are moved by removing the current upperbody Sprite
 * changing the image to be loaded and then reloading the new image
 * based on the position sent to method from the playlayer
 */
- (void) moveArms:(NSNumber*) position {
    [self removeChild:upperbody];
    if (![[PlayLayer sharedPlayLayer] isGameOver]){
        
        NSString *image = [NSString stringWithFormat:@"upperBod%@.png", position];
        upperbody = [CCSprite spriteWithFile:image];
        upperbody.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        [self addChild:upperbody];
        //NSLog(@"HEYYYY %@", position);
    }
}

/* unused update method. leave in to keep in line with cocos2d classes */
-(void) update:(ccTime)delta {}

-(void) changeScene: (id) layer
{
    [[CCDirector sharedDirector] replaceScene:[LoadingScreen sceneWithTargetScene:layer]];
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
