//
//  LCGameScene.m
//
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#include <stdlib.h>
#import "AppDelegate.h"

//My Classes
#import "LCCommonProtocols.h"
#import "LCGameScene.h"
#import "LCBox.h"
#import "LCGameObjectSprite.h"
#import "LCGameBackground.h"
#import "LCPoint.h"
#import "LCExplodingObject.h"
#import "LCSentence.h"
#import "LCPointsUp.h"
#import "LCIntroScene.h"

//Cocos2d Classes
#import "cocos2d.h"
#import "CCAnimation.h"
#import "CCTexture.h"
#import "CCButton.h"


@implementation LCGameScene
{
    //instance variables
    
    CGPoint                  _touchCoord;
    CCSprite                *_gameOver;
    CCSprite                *_youWin;
    
    LCPoint                 *_auxPoint;
    LCGameObjectSprite      *_auxGON;
    BOOL                     _canSwipe;
    
    CCSpriteBatchNode       *_spriteSheet;
    NSMutableDictionary     *_myHighScoreDictionary;
    NSString                *_dictionaryFinalPath;
    
    BOOL                     _gameEnded;
    AppDelegate             *app;
}

#pragma mark Initial Setup

+ (LCGameScene *)scene
{
    return [[LCGameScene alloc] init];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        #ifdef ANDROID
            UISystemInterfaceVisibilityStyle style = UISystemInterfaceVisibilityStyleLowProfile;
            [UIApplication sharedApplication].systemInterfaceVisibilityStyle = style;
        #endif
        
        self.userInteractionEnabled = YES;
        _auxPoint = [[LCPoint alloc] init];
        _screenSize = [UIScreen mainScreen].bounds.size;
        _score = 0;
        _gameEnded = NO;
        _canSwipe = YES;
        
        
        //Set Background img
        LCGameBackground *background = [[LCGameBackground alloc] init];
        [background setPosition:ccp(_screenSize.width/2, _screenSize.height/2)];
        [background setScaleX:[UIScreen mainScreen].bounds.size.width / background.background.contentSize.width];
        [background setScaleY:[UIScreen mainScreen].bounds.size.height / background.background.contentSize.height];
        [self addChild:background];

        app = (((AppDelegate*) [UIApplication sharedApplication].delegate));
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"spriteSheet.plist"];
        _spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"spriteSheet.png"];
        [self addChild:_spriteSheet];
        
        
        _resetButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"Reset.png"] highlightedSpriteFrame:nil disabledSpriteFrame:nil];
        [_resetButton setPosition:ccp(_screenSize.width*0.84, _screenSize.height*0.97f)];
        [_resetButton setTarget:self selector:@selector(onResetClick:)];
        [self addChild:_resetButton z:10];
        
        _backButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"back.png"] highlightedSpriteFrame:nil disabledSpriteFrame:nil];
        [_backButton setPosition:ccp(_screenSize.width*0.16, _screenSize.height*0.97f)];
        [_backButton setTarget:self selector:@selector(onBackClick:)];
        [self addChild:_backButton z:10];

        
        
        _boxArray = [[NSMutableArray alloc] init];
        [self newBox];
        [self newBox];
        
        
        //----- Scores ------
        
        _dictionaryFinalPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _dictionaryFinalPath = [_dictionaryFinalPath stringByAppendingPathComponent:@"highScores.plist"];
        
        // If the file doesn't exist in the Documents Folder, copy it.
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:_dictionaryFinalPath]) {
            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"highScores" ofType:@"plist"];
            [fileManager copyItemAtPath:sourcePath toPath:_dictionaryFinalPath error:nil];
        }
        
        // Load the Property List.
        _myHighScoreDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:_dictionaryFinalPath];
        _highScore = [[_myHighScoreDictionary objectForKey:@"HighScore"] intValue];

        
        
        

         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
             _scoreLabel = [CCLabelTTF labelWithString:@"SCORE: 0" fontName:@"AmericanTypewriter-Bold" fontSize:40];
             [_scoreLabel setPosition:ccp(150.0f, 60.0f)];
             
             _highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"BEST: %li",(long)_highScore] fontName:@"AmericanTypewriter-Bold" fontSize:40];
             [_highScoreLabel setPosition:ccp(570.0f, 60.0f)];

         }else{
             _scoreLabel = [CCLabelTTF labelWithString:@"SCORE: 0" fontName:@"AmericanTypewriter-Bold" fontSize:20];
             [_scoreLabel setPosition:ccp(85.0f, 30.0f)];
             
             _highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"BEST: %li",(long)_highScore] fontName:@"AmericanTypewriter-Bold" fontSize:20];
             [_highScoreLabel setPosition:ccp(237.0f, 30.0f)];

         }

        
        [_scoreLabel setColor:[CCColor whiteColor]];
        [_highScoreLabel setColor:[CCColor whiteColor]];
        [self addChild:_scoreLabel];
        [self addChild:_highScoreLabel];
        
        
    }
    return self;
}

#pragma mark Touch Handling

// ---------- Touch Handling -----------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    if (_gameEnded) {
        
        CGPoint finalTouchCoord = [touch locationInNode:self];
        if (finalTouchCoord.x > _screenSize.width*0.219 && finalTouchCoord.x < _screenSize.width *0.81) {
            if (finalTouchCoord.y < _screenSize.height*0.55 && finalTouchCoord.y > _screenSize.height *0.48){
                //Play again
                _gameEnded = NO;
                [self onResetClick:self];
                CCActionFadeOut *actionFadeOut = [CCActionFadeOut actionWithDuration:0.3f];
                [_gameOver runAction:actionFadeOut];
                [self removeChild:_gameOver];
                [self removeChild:_youWin];
                [app performSelector:@selector(hideIAdBanner) withObject:nil afterDelay:0.0f];
            }
            if(finalTouchCoord.y < _screenSize.height*0.45 && finalTouchCoord.y > _screenSize.height*0.37){
                //Main Menu
                [app performSelector:@selector(setBannerOnTop) withObject:nil afterDelay:0.0f];
                [app performSelector:@selector(hideIAdBanner) withObject:nil afterDelay:0.0f];
                [app performSelector:@selector(setBannerOnBottom) withObject:nil afterDelay:0.3f];
                [app performSelector:@selector(ShowIAdBanner) withObject:nil afterDelay:0.5f];
                [[CCDirector sharedDirector] replaceScene:[LCIntroScene scene]
                                           withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
            }
        }
    }else{
        _touchCoord = [touch locationInNode:self];
    }
    
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint endTouch = [touch locationInNode:self];
    float difX = endTouch.x - _touchCoord.x;
    float difY = endTouch.y - _touchCoord.y;
    if (!(_touchCoord.x==0.0f && _touchCoord.y==0.0f) && (abs(difX)>45.0f || abs(difY)>45.0f)) {
        if (abs(difX) > abs(difY)) {
            if (endTouch.x > _touchCoord.x) {
                [self swipeRight];
            }else if(endTouch.x < _touchCoord.x){
                [self swipeLeft];
            }
        }else{
            if (endTouch.y > _touchCoord.y) {
                [self swipeUp];
            }else{
                [self swipeDown];
            }
        }
    }
    _touchCoord.x = 0.0f;
    _touchCoord.y = 0.0f;
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    _touchCoord.x = 0.0f;
    _touchCoord.y = 0.0f;
}

#pragma mark Swipes

// -------- Swipes --------


- (void)swipeRight
{
    [self swipeWithDirection:SwipeRight];
}

- (void)swipeLeft
{
    [self swipeWithDirection:SwipeLeft];
}

- (void)swipeUp
{
    [self swipeWithDirection:SwipeUp];
}

- (void)swipeDown
{
    [self swipeWithDirection:SwipeDown];
}

#pragma mark Game Logic

//-------- GAME LOGIC ----------

- (void)allowSwipes
{
    _canSwipe = YES;
}

- (void)allowUserInteraction
{
    self.userInteractionEnabled = YES;
}

- (void)swipeWithDirection:(SwipeDirection)direction
{
    if (!_canSwipe) {
        return;
    }
    _canSwipe = NO;
    [self performSelector:@selector(allowSwipes) withObject:nil afterDelay:0.21f];
    if (![self thereIsSpaceinDirection:direction]) {
        return;
    }
    
    bool kills[4]= {false,false,false,false};
    int initialValue,iterationChange,limit;
    NSInteger coordA, coordB;
    
    if (direction == SwipeLeft || direction == SwipeUp) {
        initialValue=0;
        iterationChange = 1;
        limit = 4;
    }else{
        initialValue=3;
        iterationChange = -1;
        limit = -1;
    }
    
    for (int iterator=initialValue; iterator!=limit; iterator+=iterationChange) {
        for (_auxGON in _boxArray){
            //Giro el recuadro para analizar casos verticales.
            if (direction== SwipeUp || direction == SwipeDown) {
                coordA = _auxGON.myPos.y;
                coordB = _auxGON.myPos.x;
            }else{
                coordA = _auxGON.myPos.x;
                coordB = _auxGON.myPos.y;
            }
            if ((!_auxGON.dead) && coordA==iterator){
                //No mata
                if (!kills[coordB]) {
                    //Es matado
                    if ([self canBeKilledBox:_auxGON withSwipeDirection:direction]){
                        kills[coordB]=true;
                        _auxGON.dead = YES;
                        continue;
                    }else{
                        //No es matado
                        [_auxGON changePositionToPoint:[self finalPositionforBox:_auxGON withSwipeDirection:direction]];
                        continue;
                    }
                }else{
                    //mata
                    [_auxGON setNumber:[_auxGON myNum]*2];
                    [_auxGON changePositionToPoint:[self finalPositionforBox:_auxGON withSwipeDirection:direction]];
                    kills[coordB]=false;
                    if ([_auxGON myNum]==2048) {
                        self.userInteractionEnabled = NO;
                        [self performSelector:@selector(allowUserInteraction) withObject:nil afterDelay:0.8f];
                        
                        _youWin = [CCSprite spriteWithImageNamed:@"Win.png"];
                        [_youWin setPosition:ccp(_screenSize.width/2, _screenSize.height/2)];
                        [_youWin setScaleX:[UIScreen mainScreen].bounds.size.width / _youWin.contentSize.width];
                        [_youWin setScaleY:[UIScreen mainScreen].bounds.size.height / _youWin.contentSize.height];

                        
                        CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.3f];
                        [_youWin performSelector:@selector(runAction:) withObject:actionFadeIn afterDelay:0.7f];
                        [self performSelector:@selector(addEndGameScreen:) withObject:_youWin afterDelay:1.0f];
                        
                        [app performSelector:@selector(ShowIAdBanner) withObject:nil afterDelay:0.0f];
                        
                        _gameEnded = YES;
                    }
                    continue;
                }
            }
        }
    }
    
    [self removeDead];
    [self newBox];
    [_scoreLabel setString:[NSString stringWithFormat:@"SCORE: %li",(long)_score]];
    if (_highScore < _score) {
        _highScore = _score;
        [_myHighScoreDictionary setValue:[NSNumber numberWithInt:(int)_highScore] forKey:@"HighScore"];
        [_myHighScoreDictionary writeToFile:_dictionaryFinalPath atomically:YES];
        [_highScoreLabel setString:[NSString stringWithFormat:@"BEST: %li",(long)_highScore]];
    }
}

- (void)newBox
{
    NSInteger a,b;
    BOOL existBoxInPosition = YES;
    while (existBoxInPosition) {
        existBoxInPosition = NO;
        a = arc4random() % 4;
        b = arc4random() % 4;
        for (_auxGON in _boxArray){
            if ([_auxGON myPos].x == a && [_auxGON myPos].y == b ) {
                existBoxInPosition = YES;
            }
        }
        if (!existBoxInPosition) {
            LCGameObjectSprite *box = [LCGameObjectSprite gameObjectSpriteWithNumber:2 andPositionX:a andY:b];
            [_boxArray addObject:box];
            [_spriteSheet performSelector:@selector(addChild:) withObject:box afterDelay:0.14f];
        }
    }
    
    if ([_boxArray count]==16 && ![self thereIsSpaceInAnyDirection]) {
        self.userInteractionEnabled = NO;
        [self performSelector:@selector(allowUserInteraction) withObject:nil afterDelay:0.8f];
        _gameOver = [CCSprite spriteWithImageNamed:@"GameOver.png"];
        [_gameOver setPosition:ccp(_screenSize.width/2, _screenSize.height/2)];
        [_gameOver setScaleX:[UIScreen mainScreen].bounds.size.width / _gameOver.contentSize.width];
        [_gameOver setScaleY:[UIScreen mainScreen].bounds.size.height / _gameOver.contentSize.height];
        
        CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.6f];
        [_gameOver performSelector:@selector(runAction:) withObject:actionFadeIn afterDelay:0.5f];
        [self performSelector:@selector(addEndGameScreen:) withObject:_gameOver afterDelay:1.0f];
        [self performSelector:@selector(showSupportDeveloperLabel) withObject:nil afterDelay:1.0f];
        _gameEnded = YES;
        
        
        [app performSelector:@selector(setBannerOnTop) withObject:nil afterDelay:0.0f];
        [app performSelector:@selector(ShowIAdBanner) withObject:nil afterDelay:1.0f];


        return;
    }
}

- (void)addEndGameScreen:(CCSprite *)sprite
{
    [self addChild:sprite z:100];
}

- (BOOL)thereIsSpaceInAnyDirection
{
    for (int i =0; i<4; i++) {
        if ([self thereIsSpaceinDirection:i]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (BOOL)thereIsSpaceinDirection:(SwipeDirection)swipe
{
    for (_auxGON in _boxArray){
        LCPoint *posActual = _auxGON.myPos;
        CGPoint posFutura =[self finalPositionforBox:_auxGON withSwipeDirection:swipe];
        if (posActual.x != posFutura.x || posActual.y != posFutura.y || [self canBeKilledBox:_auxGON withSwipeDirection:swipe]) {
            return TRUE;
        }
    }
    return FALSE;
}

- (CGPoint)finalPositionforBox:(LCGameObjectSprite *)movingBox withSwipeDirection:(SwipeDirection)swipe
{
    NSInteger movingBoxCoordA, movingBoxCoordB,boxCoordA,boxCoordB;
    if (swipe== SwipeUp || swipe == SwipeDown) {
        movingBoxCoordA = movingBox.myPos.y;
        movingBoxCoordB = movingBox.myPos.x;
    }else{
        movingBoxCoordA = movingBox.myPos.x;
        movingBoxCoordB = movingBox.myPos.y;
    }
    
    NSInteger res;
    if (swipe == SwipeRight || swipe == SwipeDown) {
        res = 3;
    }else if(swipe == SwipeLeft || swipe == SwipeUp){
        res = 0;
    }
    
    for (LCGameObjectSprite *box in _boxArray){
        if (swipe==SwipeUp || swipe==SwipeDown) {
            boxCoordA = box.myPos.y;
            boxCoordB = box.myPos.x;
        }else{
            boxCoordA = box.myPos.x;
            boxCoordB = box.myPos.y;
        }
        if ((!box.dead) && boxCoordB==movingBoxCoordB) {
            if ((swipe == SwipeRight || swipe == SwipeDown) && movingBoxCoordA<boxCoordA) {
                res--;
            }else if((swipe == SwipeLeft || swipe == SwipeUp) && movingBoxCoordA>boxCoordA){
                res++;
            }
        }
    }
    if (swipe == SwipeRight || swipe == SwipeLeft) {
        return ccp(res, movingBox.myPos.y);
    }else if(swipe == SwipeDown || swipe == SwipeUp){
        return ccp(movingBox.myPos.x, res);
    }
    return ccp(0, 0);
}

- (BOOL)canBeKilledBox:(LCGameObjectSprite *)afraidBox withSwipeDirection:(SwipeDirection)swipe
{
    NSInteger afraidBoxCoordA, afraidBoxCoordB,boxIteratorCoordA,boxIteratorCoordB;
    if (swipe== SwipeUp || swipe == SwipeDown) {
        afraidBoxCoordA = afraidBox.myPos.y;
        afraidBoxCoordB = afraidBox.myPos.x;
    }else{
        afraidBoxCoordA = afraidBox.myPos.x;
        afraidBoxCoordB = afraidBox.myPos.y;
    }
    
    int iterationChange,limit;
    if (swipe == SwipeLeft || swipe == SwipeUp) {
        iterationChange = 1;
        limit = 4;
    }else{
        iterationChange = -1;
        limit = -1;
    }
    
    for (NSInteger i=afraidBoxCoordA+iterationChange; i!=limit; i+=iterationChange) {
        for (LCGameObjectSprite *boxIterator in _boxArray){
            if (swipe== SwipeUp || swipe == SwipeDown) {
                boxIteratorCoordA = boxIterator.myPos.y;
                boxIteratorCoordB = boxIterator.myPos.x;
            }else{
                boxIteratorCoordA = boxIterator.myPos.x;
                boxIteratorCoordB = boxIterator.myPos.y;
            }
            if ((!boxIterator.dead) && boxIteratorCoordB==afraidBoxCoordB && boxIteratorCoordA==i) {
                if ([afraidBox myNum] == [boxIterator myNum]) {
                    return YES;
                }
                return NO;
            }
        }
    }
    return NO;
}


- (void)removeDead
{
    NSMutableArray *itemsAEliminar = [[NSMutableArray alloc] init];
    NSInteger auxScore=0;
    
    for (NSInteger i = 0; i < [_boxArray count]; ++i) {
        if (((LCGameObjectSprite *)[_boxArray objectAtIndex:i]).dead) {
            [itemsAEliminar addObject:[NSNumber numberWithInteger:i]];
        }
    }
    for (NSInteger i=[itemsAEliminar count]-1; i>=0 ; i--) {
        _auxGON = [_boxArray objectAtIndex:[[itemsAEliminar objectAtIndex:i] intValue]];
        
        LCExplodingObject *_explodingObject = [[LCExplodingObject alloc] init];
        [_explodingObject setPosition:[[_auxGON myPos] coord]];
        [_explodingObject run];
        [_spriteSheet addChild:_explodingObject z:10];
        
        LCPointsUp *pointsUp = [[LCPointsUp alloc] initWithNumber:[_auxGON myNum]*2];
        [pointsUp setPosition:[[_auxGON myPos] coord]];
        [self addChild:pointsUp z:50];
        auxScore += [_auxGON myNum]*2;
        
        [_auxGON fadeOut];
        [_spriteSheet performSelector:@selector(removeChild:) withObject:_auxGON afterDelay:0.5f];
        [_spriteSheet performSelector:@selector(removeChild:) withObject:_explodingObject afterDelay:0.6f];
        [self performSelector:@selector(removeChild:) withObject:pointsUp afterDelay:0.6f];
        [_boxArray removeObjectAtIndex:[[itemsAEliminar objectAtIndex:i] intValue]];
    }
    
    _score += auxScore;
    
    LCSentence *mySentence = [[LCSentence alloc] init];
    [mySentence setPosition:ccp(_screenSize.width/2, _screenSize.height*0.4)];

    if ([itemsAEliminar count]>=3) {
        [mySentence runAwesome];
    }else if([itemsAEliminar count]==2){
        [mySentence runGreat];
    }
    [_spriteSheet addChild:mySentence z:20];
    [_spriteSheet performSelector:@selector(removeChild:) withObject:mySentence afterDelay:0.8f];

}

- (void)onResetClick:(id)sender
{
    _score = 0;
    [_scoreLabel setString:[NSString stringWithFormat:@"SCORE: %li",(long)_score]];
    for (NSInteger i=[_boxArray count]-1; i>=0 ; i--) {
        _auxGON = [_boxArray objectAtIndex:i];
        [_auxGON fadeOut];
        [_spriteSheet performSelector:@selector(removeChild:) withObject:_auxGON afterDelay:0.5f];
        [_boxArray removeObjectAtIndex:i];
        
    }
    [self newBox];
    [self newBox];
}


- (void)onBackClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LCIntroScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}

- (void)showSupportDeveloperLabel
{
    #ifdef FREEVERSION
        CCLabelTTF *supportDeveloper = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"If you like this app please support the developer and buy the full version"] fontName:@"AmericanTypewriter-Bold" fontSize:_screenSize.height*0.018f dimensions:CGSizeMake(_screenSize.width*0.6, 50.0f)];
        [supportDeveloper setHorizontalAlignment:CCTextAlignmentCenter];
        
        [supportDeveloper setPosition:ccp(_screenSize.width/2.0f, _screenSize.height*0.25f)];
        [supportDeveloper setColor:[CCColor whiteColor]];
    
    
    CCActionFadeIn *actionFadeIn = [CCActionFadeIn actionWithDuration:0.5f];
    [supportDeveloper performSelector:@selector(runAction:) withObject:actionFadeIn afterDelay:0.5f];
    [self performSelector:@selector(addChild:) withObject:supportDeveloper afterDelay:0.5f];
    [supportDeveloper setZOrder:150];
    #endif
    return;
}


@end




