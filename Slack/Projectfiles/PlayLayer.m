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
#import "Person.h"


@implementation PlayLayer

static PlayLayer* sharedPlayLayer;
+ (PlayLayer*) sharedPlayLayer
{
	NSAssert(sharedPlayLayer != nil, @"GameScene instance not yet initialized!");
	return sharedPlayLayer;
}

- (id) init {
    
    if ((self = [super init]))
    {
        sharedPlayLayer=self;
        NSLog(@"PlayLayer Screen Called");
        #if KK_PLATFORM_IOS
            //self.isAccelerometerEnabled = YES;
            _accelerometerEnabled=YES;
            _touchEnabled = YES;
        #endif
        
        time=0;
        
		CGSize screenSize = [[CCDirector sharedDirector] winSize];
        gameOver=false;
        swaying=false;
		
		background = [CCSprite spriteWithFile:@"grass_bkgrd1.png"];
		background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
        //background.opacity=156;
		[self addChild:background z:-1];
        
        slackline = [CCSprite spriteWithFile:@"slackline1.png"];
        [self addChild:slackline z:0 tag:1];
        slackline.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        
        person = [Person person];
		person.position = CGPointMake(screenSize.width/2, screenSize.height / 2);
		[self addChild:person z:10];
        
        tree1 = [CCSprite spriteWithFile:@"tree01.png"];
        [self addChild:tree1 z:0 tag:0];
        tree1.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        
        tree2 = [CCSprite spriteWithFile:@"tree02.png"];
        [self addChild:tree2 z:0 tag:0];
        tree2.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
        
        
        player = [CCSprite spriteWithFile:@"ball.png"];
        //player.opacity=0;
        [self addChild:player z:0 tag:1];
        float imageHeight = player.texture.contentSize.height;
        player.position = CGPointMake(screenSize.width / 2, imageHeight / 2);
        
        leftStoppedBar = [CCSprite spriteWithFile:@"line.png"];
        //leftStoppedBar.opacity=0;
        [self addChild:leftStoppedBar z:0 tag:1];
        float imageHeight1 = leftStoppedBar.texture.contentSize.height;
        leftStoppedBar.position = CGPointMake(screenSize.width / 2-60, imageHeight1 / 2);
        
        rightStoppedBar = [CCSprite spriteWithFile:@"line.png"];
        //rightStoppedBar.opacity=0;
        [self addChild:rightStoppedBar z:0 tag:1];
        rightStoppedBar.position = CGPointMake(screenSize.width / 2+60, imageHeight1 / 2);
        
        leftMovingBar = [CCSprite spriteWithFile:@"line2.png"];
        //leftMovingBar.opacity=0;
        [self addChild:leftMovingBar z:0 tag:1];
        float imageHeight2 = leftMovingBar.texture.contentSize.height;
        leftMovingBar.position = CGPointMake(screenSize.width / 2+40, imageHeight2 / 2);
        
        rightMovingBar = [CCSprite spriteWithFile:@"line2.png"];
        //rightMovingBar.opacity=0;
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
    if (gameOver == false){
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
        pos.x += [self sway];
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
    else {
        //[[Person sharedPerson] stop];
    }
}

- (float) sway {
    //CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float adj;
    //float sensitivity=.9f;
    //float prob=.1;
    /*
    int rand = arc4random()%10;
    //int direction=arc4random()%2;
    ///NSLog(@"%d", direction);
    if (prob*10 >=rand || (swaying)){
        if (!swaying) {
            swaying=true;
        }
        if (player.position.x < screenSize.width/2) {
            adj= sensitivity;
        }
        else if (player.position.x > screenSize.width/2){
            adj = -sensitivity;
        }
        else {
            adj=0;
        }
        frameCount+=1;
        if (frameCount >=30 && swaying) {
            swaying=false;
            frameCount=0;
        }
    }*/
    adj += [self wind];
    return adj;
}

- (float) wind {
    float windadj=0;
    float sensitivity=2.0f;
    float prob=.003;
    
    int rand = arc4random()%1000;
    //NSLog(@"%d",rand);
    if (blowing==true){
        
    }
    
    
    if (prob*1000 >=rand || (blowing)){
        //NSLog(@"hey");
        if (!blowing) {
            blowing=true;
            //NSLog(@"yo");
        }
        int randdir=arc4random()%2;
        //NSLog(@"%d", randdir);
        if ((randdir >= 1 && [direction isEqual:@"none"]) || [direction isEqual:@"right"]){
            windadj=sensitivity;
            direction=@"right";
        }
        else if ((randdir < 1 && [direction isEqual:@"none"]) || [direction isEqual:@"left"]) {
            windadj= -sensitivity;
            direction=@"left";
        }
        frameCount+=1;
        if (frameCount%4) {
            //sensitivity+=1.0f;
        }
        if (frameCount >=20 && blowing) {
            blowing=false;
            frameCount=0;
            direction=@"none";
            //sensitivity=0.0f;
        }
    }
    
    return windadj;
}

- (void) takeStep
{
    [[Person sharedPerson] walk];
}

- (void) incrementScore {
    score++;
    [self performSelector:@selector(increment) withObject:nil afterDelay:1.2f];
}

- (void) increment {
    score++;
}

- (float) slip {
    float slipadj;
    return slipadj;
}

-(void) checkForFall: (NSString*) state
{
    CGSize screenSize = [CCDirector sharedDirector].winSize;
    CGPoint middle = CGPointMake(screenSize.width / 2, 0);
    float actualDistance = ccpDistance(player.position, middle);
    if (fabsf(actualDistance)>=60 || ([state isEqualToString:@"walking"] && fabsf(actualDistance >= 40))){
        gameOver=true;
    //if (fabsf(actualDistance)>=60){
        [self gameOver];
    }
}

- (void) gameOver {
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
    CGSize size = [CCDirector sharedDirector].winSize;
    label.position = CGPointMake(size.width / 2, size.height / 2);
    [self addChild:label];
    [self performSelector:@selector(changeScene:) withObject:[MainMenuLayer scene] afterDelay:3.0];
}

#if KK_PLATFORM_IOS
-(void) accelerometer:(UIAccelerometer *)accelerometer
        didAccelerate:(UIAcceleration *)acceleration
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
	// controls how quickly velocity decelerates (lower = quicker to change direction)
	float deceleration = 0.5f;
	// determines how sensitive the accelerometer reacts (higher = more sensitive)
	float sensitivity;
	// how fast the velocity can be at most
	float maxVelocity = 100;
    float middle =screenSize.width;
    float distance = fabsf(player.position.x-middle);
    
    if (distance <= 30){
        sensitivity=2.0f;
    }
    
    if (distance > 30 && distance <= 40 ) {
        sensitivity=3.0f;
    }
    
    if (distance > 40 && distance <= 60 ) {
        sensitivity=4.0f;
    }
	
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
