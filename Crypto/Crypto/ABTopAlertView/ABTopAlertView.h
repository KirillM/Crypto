//
//  ABTopAlertView.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABTopAlertView : NSObject

+ (ABTopAlertView *)shared;

- (void)showError:(NSString *)text;
- (void)showError:(NSString *)text interval:(NSTimeInterval)interval;

@end
