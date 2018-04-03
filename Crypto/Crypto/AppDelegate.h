//
//  AppDelegate.h
//  Crypto
//
//  Created by Kirill Mezrin on 31/03/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

#define LOG_LEVEL_DEF ddLogLevel
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

