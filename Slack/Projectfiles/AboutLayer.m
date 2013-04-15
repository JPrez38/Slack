//
//  AboutLayer.m
//  Slack
//
//  Created by Jacob Preston on 4/14/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "AboutLayer.h"


@implementation AboutLayer

- (id) init {
    
    if ((self = [super init]))
    {
        NSLog(@"About Screen Called");
    }
    return self;
}

+ (id) scene {
    CCScene *scene = [CCScene node];
    CCLayer* layer = [AboutLayer node];
    [scene addChild:layer];
    return scene;
}

@end
