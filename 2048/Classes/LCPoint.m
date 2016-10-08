//
//  LCPoint.m
//  2048
//
//  Created by Lucas Cortes on 3/20/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCPoint.h"
#import "cocos2d.h"
@implementation LCPoint
{
    CGPoint initialPoint;
    NSInteger incrementX;
    NSInteger incrementY;
    CGSize screenSize;
}
@synthesize x=_x,y=_y;

- (id)initWithX:(NSInteger)x andY:(NSInteger)y
{
    self = [super init];
    if (self) {
        screenSize = [[UIScreen mainScreen] bounds].size;
        _x = x;
        _y = y;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            // iPad
            initialPoint = ccp(127.0f, 802.0f);
            incrementX = 171.0f;
            incrementY = 171.0f;
        }else{
            if ([[CCDirector sharedDirector] viewSize].height == 568) {
                // iPhone 5
                initialPoint = ccp(55.0f, 410.0f);
                incrementX = screenSize.width*0.223f;
                incrementY = screenSize.height*0.125f;
            }else{
                // Previous iPhones
                initialPoint = ccp(screenSize.width*0.176f, screenSize.height*0.755f);
                incrementX = screenSize.width*0.223f;
                incrementY = screenSize.height*0.149f;
            }
        }
        _coord = [self coord];
    }
    return self;
}

- (id)init
{
    return [self initWithX:0 andY:0];
}

- (CGPoint)coordForX:(NSInteger)x andY:(NSInteger)y
{
    _x=x;
    _y=y;
    return [self coord];
}

- (CGPoint)coord
{
    _coord = ccp(initialPoint.x + _x*incrementX, initialPoint.y - _y*incrementY);
    return _coord;
}
@end



