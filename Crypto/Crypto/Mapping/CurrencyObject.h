//
//  CurrencyObject.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyObject : NSObject

@property (nonatomic, copy) NSNumber *delay;
@property (nonatomic, copy) NSNumber *buy;
@property (nonatomic, copy) NSNumber *last;
@property (nonatomic, copy) NSNumber *sell;
@property (nonatomic, copy) NSString *symbol;

@end
