//
//  NSError+Crypto.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const kErrorLevelKey;

typedef NS_ENUM (NSUInteger, ErrorTypeCode) {
    ErrorTypeCodeNetwork    = 0,
    ErrorTypeCodeServer     = 1,
    ErrorTypeCodeInternal   = 2
};

/** Код ответа серверной ошибки */

typedef NS_ENUM (NSUInteger, ErrorTypeServerResponseCode) {
    ErrorTypeServerResponseCodeWrongRequest   = 400,
    ErrorTypeServerResponseCodeTimeExpired    = 403,
    ErrorTypeServerResponseCodeNotAcceptable  = 406,
    ErrorTypeServerResponseCodeServerInternal = 500
};


@interface NSError (Crypto)

+ (NSError *)errorWithDescription:(NSString * __nullable)description
                  underlyingError:(NSError * __nullable)underlyingError
                    errorTypeCode:(ErrorTypeCode)errorTypeCode
                       errorLevel:(DDLogLevel)errorLevel;

- (void)log:(NSString *)infoName method:(NSString *)methodName;
- (ErrorTypeServerResponseCode)responseCode;

@end

NS_ASSUME_NONNULL_END
