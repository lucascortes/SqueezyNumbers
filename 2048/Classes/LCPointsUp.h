//
//  LCPointsUp.h
//  2048
//
//  Created by Lucas Cortes on 3/25/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "CCNode.h"
@class CCLabelTTF;
@interface LCPointsUp : CCNode
{
    CCLabelTTF  *_numberUp;
}
- (id)init;
- (id)initWithNumber:(NSInteger)number;
@end
