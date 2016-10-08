//
//  LCPoint.h
//  2048
//
//  Created by Lucas Cortes on 3/20/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPoint : NSObject
{
    NSInteger   _x;
    NSInteger   _y;
    CGPoint     _coord;
}

- (id)init;
- (id)initWithX:(NSInteger)x andY:(NSInteger)y;
- (CGPoint)coordForX:(NSInteger)x andY:(NSInteger)y;
- (CGPoint)coord;

@property (nonatomic) NSInteger x;
@property (nonatomic) NSInteger y;

@end
