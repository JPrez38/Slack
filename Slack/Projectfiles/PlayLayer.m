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
#import "HighScoreLayer.h"

#define SLOW .08
#define MEDIUM .0725
#define FAST .065

//used for balance bar
#define ON 1
#define OFF -10
#define BALBAR OFF



@implementation PlayLayer

static PlayLayer* sharedPlayLayer;
+ (PlayLayer*) sharedPlayLayer
{
	NSAssert(sharedPlayLayer != nil, @"GameScene instance not yet initialized!");
	return sharedPlayLayer;
}


+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [PlayLayer node];
    [scene addChild:layer];
    return scene;
}

- (id) init {
    
    if ((self = [super init]))
    {
        sharedPlayLayer=self;
#if KK_PLATFORM_IOS
        _accelerometerEnabled=YES;
        _touchEnabled = YES;
#endif
        balBar=BALBAR;
        gameOver=false;
        swaying=false;
        
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		[frameCache addSpriteFramesWithFile:@"game-art.plist"];
        
        [self initAudio];
        [self initBackGround];
        [self initPerson];
        [self setUpMenus];
        [self initEnviornment];
        [self initBalanceBar];
        [self initScoreLabel];
        
		[self scheduleUpdate];
        
        
    }
    return self;
}

- (void) initScoreLabel {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapfont.fnt"];
    scoreLabel.position = CGPointMake(80, screenSize.height);

    scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);

    [self addChild:scoreLabel];
    
}

- (void) initBalanceBar {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    player = [CCSprite spriteWithFile:@"ball.png"];
    //player.opacity=0;
    [self addChild:player z:balBar tag:1];
    float imageHeight = player.texture.contentSize.height;
    player.position = CGPointMake(screenSize.width / 2, imageHeight / 2);
    
    leftStoppedBar = [CCSprite spriteWithFile:@"line.png"];
    //leftStoppedBar.opacity=0;
    [self addChild:leftStoppedBar z:balBar tag:1];
    float imageHeight1 = leftStoppedBar.texture.contentSize.height;
    leftStoppedBar.position = CGPointMake(screenSize.width / 2-60, imageHeight1 / 2);
    
    rightStoppedBar = [CCSprite spriteWithFile:@"line.png"];
    //rightStoppedBar.opacity=0;
    [self addChild:rightStoppedBar z:balBar tag:1];
    rightStoppedBar.position = CGPointMake(screenSize.width / 2+60, imageHeight1 / 2);
    
    leftMovingBar = [CCSprite spriteWithFile:@"line2.png"];
    //leftMovingBar.opacity=0;
    [self addChild:leftMovingBar z:balBar tag:1];
    float imageHeight2 = leftMovingBar.texture.contentSize.height;
    leftMovingBar.position = CGPointMake(screenSize.width / 2+55, imageHeight2 / 2);
    
    rightMovingBar = [CCSprite spriteWithFile:@"line2.png"];
    //rightMovingBar.opacity=0;
    [self addChild:rightMovingBar z:balBar tag:1];
    rightMovingBar.position = CGPointMake(screenSize.width / 2-55, imageHeight2 / 2);
}

- (void) initEnviornment {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    environmentObjects = [[NSMutableArray alloc] init];
    [environmentObjects addObject:[CCSprite spriteWithFile:@"tree01.png"]];
    [environmentObjects addObject:[CCSprite spriteWithFile:@"tree02.png"]];
    [environmentObjects addObject:[CCSprite spriteWithFile:@"tree03.png"]];
    //        [environmentObjects addObject:[CCSprite spriteWithFile:@"rock01.png"]];
    //        [environmentObjects addObject:[CCSprite spriteWithFile:@"rock02.png"]];
    //        [environmentObjects addObject:[CCSprite spriteWithFile:@"rock02.png"]];
    
    for (unsigned int i = 0; i < environmentObjects.count; i++)
    {
        CCSprite* anEnvirObj = environmentObjects[i];
        // Assuming there are 3 trees at index 0, 1, and 2
        if (i < 3) {
            [self addChild:anEnvirObj z:2 tag:0];
            //            NSLog(@"x: %f, y: %f", anEnvirObj.position.x, anEnvirObj.position.y);
            anEnvirObj.position = CGPointMake(screenSize.width * 0.5, screenSize.height * 0.5);
        }
        else {
            [self addChild:anEnvirObj z:1 tag:0];
            //            NSLog(@"x: %f, y: %f", anEnvirObj.position.x, anEnvirObj.position.y);
            int randomWidthPos = arc4random() % 4;
            int randomWidthSide = arc4random() % 2; //0 go to left, 1 go to right
            
            double rndWidthPos = randomWidthPos;
            
            if(randomWidthSide == 0){       //go to left
                anEnvirObj.position = CGPointMake(screenSize.width * (rndWidthPos/10.0), screenSize.height * (arc4random() / RAND_MAX));
            }
            else{               //go to right
                anEnvirObj.position = CGPointMake(screenSize.width * (1 - rndWidthPos/10.0), screenSize.height * (arc4random() / RAND_MAX));
            }
        }
    }
}

- (void) initBackGround {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    background = [CCSprite spriteWithFile:@"grass_bkgrd1.png"];
    background.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    //background.opacity=156;
    [self addChild:background z:-1];
    
    slackline = [CCSprite spriteWithFile:@"slackline1.png"];
    [self addChild:slackline z:0 tag:1];
    slackline.position = CGPointMake(screenSize.width / 2, screenSize.height/2);
}

- (void) initPerson {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    person = [Person person];
    person.position = CGPointMake(screenSize.width/2, screenSize.height / 2);
    [self addChild:person z:10];
    
}

- (void) initAudio {
    
    // Init sounds
    SimpleAudioEngine* simpleAudioEngine = [SimpleAudioEngine sharedEngine];
    [simpleAudioEngine playBackgroundMusic:@"jungle.mp3" loop:YES];
    [simpleAudioEngine preloadEffect:@"jungle.mp3"];
}


-(void) update:(ccTime)delta
{
    if (gameOver == false){
        [self updatePosition];
        [self adjustArms];
        [self checkForFall:@"standing"];
        [self updateSpeed];
        KKTouch* touch;
        
        
        CCARRAY_FOREACH([KKInput sharedInput].touches, touch)
        {
            if ([background containsPoint:touch.location] && (!gameOver)) {
                [self checkForFall:@"walking"];
                [self takeStep];
                [self updateTrees];
            }
            
        }
        
        [scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
    }
    else {
        [self adjustArms];
        //[[Person sharedPerson] stop];
    }
}

- (void) updatePosition {
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    // Keep adding up the playerVelocity to the player's position
    CGPoint pos = player.position;
    pos.x += playerVelocity.x;
    
    // The Player should also be stopped from going outside the screen
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
}

- (void) updateSpeed {
    if (score==30){
        [self changeSpeed:MEDIUM];
    }
    if (score==70) {
        [self changeSpeed:FAST];
    }
}

- (void) changeSpeed : (float) x {
    [[Person sharedPerson] changeSpeed:x];
}

- (float) getSpeed {
    return [[Person sharedPerson] getSpeed];
}

- (void) adjustArms {
    
    float band = ccpDistance(leftStoppedBar.position, rightStoppedBar.position);
    float range = band/17.0;
    float currentLocation = ccpDistance(player.position, leftStoppedBar.position);
    int pictureNumber = (int)(currentLocation/range);
    if(pictureNumber > 16){
        pictureNumber=16;
    }
    [[Person sharedPerson] moveArms:[NSNumber numberWithInt:pictureNumber]];
}

- (float) sway {
    //CGSize screenSize = [[CCDirector sharedDirector] winSize];
    float adj;
    //float sensitivity=.9f;
    //float prob=.1;
    /*
     int rand = arc4random()%10;
     //int direction=arc4random()%2;
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
    float adj = [self gust];
    return adj;
}

- (float) gust {
    float windadj=0;
    float sensitivity=2.0f;
    float prob=.0125;
    
    int rand = arc4random()%1000;
    if (blowing==true){
        
    }
    
    
    if (prob*1000 >=rand || (blowing)){
        if (!blowing) {
            blowing=true;
        }
        int randdir=arc4random()%2;
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

- (void) updateTrees
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    int positionDelta = 5;
    int accelerationFactor = 380;
    
    for (CCSprite* anEnvirObj in environmentObjects) {
        //NSLog(@"x: %f, y: %f", anEnvirObj.position.x, anEnvirObj.position.y);
        
        positionDelta += screenSize.height / accelerationFactor;
        
        float newHeightPosition = anEnvirObj.position.y - positionDelta;
        if (newHeightPosition < -0.5 * screenSize.height) {
            newHeightPosition = 1.5 * screenSize.height;
        }
        
        anEnvirObj.position = CGPointMake(anEnvirObj.position.x, newHeightPosition);
    }
}

- (void) incrementScore {
    score+=10;
}

- (float) slip {
    float slipadj;
    return slipadj;
}

-(void) checkForFall: (NSString*) state
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CGPoint middle = CGPointMake(screenSize.width / 2, 0);
    float actualDistance = ccpDistance(player.position, middle);
    float stoppedBand = ccpDistance(middle, leftStoppedBar.position);
    float movingBand = ccpDistance(middle, leftMovingBar.position);
    if (fabsf(actualDistance)>=stoppedBand || ([state isEqualToString:@"walking"] && fabsf(actualDistance >= movingBand))){
        gameOver=true;
        //if (fabsf(actualDistance)>=60){
        [self gameOver];
    }
}

- (Boolean) isGameOver {
    return gameOver;
}

- (void) gameOver {
    CGSize size = [CCDirector sharedDirector].winSize;
    
    if (player.position.x-size.width/2 > 0) {
        [[Person sharedPerson] scheduleFalling:@"right"];
    }
    else {
        [[Person sharedPerson] scheduleFalling:@"left"];
    }
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
    
    label.position = CGPointMake(size.width / 2, size.height / 2);
    [self addChild:label];
    [self performSelector:@selector(changeScene:) withObject:[MainMenuLayer scene] afterDelay:3.0];
    [[HighScoreLayer sharedHighScoreLayer] submitNameToHighScore:@"TEAM G" withScore:[NSNumber numberWithInt:score]];
    
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

-(void) setUpMenus
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
	CCMenuItemImage * menuItem1 = [CCMenuItemImage itemWithNormalImage:@"main_menu_icon.png"
                                                         selectedImage: @"main_menu_icon2.png"
                                                                target:self
                                                              selector:@selector(doSomething:)];
    menuItem1.tag=1;
    
	CCMenu * myMenu = [CCMenu menuWithItems:menuItem1, nil];
    menuItem1.position = ccp(screenSize.width*.8, screenSize.height*.95);
    myMenu.position = ccp(0,0);
	[self addChild:myMenu];
}

- (void) doSomething: (CCMenuItem  *) menuItem
{
    //[self pauseSchedulerAndActionsRecursive:];
    [[CCDirector sharedDirector] pause];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    pauseBackground = [CCSprite spriteWithFile:@"pause_black.png"];
    pauseBackground.position = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    pauseBackground.opacity=190;
    [self addChild:pauseBackground z:15];
    
    CCMenuItemImage* menuItem2_1 = [CCMenuItemImage itemWithNormalImage:@"main_menu_icon.png"
                                                          selectedImage:@"main_menu_icon2.png"
                                                                 target:self
                                                               selector:@selector(goToMenuMain:)];
	CCMenuItemImage* menuItem2_2 = [CCMenuItemImage itemWithNormalImage:@"main_menu_icon.png"
                                                          selectedImage:@"main_menu_icon2.png"
                                                                 target:self
                                                               selector:@selector(resumePlay:)];
    menuItem2_1.tag=1; //go to main menu
    menuItem2_2.tag=2; //return to game
    
    myMenu2 = [CCMenu menuWithItems:menuItem2_1, menuItem2_2, nil];
    menuItem2_1.position = ccp(screenSize.width*.5, screenSize.height*.7);
    menuItem2_2.position = ccp(screenSize.width*.5, screenSize.height*.3);
    myMenu2.position = ccp(0,0);
    [self addChild:myMenu2 z:16];
}

- (void)goToMenuMain:(id)sender
{
    [[CCDirector sharedDirector] resume];
    [self changeScene:[MainMenuLayer scene]];
}

- (void)resumePlay:(id)sender
{
    [[CCDirector sharedDirector] resume];
    [self removeChild:pauseBackground];
    [self removeChild:myMenu2];
}

-(void)doSomething2: (CCMenuItem *) menuItem //1=return to mainmenu ; 2=return to game
{
    int parameter = menuItem.tag;
    
    if (parameter==1) {
        [[CCDirector sharedDirector] resume];
        [self changeScene:[MainMenuLayer scene]];
    }
    if (parameter==2){
        
        [[CCDirector sharedDirector] resume];
    }
}

-(void) changeScene: (id) layer
{
    SimpleAudioEngine* simpleAudioEngine = [SimpleAudioEngine sharedEngine];
    [simpleAudioEngine stopBackgroundMusic];
    [simpleAudioEngine unloadEffect:@"jungle.mp3"];
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