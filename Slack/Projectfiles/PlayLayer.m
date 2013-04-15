//
//  PlayLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "PlayLayer.h"


@implementation PlayLayer

- (id) init {
    
    if ((self = [super init]))
    {
        NSLog(@"PlayLayer Screen Called");
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [PlayLayer node];
    [scene addChild:layer];
    return scene;
}

@end
