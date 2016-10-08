//
//  LCGameBackground.h
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "CCNode.h"
#import "cocos2d.h"

@interface LCGameBackground : CCNode
{
    CCSprite *_background;
    CGSize   _screenSize;
}

- (id)init;
@property (nonatomic) CCSprite *background;
@end
