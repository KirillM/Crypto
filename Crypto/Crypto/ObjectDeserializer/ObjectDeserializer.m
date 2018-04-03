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
        [dict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSDictionary *  _Nonnull exchangeInfo, BOOL * _Nonnull stop) {
            NSMutableDictionary *exchangeInfoWithName = [NSMutableDictionary dictionaryWithDictionary:exchangeInfo];
            [exchangeInfoWithName setObject:key forKey:@"name"];
            [exchangeRates addObject:[FEMDeserializer objectFromRepresentation:exchangeInfoWithName
                                                                       mapping:[Mapping exchangeMapping]]];
        }];
        if (exchangeRates.count) {
            resolve(exchangeRates);
        } else {
            NSError *error = [NSError errorWithDescription:nil underlyingError:nil errorTypeCode:ErrorTypeCodeInternal errorLevel:DDLogLevelError];
            resolve(error);
        }
    }];
}

@end
