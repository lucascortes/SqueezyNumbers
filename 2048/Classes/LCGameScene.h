//
//  LCGameScene.h
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//


#import "cocos2d.h"
#import "CCScene.h"
#import "LCCommonProtocols.h"
@class CCActionAnimate;
@class CCButton;

@interface LCGameScene : CCScene
{
    CGSize              _screenSize;
    CCNodeColor         *_background;
    NSMutableArray      *_boxArray;
    NSInteger           _score;
    CCLabelTTF          *_scoreLabel;
    CCLabelTTF          *_highScoreLabel;
    NSInteger           _highScore;
    CCButton            *_resetButton;
    CCButton            *_backButton;
}

+ (LCGameScene *)scene;
- (id)init;
@end
