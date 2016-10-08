//
//  LCBox.h
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "CCSprite.h"
#import "LCGameScene.h"

@interface LCBox : CCSprite
{
    CGSize          _screenSize;
    NSInteger       _boxNumber;
}

- (id)init;
- (void)setNumber:(NSInteger)number;
@property (nonatomic, assign) NSInteger boxNumber;

@end