//
//  MainCurrencyTableViewCell.h
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCurrencyTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *symbol;
@property (nonatomic, weak) IBOutlet UITextField *amountTextField;

@end
