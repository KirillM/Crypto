//
//  NSError+Crypto.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "NSError+Crypto.h"
#import "NSString+Crypto.h"
#import "AFNetworking.h"
#import "Logger.h"
#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

NSString *const kErrorLevelKey = @"ErrorLevelKey";
static NSString *const kErrorBaseDomain = @"Poison";
static NSString *const ErrorDescription = @"Description";
static NSString *const ErrorLevel = @"Level";
static NSString *const ErrorDomain = @"Domain";
static NSString *const ErrorCode = @"Code";
static NSString *const ErrorUnderlying = @"Underlying";
static NSString *const ErrorFatal = @"Error";
static NSString *const ErrorWarning = @"Warning";

@implementation NSError (Crypto)

- (void)log:(NSString *)infoName method:(NSString *)methodName {
    
    NSString *info = [NSString stringWithFormat:@"(%@ | %@) : %@", infoName, methodName, [NSError parseLogError:self]];
    if ([self logLevel] == DDLogLevelWarning) {
        DDLogWarn(@"%@", info);
    } else {
        DDLogError(@"%@", info);
    }
}

- (DDLogLevel)logLevel {
    if (!self.userInfo) {
        return DDLogLevelOff;
    }
    
    NSArray *errorUserInfoKeys = [self.userInfo allKeys];
    
    if (![errorUserInfoKeys containsObject:kErrorLevelKey]) {
        return DDLogLevelOff;
    }
    
    DDLogLevel logLevel = [[self.userInfo objectForKey:kErrorLevelKey] integerValue];
    
    return logLevel;
}

+ (NSError *)errorWithDescription:(NSString * __nullable)description
                  underlyingError:(NSError * __nullable)underlyingError
                    errorTypeCode:(ErrorTypeCode)errorTypeCode
                       errorLevel:(DDLogLevel)errorLevel {
    
    NSParameterAssert(underlyingError);
    
    NSDictionary *userInfo = nil;
    
    if (!description) {
        description = [NSError descriptionForErrorType:errorTypeCode];
    }
    
    if (underlyingError) {
        userInfo = @{NSLocalizedDescriptionKey : description,
                     NSUnderlyingErrorKey : underlyingError,
                     kErrorLevelKey : @(errorLevel)};
    } else {
        userInfo = @{NSLocalizedDescriptionKey : description,
                     kErrorLevelKey : @(errorLevel)};
    }
    
    return [NSError errorWithDomain:kErrorBaseDomain code:errorTypeCode userInfo:userInfo];
}

+ (NSString *)descriptionForErrorType:(ErrorTypeCode)errorTypeCode {
    NSString *description = nil;
    switch (errorTypeCode) {
        case ErrorTypeCodeNetwork:
            description = @"Отсутствует Интернет-соединение, попробуйте обновить экран позже".localized;
            break;
        case ErrorTypeCodeServer:
            description = @"Произошла ошибка загрузки данных, попробуйте обновить экран позже".localized;
            break;
        case ErrorTypeCodeInternal:
            description = @"Произошла внутренняя загрузки данных, попробуйте обновить экран позже".localized;
            break;
    }
    return description;
}

- (ErrorTypeServerResponseCode)responseCode {
    if (self.code != ErrorTypeCodeServer) {
        return 0;
    }
    if (![[self.userInfo allKeys] containsObject:NSUnderlyingErrorKey]) {
        return 0;
    }
    
    NSError *underlyingError = self.userInfo[NSUnderlyingErrorKey];
    NSHTTPURLResponse *response = underlyingError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    NSInteger responseCode = response.statusCode;
    return responseCode;
}

+ (NSString *)parseLogError:(NSError *)error {
    NSString *errorLog =
    [NSString stringWithFormat:@" %@ : %@ | %@ : %li", ErrorDomain, error.domain, ErrorCode, (long)error.code];
    
    if (!error.userInfo) {
        return errorLog;
    }
    
    NSArray *errorUserInfoKeys = [error.userInfo allKeys];
    
    if ([errorUserInfoKeys containsObject:NSLocalizedDescriptionKey]) {
        NSString *description = [NSString stringWithFormat:@"%@ : %@", ErrorDescription,
                                 [error.userInfo objectForKey:NSLocalizedDescriptionKey]];
        errorLog = [errorLog stringByAppendingFormat:@" %@", description];
    }
    
    if ([errorUserInfoKeys containsObject:kErrorLevelKey]) {
        DDLogLevel logLevel = [[error.userInfo objectForKey:kErrorLevelKey] integerValue];
        
        NSString *errorLevelType = nil;
        if (logLevel == DDLogLevelError) {
            errorLevelType = ErrorFatal;
        } else {
            errorLevelType = ErrorWarning;
        }
        
        NSString *errorLevel = [NSString stringWithFormat:@"%@ : %@", ErrorLevel, errorLevelType];
        errorLog = [errorLog stringByAppendingFormat:@" | %@", errorLevel];
    }
    
    if ([errorUserInfoKeys containsObject:NSUnderlyingErrorKey]) {
        NSString *underlyingErrorLog =
        [NSError parseLogError:[error.userInfo objectForKey:NSUnderlyingErrorKey]];
        NSString *underlying = [NSString stringWithFormat:@"%@ : { %@", ErrorUnderlying, underlyingErrorLog];
        errorLog = [errorLog stringByAppendingFormat:@"\n\t %@ }", underlying];
    }
    
    return errorLog;
}

@end

