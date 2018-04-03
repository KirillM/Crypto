//
//  ObjectDeserializerProtocol.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PromiseKit/PromiseKit.h>

@protocol ObjectDeserializerProtocol <NSObject>

- (AnyPromise *)currenciesExchangeRatesFromDictionary:(NSDictionary *)dict;

@end
