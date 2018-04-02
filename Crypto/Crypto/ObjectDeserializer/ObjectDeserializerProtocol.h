//
//  ObjectDeserializerProtocol.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ObjectDeserializerProtocol <NSObject>


/* Plain */

- (AnyPromise *)plainPhotoWithReviewFromDictionary:(NSDictionary *)dict;
- (AnyPromise *)plainGeoPointFromResponse:(GMSReverseGeocodeResponse *)reverseGeocodeResponse;
- (AnyPromise *)plainGeoPointsFromGeocodeResponse:(NSDictionary *)geocodeResponce;
- (AnyPromise *)plainGeoPointsFromGooglePlacesResponse:(NSArray<GMSPlace *> *)response;

/* */
- (AnyPromise *)placeDraftIdxFromDictionary:(NSDictionary *)dict;

@end
