//
//  LCIntroScene.h
//  2048
//
//  Created by Lucas Cortes on 3/27/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "CCScene.h"
#import <iAd/ADBannerView.h>

@class CCSprite;
@class CCLabelTTF;
@class CCButton;

@interface LCIntroScene : CCScene <ADBannerViewDelegate>
{
        CCButton *mTogglePos;
    
    CCSprite    *_background;
    CCButton    *_playButton;
    CCButton    *_instructionsButton;
    CGSize      _screenSize;
    CCLabelTTF  *_highScoreLabel;
    NSInteger   _highScore;
}
+ (LCIntroScene *)scene;
- (id)init;
@end
