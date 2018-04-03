//
//  NetworkService+Crypto.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "NetworkService+Crypto.h"
#import "NSError+Crypto.h"
#import "NetworkServiceCryptoProtocol.h"
#import <PromiseKit/PromiseKit.h>

@implementation NetworkService (Crypto)

- (AnyPromise *)cryptoExchanges {
    [self applyJsonSerializer];
    return [self cancellableGET].then(^(NSDictionary *exchanges) {
        return [self.objectDeserializer currenciesExchangeRatesFromDictionary:exchanges].catch(^(NSError *error) {
            [error log:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)];
        });
    }).catch(^(NSError *error) {
        [error log:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)];
    });
}

@end
