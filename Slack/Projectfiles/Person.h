//
//  Person.h
//  Slack
//
//  Created by Jacob Preston on 5/1/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Person : CCSprite {
    CCSprite* lowerbody;
    CCSprite* upperbody;
    int count;
    CCAction* myAction;
    CGSize screenSize;
    
}


+ (id) person;
+(Person*) sharedPerson;
- (void) walk;

@end
