//
//  Logger.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Logger : NSObject

+ (NSString *)info:(NSString *)info class:(NSString *)className  method:(NSString *)methodName;

@end
