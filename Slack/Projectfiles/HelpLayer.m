//
//  HelpLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "HelpLayer.h"


@implementation HelpLayer

- (id) init {
    
    if ((self = [super init]))
    {
        NSLog(@"HelpLayer Screen Called");
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [HelpLayer node];
    [scene addChild:layer];
    return scene;
}

@end
