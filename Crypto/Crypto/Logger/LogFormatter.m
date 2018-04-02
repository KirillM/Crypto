//
//  LogFormatter.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "LogFormatter.h"

@implementation LogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError:
            logLevel = @"E";
            break;
        case DDLogFlagWarning:
            logLevel = @"W";
            break;
        case DDLogFlagInfo:
            logLevel = @"I";
            break;
        case DDLogFlagDebug:
            logLevel = @"D";
            break;
        default:
            logLevel = @"V";
            break;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSS'"];
    });
    
    return [NSString stringWithFormat:@"%@ | %@ %@", logLevel, [dateFormatter stringFromDate:logMessage.timestamp],
            logMessage.message];
}

@end
