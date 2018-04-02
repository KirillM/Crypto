//
//  NSString+Crypto.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Crypto)

- (NSString *)localized;
+ (NSString *)priceCategoryString:(NSInteger)priceCategory;

@end
