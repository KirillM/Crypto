//
//  AddCurrencyViewController.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "AddCurrencyViewController.h"
#import "AddCurrencyTableViewCell.h"
#import "CurrencyObject.h"

@interface AddCurrencyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation AddCurrencyViewController 

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exchangeRates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddCurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCurrencyTableViewCell"];
    CurrencyObject *obj = [self.exchangeRates objectAtIndex:indexPath.row];
    cell.symbol.text = obj.symbol;
    cell.name.text = obj.name;
    cell.accessoryType = obj.selected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CurrencyObject *obj = [self.exchangeRates objectAtIndex:indexPath.row];
    obj.selected = !obj.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
