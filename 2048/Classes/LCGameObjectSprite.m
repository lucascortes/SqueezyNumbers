//
//  LCGameObjectSprite.m
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCGameObjectSprite.h"
#import "LCBox.h"
#import "LCPoint.h"
#import "LCGameScene.h"

@implementation LCGameObjectSprite
@synthesize myBox = _myBox;
@synthesize myPos = _myPos;
@synthesize myNum = _myNum;
@synthesize dead = _dead;

- (id)init
{
    self = [super init];
    if (self) {
        //CCLOG(@"LCGameObjectSprite inited");
        _myBox = [[LCBox alloc] init];
        _myNum = 0;
        _myPos = [[LCPoint alloc] init];
        _dead = NO;
        [self addChild:_myBox];
    }
    return self;
}

+ (LCGameObjectSprite *)gameObjectSpriteWithNumber:(NSInteger)num andPositionX:(NSInteger)x andY:(NSInteger)y
{
    LCGameObjectSprite *obj = [[LCGameObjectSprite alloc] init];
    [obj setNumber:num];
    [obj setPositionWithX:x andY:y];
    [obj setDead:NO];
    return obj;
}

- (void)changePositionWithX:(NSInteger)x andY:(NSInteger)y
{
    _myPos.x = x;
    _myPos.y = y;
    CCActionMoveTo *actionMoveTo = [CCActionMoveTo actionWithDuration:0.18f position:[_myPos coord]];
    [_myBox performSelector:@selector(runAction:) withObject:actionMoveTo afterDelay:0.0f];

    //[_myBox runAction:actionMoveTo];
}

- (void)changePositionToPoint:(CGPoint)point
{
    [self changePositionWithX:point.x andY:point.y];
}

- (void)setNumber:(NSInteger)num
{
    [_myBox setNumber:num];
    _myNum = num;
}

- (void)setPositionWithX:(NSInteger)x andY:(NSInteger)y
{
    _myPos = [[LCPoint alloc] initWithX:x andY:y];
    [_myBox setPosition:[_myPos coord]];
    
    CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.3f];
    [_myBox runAction:actionFadeIn];
}

- (void)fadeOut
{  
    CCActionFadeOut *actionFadeOut = [CCActionFadeOut actionWithDuration:0.3f];
    [_myBox performSelector:@selector(runAction:) withObject:actionFadeOut afterDelay:0.18f];

    
    CCActionScaleTo *actionScale = [CCActionScaleTo actionWithDuration:0.4f scale:0.0f];
    [_myBox performSelector:@selector(runAction:) withObject:actionScale afterDelay:0.0f];
}
@end
