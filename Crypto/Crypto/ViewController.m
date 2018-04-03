//
//  ViewController.m
//  Crypto
//
//  Created by Kirill Mezrin on 31/03/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import "ViewController.h"
#import <PromiseKit/PromiseKit.h>
#import "NetworkServiceProtocol.h"
#import "NetworkService.h"

@interface ViewController ()

@property (nonatomic, strong) id <NetworkServiceProtocol> networkService;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.networkService = (id <NetworkServiceProtocol>)[[NetworkService alloc] init];
    [self getExchangeRates];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getExchangeRates{
    [self.networkService cryptoExchanges].then(^(NSArray *subways){
       // [self.output didFindSubways:subways];
    }).catch (^(NSError *error) {
       // [error log:NSStringFromClass(self.class) method:NSStringFromSelector(_cmd)];
       // [self.output didFindSubwaysFailedWithError:error];
    });
}

@end
