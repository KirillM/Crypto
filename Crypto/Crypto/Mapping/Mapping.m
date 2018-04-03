//
//  Mapping.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "Mapping.h"
#import "CurrencyObject.h"

@implementation Mapping

#pragma mark - Category Mapping

+ (FEMMapping *)exchangeMapping {
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:NSClassFromString(@"CurrencyObject")];
    
   // [mapping addAttributesFromArray:@[@"title", @"rating", @"icon"]];
    [mapping addAttributesFromDictionary:@{
                                           @"delay": @"15m",
                                           @"buy" : @"buy",
                                           @"last" : @"last",
                                           @"sell" : @"sell",
                                           @"symbol" : @"symbol"
                                           }];
    return mapping;
}

@end

