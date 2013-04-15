//
//  SlackLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "SlackLayer.h"


@implementation SlackLayer

- (id) init {
    
    if ((self = [super init]))
    {
        NSLog(@"SlackLayer Screen Called");
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [SlackLayer node];
    [scene addChild:layer];
    return scene;
}

@end
