//
//  NSString+Crypto.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "NSString+Crypto.h"

@implementation NSString (Crypto)

- (NSString *)localized {
    return NSLocalizedString(self, nil);
}

+ (NSString *)priceCategoryString:(NSInteger)priceCategory {
    NSString *priceCategoryString = [[NSString string] stringByPaddingToLength:(priceCategory) withString: @"₽".localized startingAtIndex: 0];
    return priceCategoryString;
}

@end
