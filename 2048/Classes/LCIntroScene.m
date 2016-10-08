//
//  LCIntroScene.m
//  2048
//
//  Created by Lucas Cortes on 3/27/14.
//  Copyright (c) 2014 Lucas Cortes. All rights reserved.
//

#import "LCIntroScene.h"
#import "LCGameScene.h"
#import "LCInstructionsScene.h"
#import "CCSprite.h"
#import "cocos2d.h"
#import "CCButton.h"
#import "AppDelegate.h"
#import "LCCommonProtocols.h"

@implementation LCIntroScene
{
    AppDelegate             *app;
    NSMutableDictionary     *_myHighScoreDictionary;
    NSString                *_dictionaryFinalPath;
}

+ (LCIntroScene *)scene
{
    return [[LCIntroScene alloc] init];
}
- (id)init
{
    self = [super init];
    if (self) {
        
        _screenSize = [[CCDirector sharedDirector] viewSize];
        
        
        
        
        _background = [CCSprite spriteWithImageNamed:@"Main.png"];
        [_background setPosition:ccp(_screenSize.width/2, _screenSize.height/2)];
        [_background setScaleX:[[UIScreen mainScreen] bounds].size.width / _background.contentSize.width];
        [_background setScaleY:[[UIScreen mainScreen] bounds].size.height /_background.contentSize.height];
        [_background setPosition:ccp(_screenSize.width/2, _screenSize.height/2)];
        [self addChild:_background];
        
        app = (((AppDelegate*) [UIApplication sharedApplication].delegate));
        
        _playButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"PlayActive.png"] highlightedSpriteFrame:nil disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"PlayInactive.png"]];

        [_playButton setPosition:ccp(_screenSize.width/2, _screenSize.height*0.59f)];
        [_playButton setTarget:self selector:@selector(onPlayClick:)];
        [self addChild:_playButton z:10];
        
        #ifdef FREEVERSION
            int waitingTime = 5;
            [self performSelector:@selector(makePlayButtonUnactive) withObject:nil afterDelay:0.0f];
            [self performSelector:@selector(makePlayButtonActive) withObject:nil afterDelay:waitingTime];
            
            CCLabelTTF *waitingLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Waiting...: %i",waitingTime] fontName:@"AmericanTypewriter-Bold" fontSize:_screenSize.height*0.02f];
            [waitingLabel setPosition:ccp(_screenSize.width/2.0f, _screenSize.height*0.54f)];
            [waitingLabel setColor:[CCColor whiteColor]];
            [self addChild:waitingLabel];
            for (int i = waitingTime; i>=0; i--) {
                [waitingLabel performSelector:@selector(setString:) withObject:[NSString stringWithFormat:@"Waiting...: %i",i] afterDelay:(float)waitingTime-i];
            }
            [self performSelector:@selector(removeChild:) withObject:waitingLabel afterDelay:waitingTime+1];
            
            
            CCLabelTTF *supportDeveloper = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"If you like this app please support the developer and buy the full version"] fontName:@"AmericanTypewriter-Bold" fontSize:_screenSize.height*0.016f dimensions:CGSizeMake(_screenSize.width*0.6, 50.0f)];
            [supportDeveloper setHorizontalAlignment:CCTextAlignmentCenter];

            [supportDeveloper setPosition:ccp(_screenSize.width/2.0f, _screenSize.height*0.23f)];
            [supportDeveloper setColor:[CCColor whiteColor]];
            [self addChild:supportDeveloper];
        #endif
        
        _instructionsButton = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"InstructionsActive.png"] highlightedSpriteFrame:nil disabledSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"InstructionsInactive.png"]];
        [_instructionsButton setPosition:ccp(_screenSize.width/2, _screenSize.height*0.47f)];
        [_instructionsButton setTarget:self selector:@selector(onInstructionsClick:)];
        [self addChild:_instructionsButton z:10];
        
        
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
        
        _highScoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"HIGH SCORE: %li",(long)_highScore] fontName:@"AmericanTypewriter-Bold" fontSize:_screenSize.height*0.03f];
        [_highScoreLabel setPosition:ccp(_screenSize.width/2.0f, _screenSize.height*0.3f)];

        [_highScoreLabel setColor:[CCColor whiteColor]];
        [self addChild:_highScoreLabel];
        
        
        app.isBannerOnTop = false;
        [app performSelector:@selector(ShowIAdBanner) withObject:nil afterDelay:1.0f];
    }
    return self;
}

- (void)onPlayClick:(id)sender
{
    [app performSelector:@selector(hideIAdBanner) withObject:nil afterDelay:0.0f];
    [app performSelector:@selector(setBannerOnTop) withObject:nil afterDelay:0.0f];
    [[CCDirector sharedDirector] replaceScene:[LCGameScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}
- (void)onInstructionsClick:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[LCInstructionsScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5f]];
}



-(void)toggleBannerPos:(id)sender
{
    if(app.isBannerOnTop)
    {
        app.isBannerOnTop = false;
        mTogglePos.title = @"Banner On Bottom";
    }
    else
    {
        app.isBannerOnTop = true;
        mTogglePos.title = @"Banner On Top";
    }
    
}

- (void)makePlayButtonUnactive
{
    self->_playButton.enabled = NO;
}
- (void)makePlayButtonActive
{
    self->_playButton.enabled = YES;
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)showBannerAd:(id)sender
{
    mTogglePos.visible=false;
    [app ShowIAdBanner];
    
}

- (void)hideBannerAd:(id)sender
{
    mTogglePos.visible=true;    
    [app hideIAdBanner];
}


@end
