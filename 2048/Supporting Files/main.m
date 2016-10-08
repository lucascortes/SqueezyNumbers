//
//  main.m
//  2048
//
//  Created by Lucas Cortes on 3/19/14.
//  Copyright Lucas Cortes 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    @autoreleasepool {
        #ifdef ANDROID
            [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
        #endif
        int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
        return retVal;
    }
}
