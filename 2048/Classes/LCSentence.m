//
//  LCSentence.m
//  2048
//
//  Created by Lucas Cortes on 3/25/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCSentence.h"
#import "cocos2d.h"
#import "CCAnimation.h"

@implementation LCSentence

- (id)init
{
    self = [super init];
    if (self) {
        [self setPosition:ccp(0, 0)];
    }
    return self;
}

- (void)runAwesome
{
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Awesome.png"]];
    [self run];
}
- (void)runGreat
{
    [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Great.png"]];
    [self run];
}
- (void)run
{
    CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.2f];
    [self runAction:actionFadeIn];
    
    CCActionMoveBy *moveUp = [CCActionMoveBy actionWithDuration:1.0f position:ccp(0.0f, [[CCDirector sharedDirector] viewSize].height*0.4)];
    [self runAction:moveUp];

    CCActionFadeOut *actionFadeOut = [CCActionFadeOut actionWithDuration:0.3f];
    [self performSelector:@selector(runAction:) withObject:actionFadeOut afterDelay:0.6f];
}
@end
