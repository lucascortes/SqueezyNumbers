//
//  LCInstructionsScene.h
//  2048
//
//  Created by Lucas Cortes on 3/27/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "CCScene.h"
#import "CCSprite.h"
@class CCButton;

@interface LCInstructionsScene : CCScene
{
    CCSprite    *_background;
    CGSize      _screenSize;
    CCButton    *_backButton;

}
+ (LCInstructionsScene *)scene;
- (id)init;
@end
