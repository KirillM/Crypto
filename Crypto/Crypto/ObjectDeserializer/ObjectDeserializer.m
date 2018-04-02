//
//  ObjectDeserializer.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "ObjectDeserializer.h"
//#import "Place+CoreDataClass.h"
//#import "PlaceReview+CoreDataClass.h"
//#import <GoogleMaps/GoogleMaps.h>
//#import "GeoPointPlainObject.h"
//#import "GeoPoint+CoreDataClass.h"
//#import "CurrentUser.h"
//#import "PSNCategory+CoreDataClass.h"
//#import "PlacePlainObject.h"
//#import "CategoryPlainObject.h"
#import "NSError+Poison.h"

@implementation ObjectDeserializer


/* Plain */

- (AnyPromise *)plainPhotoWithReviewFromDictionary:(NSDictionary *)dict {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        resolve([FEMDeserializer objectFromRepresentation:dict mapping:[Mapping plainPhotoWithReviewMapping]]);
    }];
}

# pragma mark - Geocode

- (AnyPromise *)plainGeoPointsFromGeocodeResponse:(NSDictionary *)geocodeResponce {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        NSMutableArray <GeoPointPlainObject *> *geoPoints = [NSMutableArray <GeoPointPlainObject *> new];
        NSArray <NSDictionary *> *placeInfos = geocodeResponce[@"results"];
        [placeInfos enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull placeInfo, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *types = placeInfo[@"types"];
            if ([types isKindOfClass:[NSArray class]] && types.count > 0) {
                [types enumerateObjectsUsingBlock:^(NSString *_Nonnull type, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([type isEqualToString:@"street_address"]) {
                        // это то место, которое нам нужно. распарсим его
                        [geoPoints addObject:[FEMDeserializer objectFromRepresentation:placeInfo
                                                                               mapping:[Mapping plainGeoMappingWithGoogleGeocode]]];
                    }
                }];
            }
        }];
        resolve(geoPoints);
    }];
}

- (AnyPromise *)plainGeoPointsFromGooglePlacesResponse:(NSArray<GMSPlace *> *)response {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        __block NSMutableArray<GeoPointPlainObject *> *geoPoints = [NSMutableArray<GeoPointPlainObject *> new];
        [response enumerateObjectsUsingBlock:^(GMSPlace * _Nonnull place, NSUInteger idx, BOOL * _Nonnull stop) {
            GeoPointPlainObject *geoPlainObject = [[GeoPointPlainObject alloc] initWithGMSPlace:place];
            [geoPoints addObject:geoPlainObject];
        }];
        resolve(geoPoints);
    }];
}

- (AnyPromise *)plainGeoPointFromResponse:(GMSReverseGeocodeResponse *)reverseGeocodeResponse {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        if (reverseGeocodeResponse.firstResult) {
            GMSAddress *addressObj = reverseGeocodeResponse.firstResult;
            NSString *addressString = @"";
            if (addressObj.thoroughfare) {
                addressString = addressObj.thoroughfare;
            } else if (addressObj.lines) {
                addressString = [addressObj.lines componentsJoinedByString:@", "];
            }
            
            NSDictionary *dict =  @{ @"addressString" : addressString,
                                     @"lat" : @(addressObj.coordinate.latitude),
                                     @"lon" : @(addressObj.coordinate.longitude)
                                     };
            
            resolve([FEMDeserializer objectFromRepresentation:dict mapping:[Mapping plainGeoMapping]]);
            
        }
    }];
}

/* */

- (AnyPromise *)placeDraftIdxFromDictionary:(NSDictionary *)dict {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver  _Nonnull resolve) {
        resolve(dict[@"id"]);
    }];
}

@end
