//
//  LCGameBackground.m
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCGameBackground.h"
#import "CCScene.h"

@implementation LCGameBackground
@synthesize background = _background;
- (id)init
{
    self = [super init];
    if (self) {
        _screenSize = [[CCDirector sharedDirector] viewSize];
        _background = [CCSprite spriteWithImageNamed:@"Background.png"];
        [self addChild:_background];
    }
    return self;
}

@end
