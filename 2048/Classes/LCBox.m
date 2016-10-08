//
//  LCBox.m
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCBox.h"
@implementation LCBox
@synthesize boxNumber = _boxNumber;

- (id)init
{
    self = [super init];
    if (self) {
        //CCLOG(@"LCBox inited");
        [self setPosition:ccp(0.0f, 0.0f)];
        _boxNumber = 0;        
        _screenSize = [[CCDirector sharedDirector] viewSize];
    }
    return self;
}

- (void)setNumber:(NSInteger)number
{
    _boxNumber = number;
    for (int i = 1; i<=11; i++) {
        if (number == pow(2, i)) {
            self.spriteFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"Box%li.png",(long)number]];
        }
    }
    
}
@end
