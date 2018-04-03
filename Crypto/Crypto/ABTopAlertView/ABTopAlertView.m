//
//  ABTopAlertView.m
//  Crypto
//
//  Created by Kirill Mezrin on 03/04/2018.
//  Copyright © 2018 Kirill Mezrin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ABTopAlertView.h"
#import "NSString+Crypto.h"
#import <FrameAccessor/FrameAccessor.h>

@interface ABTopAlertView ()

@property (nonatomic, strong) UIWindow *alertWindow;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, assign) BOOL isHiddeningNow;

@end

CGFloat const kABTopAlertViewHeight = 50;


@implementation ABTopAlertView

- (UIWindow *)alertWindow {
    if (_alertWindow == nil) {
        _alertWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kABTopAlertViewHeight)];
        _alertWindow.translatesAutoresizingMaskIntoConstraints = NO;
        _alertWindow.windowLevel = UIWindowLevelAlert + 1;
        _alertWindow.backgroundColor = [UIColor colorWithRed:127/255.0f green:186/255.0f blue:0/255.0f alpha:1.0];
        _alertWindow.clipsToBounds = YES;
        [_alertWindow addSubview:_alertLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_alertLabel, _alertWindow);
        NSArray<NSLayoutConstraint *> *constraintLabelH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-16-[_alertLabel]-16-|" options:0 metrics:nil views:views];
        NSArray<NSLayoutConstraint *> *constraintLabelV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[_alertLabel]-15-|" options:0 metrics:nil views:views];
        NSArray<NSLayoutConstraint *> *constraintWindowH = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_alertWindow(==%f)]",[UIScreen mainScreen].bounds.size.width] options:0 metrics:nil views:views];
        NSArray<NSLayoutConstraint *> *constraintWindowV = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[_alertWindow(>=%f)]",kABTopAlertViewHeight] options:0 metrics:nil views:views];
        
        [NSLayoutConstraint activateConstraints:constraintWindowH];
        [NSLayoutConstraint activateConstraints:constraintWindowV];
        [NSLayoutConstraint activateConstraints:constraintLabelH];
        [NSLayoutConstraint activateConstraints:constraintLabelV];
        
        [_alertWindow setNeedsLayout];
        [_alertWindow layoutIfNeeded];
        
        _alertWindow.top = -CGRectGetHeight(self.alertWindow.bounds);
    }
    return _alertWindow;
}

- (UILabel *)alertLabel {
    if (_alertLabel == nil) {
        _alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _alertLabel.numberOfLines = 0;
        _alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _alertLabel.font = [UIFont systemFontOfSize:14.f];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.textColor = [UIColor whiteColor];
        _alertLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 32.f;
        _alertLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _alertLabel.backgroundColor = [UIColor clearColor];
        _alertLabel.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleGesture:)];
        [_alertLabel addGestureRecognizer:panGR];
    }
    return _alertLabel;
}

+ (ABTopAlertView *)shared {
    static ABTopAlertView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[ABTopAlertView alloc] init];
    });
    return view;
}

- (instancetype)init {
    if (self = [super init]) {
        _isHiddeningNow = NO;
    }
    return self;
}

- (void)showError:(NSString *)text {
    [self showError:text interval:3.0];
}

- (void)showError:(NSString *)text interval:(NSTimeInterval)interval {
    if(_alertWindow && !_alertWindow.isHidden) {
        return;
    }
    self.alertLabel.text = text;
    self.alertWindow.backgroundColor = [UIColor colorWithRed:142.0f / 255.0f green:142.0f / 255.0f blue:147.0f / 255.0f alpha:1.0f];
    [_alertWindow setHidden:NO];
    [_alertWindow setNeedsLayout];
    [_alertWindow layoutIfNeeded];
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        _alertWindow.top = [[UIApplication sharedApplication] statusBarFrame].size.height;
    } completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((interval+0.01) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAnimated];
    });
}

- (void)hideAnimated {
    self.isHiddeningNow = YES;
    [UIView animateWithDuration:0.3 delay:0.0 options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.alertWindow.top = -CGRectGetHeight(self.alertWindow.bounds);
    } completion:^(BOOL finished) {
        self.isHiddeningNow = NO;
        [_alertWindow setHidden:YES];
        [_alertWindow setNeedsLayout];
        [_alertWindow layoutIfNeeded];
    }];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint velocity = [gestureRecognizer velocityInView:self.alertLabel];
    if (velocity.y < 0 && !self.isHiddeningNow) {
        [self hideAnimated];
    }
}

@end
