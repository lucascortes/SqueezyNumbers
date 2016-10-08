//
//  LCPointsUp.m
//  2048
//
//  Created by Lucas Cortes on 3/25/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCPointsUp.h"
#import "cocos2d.h"

@implementation LCPointsUp
- (id)init
{
    return [self initWithNumber:2];
}

- (id)initWithNumber:(NSInteger)number
{
    if (self = [super init]) {
        
       if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
           _numberUp = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%li",(long)number] fontName:@"Verdana-Bold" fontSize:50.0f];
       }else{
           _numberUp = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%li",(long)number] fontName:@"Verdana-Bold" fontSize:25.0f];
       }
        _numberUp.positionType = CCPositionTypeNormalized;
        _numberUp.color = [CCColor redColor];
        _numberUp.position = ccp(0.0f, 0.0f);
        [self addChild:_numberUp];
        [self runMotion];
    }
    return self;
}

- (void)runMotion
{
    CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.2f];
    [self runAction:actionFadeIn];
    
    CCActionMoveBy *moveUp = [CCActionMoveBy actionWithDuration:0.6f position:ccp(0.0f, 80.0f)];
    [self runAction:moveUp];
    
    CCActionFadeOut *actionFadeOut = [CCActionFadeOut actionWithDuration:0.2f];
    [self performSelector:@selector(runAction:) withObject:actionFadeOut afterDelay:0.4f];

}
@end
