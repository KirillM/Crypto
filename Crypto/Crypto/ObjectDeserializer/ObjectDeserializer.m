//
//  ObjectDeserializer.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "ObjectDeserializer.h"
#import "NSError+Crypto.h"
#import <PromiseKit/PromiseKit.h>
#import "CurrencyObject.h"
#import "Mapping.h"

@implementation ObjectDeserializer

- (AnyPromise *)currenciesExchangeRatesFromDictionary:(NSDictionary *)dict {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        NSMutableArray <CurrencyObject *> *exchangeRates = [NSMutableArray <CurrencyObject *> new];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *  _Nonnull exchangeInfo, BOOL * _Nonnull stop) {
            [exchangeRates addObject:[FEMDeserializer objectFromRepresentation:exchangeInfo
                                                                       mapping:[Mapping exchangeMapping]]];
        }];
        resolve(exchangeRates);
    }];
}

@end
