//
//  LCExplodingObject.m
//  2048
//
//  Created by Lucas Cortes on 3/24/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCExplodingObject.h"
#import "cocos2d.h"
#import "CCAnimation.h"

@implementation LCExplodingObject
{
    NSMutableArray *_explotionFrames;
    CCAnimation *_animation;
    CCActionAnimate *_explosion;
}
- (id)init
{
    self = [super init];
    if (self) {
        
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"EffectFadeOut-1.png"]];
        [self setPosition:ccp(0,0)];
        [self setScale:1];
        
    
        _explotionFrames = [NSMutableArray array];
        for (int i=1; i<=13; i++) {
            [_explotionFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"EffectFadeOut-%i.png",i]]];
        }
        _animation = [CCAnimation animationWithSpriteFrames:_explotionFrames delay:0.035f];
        _explosion = [CCActionAnimate actionWithAnimation:_animation];
        
    }
    return self;
}

- (void)run
{
    [self runAction:_explosion];
}

@end
