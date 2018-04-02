//
//  Logger.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "Logger.h"
#import "LogFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

const NSUInteger MaxLogLenght = 440;

@implementation Logger

- (instancetype)init {
    self = [super init];
    if (self) {
#if defined(DEBUG) && DEBUG
        [[DDTTYLogger sharedInstance] setLogFormatter:[[LogFormatter alloc] init]];
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
#else
        [[DDASLLogger sharedInstance] setLogFormatter:[[LogFormatter alloc] init]];
        [DDLog addLogger:[DDASLLogger sharedInstance]];
#endif
        
        DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24;             // 24 hour rolling
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:fileLogger];
    }
    return self;
}

+ (NSString *)info:(NSString *)info class:(NSString *)className  method:(NSString *)methodName {
    return [Logger substringToMaxLogLenght:[NSString stringWithFormat:@"(%@ | %@) : %@", className, methodName, info]];
}

+ (NSString *)substringToMaxLogLenght:(NSString *)info {
    if (info.length > MaxLogLenght) {
        info = [info substringToIndex:MaxLogLenght];
    }
    return info;
}

@end
