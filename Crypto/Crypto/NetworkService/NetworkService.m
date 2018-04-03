//
//  NetworkService.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "NetworkService.h"
#import "Logger.h"
#import "AppDelegate.h"
#import "NSError+Crypto.h"
#import <PromiseKit/PromiseKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <Foundation/Foundation.h>
#import "ObjectDeserializer.h"

static CGFloat const TIMEOUT_INTERVAL = 40.f;

NSString * const kBaseCryptoURL = @"https://blockchain.info/ru/ticker";

typedef NS_ENUM (NSUInteger, GETCancellableTaskType) {
    GETCancellableTaskTypeCrypto
};

@interface NetworkService()

@property (strong, nonatomic, nullable) AFHTTPRequestSerializer *defaultSerializer;

@property (assign, nonatomic) NSInteger networkActivityCounter;
@property (strong, nonatomic) NSURLSessionDataTask *loadCrypto;

@end

@implementation NetworkService

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseCryptoURL]];
    if (self) {
        self.objectDeserializer = [[ObjectDeserializer alloc] init];
        [self.requestSerializer setTimeoutInterval:TIMEOUT_INTERVAL];
    }
    return self;
}

- (AnyPromise * _Nonnull)cancellableGET {
    NSURLSessionDataTask *loadTask = self.loadCrypto;
    if (loadTask && loadTask.state != NSURLSessionTaskStateCompleted) {
        [loadTask cancel];
        self.loadCrypto = nil;
        [self decrementNetworkActivityCounter];
    }
    
    [self incrementNetworkActivityCounter];
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        NSURLSessionDataTask *newTask = [self GET:kBaseCryptoURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self decrementNetworkActivityCounter];
            [self.requestSerializer clearAuthorizationHeader];
            
            self.loadCrypto = nil;
            DDLogVerbose(@"%@", [Logger info:[NSString stringWithFormat:@"Response: %@", task.response.URL.absoluteString] class:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)]);
            DDLogDebug(@"%@", [Logger info:[NSString stringWithFormat:@"Response Headers: %@", ((NSHTTPURLResponse *)task.response).allHeaderFields] class:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)]);
            DDLogDebug(@"%@", [Logger info:[NSString stringWithFormat:@"Response Object: %@", responseObject] class:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)]);
            resolve(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.requestSerializer clearAuthorizationHeader];
            if (task.error.code != NSURLErrorCancelled) {
                [self decrementNetworkActivityCounter];
            } else {
                return;
            }
            if (error) {
                if ([error.domain isEqualToString:NSURLErrorDomain]) {
                    error = [NSError errorWithDescription:nil underlyingError:error errorTypeCode:ErrorTypeCodeNetwork errorLevel:DDLogLevelWarning];
                } else {
                    error = [NSError errorWithDescription:nil underlyingError:error errorTypeCode:ErrorTypeCodeServer errorLevel:DDLogLevelError];
                }
            }
            [error log:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)];
            resolve(error);
        }];
        DDLogVerbose(@"%@", [Logger info:[NSString stringWithFormat:@"Request: %@", newTask.currentRequest.URL.absoluteString] class:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)]);
        DDLogDebug(@"%@", [Logger info:[NSString stringWithFormat:@"Request Headers: %@", newTask.currentRequest.allHTTPHeaderFields] class:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)]);
        self.loadCrypto = newTask;
    }];
}

#pragma mark - Network activity counter
- (void)incrementNetworkActivityCounter {
    self.networkActivityCounter ++;
}

- (void)decrementNetworkActivityCounter {
    self.networkActivityCounter --;
}

- (void)setNetworkActivityCounter:(NSInteger)networkActivityCounter {
    _networkActivityCounter = networkActivityCounter;
    [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:_networkActivityCounter > 0];
}

#pragma mark - Cancellable tasks logic

- (NSURLSessionDataTask *)loadTaskWithType:(GETCancellableTaskType)type {
    switch (type) {
        case GETCancellableTaskTypeCrypto:
            return self.loadCrypto;
    }
}

- (void)updateLoadTaskType:(GETCancellableTaskType)type withValue:(NSURLSessionDataTask *)task {
    switch (type) {
        case GETCancellableTaskTypeCrypto:
            self.loadCrypto = task;
            break;
    }
}

#pragma mark - Helper

- (void)applyJsonSerializer {
    self.defaultSerializer = self.requestSerializer;
    self.requestSerializer = [[AFJSONRequestSerializer alloc] init];
}

- (void)setSerializerToDefault {
    self.requestSerializer = self.defaultSerializer;
    self.defaultSerializer = nil;
}

@end
