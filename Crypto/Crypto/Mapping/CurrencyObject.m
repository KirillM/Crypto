//
//  CurrencyObject.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "CurrencyObject.h"

@implementation CurrencyObject

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _delay = [aDecoder decodeObjectForKey:@"delay"];
        _buy = [aDecoder decodeObjectForKey:@"buy"];
        _last= [aDecoder decodeObjectForKey:@"last"];
        _sell = [aDecoder decodeObjectForKey:@"sell"];
        _symbol = [aDecoder decodeObjectForKey:@"symbol"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _selected = [aDecoder decodeBoolForKey:@"selected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_delay forKey:@"delay"];
    [aCoder encodeObject:_buy forKey:@"buy"];
    [aCoder encodeObject:_last forKey:@"last"];
    [aCoder encodeObject:_symbol forKey:@"symbol"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeBool:_selected forKey:@"selected"];
}

@end
