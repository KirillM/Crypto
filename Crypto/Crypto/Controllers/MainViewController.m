//
//  ViewController.m
//  Crypto
//
//  Created by Kirill Mezrin on 31/03/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "MainViewController.h"
#import <PromiseKit/PromiseKit.h>
#import "NetworkServiceProtocol.h"
#import "NetworkService.h"
#import "NSError+Crypto.h"
#import "AddCurrencyViewController.h"
#import "MainCurrencyTableViewCell.h"
#import "CurrencyObject.h"

static NSString *const kAddCurrencyViewControllerSegue = @"kAddCurrencyViewControllerSegue";
static NSString *kUserDefaultsExchangeRatesKey = @"UserDefaultsExchangeRates";

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) id <NetworkServiceProtocol> networkService;
@property (atomic, strong) NSArray *exchangeRates;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, weak) IBOutlet UIButton *addButton;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *amountBTCTextField;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkService = (id <NetworkServiceProtocol>)[[NetworkService alloc] init];
    [self getExchangeRates];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setSaveExchangeRates:self.exchangeRates];
    [self.tableView reloadData];
}

- (void)getExchangeRates{
    
    self.exchangeRates = [self exchangeRatesSaved];

    __weak typeof(self) weakSelf = self;
    [self.networkService cryptoExchanges].then(^(NSArray *newExchangeRates){
        [weakSelf.exchangeRates enumerateObjectsUsingBlock:^(CurrencyObject   * _Nonnull exchangeRate, NSUInteger exchangeRateIdx, BOOL * _Nonnull exchangeRateStop) {
            [newExchangeRates enumerateObjectsUsingBlock:^(CurrencyObject   * _Nonnull newExchangeRate, NSUInteger newExchangeRateIdx, BOOL * _Nonnull newExchangeRatesStop) {
                if ([exchangeRate.name isEqualToString:newExchangeRate.name]) {
                    newExchangeRate.selected = exchangeRate.selected;
                }
            }];
        }];
        weakSelf.exchangeRates = newExchangeRates;
        [weakSelf setSaveExchangeRates:newExchangeRates];
        [weakSelf.tableView reloadData];
        weakSelf.amountBTCTextField.text = [NSString stringWithFormat:@"%f", [self calculate]];
    }).catch (^(NSError *error) {
        [error log:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)];
    });
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kAddCurrencyViewControllerSegue]) {
        AddCurrencyViewController *addCurrencyViewController = (AddCurrencyViewController *)[segue destinationViewController];
        addCurrencyViewController.exchangeRates = self.exchangeRates;
    }
}

#pragma mark - Actions

- (IBAction)clearButtonTapped {
    NSArray *selectedCurrencies = [self selectedCurrencies];
    [selectedCurrencies enumerateObjectsUsingBlock:^(CurrencyObject  *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MainCurrencyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        cell.amountTextField.text = @"0.0";
    }];
    self.amountBTCTextField.text = @"0.0";
}

- (IBAction)refreshButtonTapped {
    [self getExchangeRates];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *filteredRates = [self selectedCurrencies];
    return filteredRates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainCurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCurrencyTableViewCell"];
    
    NSArray *filteredRates = [self selectedCurrencies];
    CurrencyObject *obj = [filteredRates objectAtIndex:indexPath.row];
    cell.symbol.text = obj.symbol;
    cell.name.text = obj.name;
    cell.amountTextField.tag = indexPath.row;
    cell.amountTextField.delegate = self;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *filteredRates = [self selectedCurrencies];
        CurrencyObject *obj = [filteredRates objectAtIndex:indexPath.row];
        obj.selected = !obj.selected;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self setSaveExchangeRates:self.exchangeRates];
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.amountBTCTextField]) {
        [self calculateAvgAmountWithBTC];
    } else {
        self.amountBTCTextField.text = [NSString stringWithFormat:@"%f", [self calculate]];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.text = @"";
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.doubleValue == 0) {
        textField.text = @"0.0";
    }
}

#pragma mark - Notifications

- (void)addKeyboardNotificationSubscription {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}

//- (void)keyboardWillHide:(NSNotification*)notification {
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//}
//
//- (void)keyboardDidShow:(NSNotification*)notification {
//    NSDictionary* info = [notification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 20.0, 0.0);
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//}

#pragma mark - User Defaults

- (NSArray<CurrencyObject *> *)exchangeRatesSaved {
    NSData *exchangeRatesData = [[NSUserDefaults standardUserDefaults] dataForKey:kUserDefaultsExchangeRatesKey];
    
    if (!exchangeRatesData) {
        return nil;
    }
    
    @try {
        NSArray *exchangeRates = [NSKeyedUnarchiver unarchiveObjectWithData:exchangeRatesData];
        if (exchangeRates) {
            return exchangeRates;
        }
    } @catch (NSException *exception) {
        return nil;
    }
}

- (void)setSaveExchangeRates:(NSArray<CurrencyObject *> *)exchangeRates {
    NSData *userMapLastPostionData = [NSKeyedArchiver archivedDataWithRootObject:exchangeRates];
    [[NSUserDefaults standardUserDefaults] setObject:userMapLastPostionData forKey:kUserDefaultsExchangeRatesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Helpers

- (NSArray *)selectedCurrencies {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected == YES"];
    NSArray *filteredRates = [self.exchangeRates filteredArrayUsingPredicate:predicate];
    return filteredRates;
}

- (double)calculate {
    __block double btcAmount = 0.0;
    NSArray *selectedCurrencies = [self selectedCurrencies];
    [selectedCurrencies enumerateObjectsUsingBlock:^(CurrencyObject  *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MainCurrencyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        double cellAmount = cell.amountTextField.text.doubleValue;
        NSNumber *lastPosition = obj.last;
        double lastPositionAmount = [lastPosition doubleValue];
        btcAmount += cellAmount/lastPositionAmount;
    }];
    return btcAmount;
}

- (double)calculateAvgAmountWithBTC {
    double btcAmount = self.amountBTCTextField.text.doubleValue;
    NSArray *selectedCurrencies = [self selectedCurrencies];
    double btcAmountAvg = btcAmount/selectedCurrencies.count;
    [selectedCurrencies enumerateObjectsUsingBlock:^(CurrencyObject  *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MainCurrencyTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        NSNumber *lastPosition = obj.last;
        double lastPositionAmount = [lastPosition doubleValue];
        cell.amountTextField.text = [NSString stringWithFormat:@"%f", btcAmountAvg*lastPositionAmount];
    }];
    return btcAmount;
}

@end
