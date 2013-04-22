//
//  PlayLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PlayLayer.h"
#import "MainMenuLayer.h"
#import "LoadingScreen.h"


@implementation PlayLayer

- (id) init {
    
    if ((self = [super init]))
    {
        NSLog(@"PlayLayer Screen Called");
        #if KK_PLATFORM_IOS
            //self.isAccelerometerEnabled = YES;
            _accelerometerEnabled=YES;
            _touchEnabled = YES;
        #endif
    
        
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
		
		background = [CCSprite spriteWithFile:@"BG1.png"];
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        background.opacity=156;
		[self addChild:background];
         
        
        slackline = [CCSprite spriteWithFile:@"redslackline.png"];
        [self addChild:slackline z:0 tag:1];
        float imageHeight3 = leftStoppedBar.texture.contentSize.height;
        slackline.position = CGPointMake(screenSize.width / 2, imageHeight3);
        
        player = [CCSprite spriteWithFile:@"ball.png"];
        [self addChild:player z:0 tag:1];
        float imageHeight = player.texture.contentSize.height;
        player.position = CGPointMake(screenSize.width / 2, imageHeight / 2);
        
        leftStoppedBar = [CCSprite spriteWithFile:@"line.png"];
        [self addChild:leftStoppedBar z:0 tag:1];
        float imageHeight1 = leftStoppedBar.texture.contentSize.height;
        leftStoppedBar.position = CGPointMake(screenSize.width / 2-60, imageHeight1 / 2);
        
        rightStoppedBar = [CCSprite spriteWithFile:@"line.png"];
        [self addChild:rightStoppedBar z:0 tag:1];
        rightStoppedBar.position = CGPointMake(screenSize.width / 2+60, imageHeight1 / 2);
        
        leftMovingBar = [CCSprite spriteWithFile:@"line2.png"];
        [self addChild:leftMovingBar z:0 tag:1];
        float imageHeight2 = leftMovingBar.texture.contentSize.height;
        leftMovingBar.position = CGPointMake(screenSize.width / 2+40, imageHeight2 / 2);
        
        rightMovingBar = [CCSprite spriteWithFile:@"line2.png"];
        [self addChild:rightMovingBar z:0 tag:1];
        rightMovingBar.position = CGPointMake(screenSize.width / 2-40, imageHeight2 / 2);
		
		// schedules the –(void) update:(ccTime)delta method to be called every frame
		[self scheduleUpdate];
        
        scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapfont.fnt"];
		scoreLabel.position = CGPointMake(80, screenSize.height);
		// Adjust the label's anchorPoint's y position to make it align with the top.
		scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
		// Add the score label with z value of -1 so it's drawn below everything else
		[self addChild:scoreLabel];
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [PlayLayer node];
    [scene addChild:layer];
    return scene;
}

-(void) update:(ccTime)delta
{
	// Keep adding up the playerVelocity to the player's position
	CGPoint pos = player.position;
	pos.x += playerVelocity.x;
	
	// The Player should also be stopped from going outside the screen
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	float imageWidthHalved = player.texture.contentSize.width * 0.5f;
	float leftBorderLimit = imageWidthHalved;
	float rightBorderLimit = screenSize.width - imageWidthHalved;
	
	// preventing the player sprite from moving outside the screen
	if (pos.x < leftBorderLimit)
	{
		pos.x = leftBorderLimit;
		playerVelocity = CGPointZero;
	}
	else if (pos.x > rightBorderLimit)
	{
		pos.x = rightBorderLimit;
		playerVelocity = CGPointZero;
	}
	
	// assigning the modified position back
	player.position = pos;
    [self checkForFall:@"standing"];
    
    KKTouch* touch;
    CCARRAY_FOREACH([KKInput sharedInput].touches, touch)
    {
        if ([background containsPoint:touch.location]) {
            [self checkForFall:@"walking"];
            [self takeStep];
        }
    }
    
	[scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
}

- (void) takeStep
{
    score+=1;
}

-(void) checkForFall: (NSString*) state
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGPoint middle = CGPointMake(screenSize.width / 2, 0);
    float actualDistance = ccpDistance(player.position, middle);
    if (fabsf(actualDistance)>=60 || ([state isEqualToString:@"walking"] && fabsf(actualDistance >= 40))){
    //if (fabsf(actualDistance)>=60){
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
		CGSize size = [CCDirector sharedDirector].winSize;
		label.position = CGPointMake(size.width / 2, size.height / 2);
		[self addChild:label];
        //sleep(3);
        [self changeScene:[MainMenuLayer scene]];
    }
}

#if KK_PLATFORM_IOS
-(void) accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
	// controls how quickly velocity decelerates (lower = quicker to change direction)
	float deceleration = 0.4f;
	// determines how sensitive the accelerometer reacts (higher = more sensitive)
	float sensitivity = 6.0f;
	// how fast the velocity can be at most
	float maxVelocity = 100;
	
	// adjust velocity based on current accelerometer acceleration
	playerVelocity.x = playerVelocity.x * deceleration + acceleration.x * sensitivity;
	
	// we must limit the maximum velocity of the player sprite, in both directions
	if (playerVelocity.x > maxVelocity)
	{
		playerVelocity.x = maxVelocity;
	}
	else if (playerVelocity.x < - maxVelocity)
	{
		playerVelocity.x = - maxVelocity;
	}
}
#endif

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
