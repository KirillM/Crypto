//
//  NetworkServiceProtocol.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkServicePlacesProtocol.h"
#import "NetworkServicePhotosProtocol.h"
#import "NetworkServiceGeocodingProtocol.h"
#import "NetworkServiceWrongInfoProtocol.h"
#import "NetworkServiceReviewProtocol.h"
#import "NetworkServiceAuthProtocol.h"
#import "NetworkServiceAnalyticsProtocol.h"
#import "NetworkServiceSearchPlacesProtocol.h"
#import "NetworkServiceErrorProtocol.h"
#import "NetworkServiceSubwayStationsProtocol.h"

@class AnyPromise;

@protocol NetworkServiceProtocol
<NetworkServicePlacesProtocol, NetworkServicePhotosProtocol, NetworkServiceGeocodingProtocol, NetworkServiceWrongInfoProtocol, NetworkServiceReviewProtocol, NetworkServiceAuthProtocol, NetworkServiceAnalyticsProtocol, NetworkServiceSearchPlacesProtocol, NetworkServiceSubwayStationsProtocol, NetworkServiceErrorProtocol>
@end
