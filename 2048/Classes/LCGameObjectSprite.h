//
//  LCGameObjectNode.h
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//
#import "LCCommonProtocols.h"
#import "CCSprite.h"
@class LCBox;
@class CCLabelTTF;
@class LCPoint;

@interface LCGameObjectSprite : CCSprite
{
    LCBox       *_myBox;
    NSInteger    _myNum;
    LCPoint     *_myPos;
    BOOL         _dead;
}
+ (LCGameObjectSprite *)gameObjectSpriteWithNumber:(NSInteger)num andPositionX:(NSInteger)x andY:(NSInteger)y;
- (id)init;
- (void)setNumber:(NSInteger)num;
- (void)setPositionWithX:(NSInteger)x andY:(NSInteger)y;
- (void)changePositionToPoint:(CGPoint)point;
- (void)changePositionWithX:(NSInteger)x andY:(NSInteger)y;
- (void)fadeOut;

@property (nonatomic) LCBox *myBox;
@property (nonatomic) LCPoint *myPos;
@property (nonatomic) NSInteger myNum;
@property (nonatomic) BOOL dead;

@end
