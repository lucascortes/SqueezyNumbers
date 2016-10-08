//
//  AppDelegate.h
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright Lucas Cortes 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "cocos2d.h"


@class MyiAd;

@interface AppDelegate : CCAppDelegate
{
    MyiAd       *mIAd;
    bool        mIsBannerOn;
    bool        mBannerOnTop;
}

@property(nonatomic, assign) bool isBannerOn;
@property(nonatomic, assign) bool isBannerOnTop;

-(void)ShowIAdBanner;
-(void)hideIAdBanner;
-(void)bannerDidFail;
-(void)setBannerOnTop;
-(void)setBannerOnBottom;
@end
