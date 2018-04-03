//
//  NetworkService.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "NetworkServiceProtocol.h"
#import "ObjectDeserializerProtocol.h"

@interface NetworkService : AFHTTPSessionManager <NSObject>

@property (strong, nonatomic, nullable) id<ObjectDeserializerProtocol> objectDeserializer;

- (AnyPromise * _Nonnull)cancellableGET;

- (void)applyJsonSerializer;
- (void)setSerializerToDefault;

@end
