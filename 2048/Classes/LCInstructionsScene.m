//
//  LCInstructionsScene.m
//  2048
//
//  Created by Lucas Cortes on 3/27/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCInstructionsScene.h"
#import "LCIntroScene.h"
#import "cocos2d.h"
#import "CCButton.h"

@implementation LCInstructionsScene
- (id)init
{
    self = [super init];
    if (self) {
        _screenSize = [[CCDirector sharedDirector] viewSize];
        _background = [CCSprite spriteWithImageNamed:@"Instructions.png"];
        [_background setScaleX:[[UIScreen mainScreen] bounds].size.width / _background.contentSize.width];
        [_background setScaleY:[[UIScreen mainScreen] bounds].size.height /_background.contentSize.height];
        [_background setPosition:ccp(_screenSize.width/2, _screenSize.height/2)];
        [self addChild:_background];
        
        
        _backButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackActive.png"] highlightedSpriteFrame:nil disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"BackInactive.png"]];
        [_backButton setPosition:ccp(_screenSize.width*0.25, _screenSize.height*0.96f)];
        [_backButton setTarget:self selector:@selector(onBackClick:)];
        [self addChild:_backButton z:10];

    }
    return self;
}
+ (LCInstructionsScene *)scene
{
    return [[self alloc] init];
}
- (void)onBackClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LCIntroScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}
@end
