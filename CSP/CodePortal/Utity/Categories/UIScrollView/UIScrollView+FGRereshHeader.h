//
// UIScrollView+SVPullToRefresh.h
//
// Created by Sam Vermette on 23.04.12.
// Copyright (c) 2012 samvermette.com. All rights reserved.
//
// https://github.com/samvermette/SVPullToRefresh
//
/*
 示例代码：
 __weak ViewController *weakSelf = self;
 [self.tb_content addPullToRefreshWithActionHandler:^{
 //[weakSelf insertRowAtTop];
 //网络请求最新数据
 }];
 [self.tb_content setupPullToRefreshViewWithStopTitle:@"下啦加载"
 TriggeredTitle:@"松手加载"
 loadingTitle:@"加载中..."
 loadingImage:nil];
 
 - (void)insertRowAtTop {
 __weak ViewController *weakSelf = self;
 int64_t delayInSeconds = 2.0;
 dispatch_time_t popTime =
 dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
 [self updateNewInfos];
 [weakSelf.tb_content reloadData];
 [weakSelf.tb_content.pullToRefreshView stopAnimating];
 });
 }
 
 */
#import "MMMaterialDesignSpinner.h"
#import <AvailabilityMacros.h>
#import <UIKit/UIKit.h>

@class SVPullToRefreshView;

@interface UIScrollView (SVPullToRefresh)

typedef NS_ENUM(NSUInteger, SVPullToRefreshPosition) {
  SVPullToRefreshPositionTop = 0,
  SVPullToRefreshPositionBottom,
};

- (void)setupSpinnerStyle:(UIColor *)color lineWidth:(CGFloat)width;
- (void)setupSpinnerStyleWithColor:(UIColor *)color;
- (void)setupSpinnerStyleWithLineWidth:(CGFloat)width;

- (void)setupLoadingMaskLayerHidden:(BOOL)isHidden;
- (void)setupLoadingMaskLayerHidden:(BOOL)isHidden withAlpha:(CGFloat)alpha;
- (void)setupLoadingMaskLayerHidden:(BOOL)isHidden withAlpha:(CGFloat)alpha withSpinnerHidden:(BOOL)spinnerHidden;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler;
- (void)addPullToRefreshWithActionHandler:(void (^)(void))actionHandler
                                 position:(SVPullToRefreshPosition)position;
- (void)triggerPullToRefresh;
- (void)stopRefresh;
- (void)setupPullToRefreshViewWithStopTitle:(NSString *)stopTitle
                             TriggeredTitle:(NSString *)triggeredTitle
                               loadingTitle:(NSString *)loadingTitle
                               loadingImage:(UIImage *)img;
- (void)setPullToRefreshView:(SVPullToRefreshView *)pullToRefreshView;
@property (nonatomic, strong, readonly) SVPullToRefreshView *pullToRefreshView;
@property (nonatomic, assign) BOOL showsPullToRefresh;

@end

typedef NS_ENUM(NSUInteger, SVPullToRefreshState) {
  SVPullToRefreshStateStopped = 0,
  SVPullToRefreshStateTriggered,
  SVPullToRefreshStateLoading,
  SVPullToRefreshStateAll = 10
};

@interface SVPullToRefreshView : UIView

@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;
@property (nonatomic, strong) UIColor *arrowColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong, readonly) UILabel *subtitleLabel;
@property (nonatomic, strong, readwrite)
    UIColor *activityIndicatorViewColor NS_AVAILABLE_IOS(5_0);
@property (nonatomic, readwrite)
    UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property (nonatomic, readonly) SVPullToRefreshState state;
@property (nonatomic, readonly) SVPullToRefreshPosition position;

- (void)setTitle:(NSString *)title forState:(SVPullToRefreshState)state;
- (void)setSubtitle:(NSString *)subtitle forState:(SVPullToRefreshState)state;
- (void)setCustomView:(UIView *)view forState:(SVPullToRefreshState)state;

- (void)startAnimating;
- (void)stopAnimating;

// deprecated; use setSubtitle:forState: instead
@property (nonatomic, strong, readonly) UILabel *dateLabel DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong) NSDate *lastUpdatedDate DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong)
    NSDateFormatter *dateFormatter DEPRECATED_ATTRIBUTE;

// deprecated; use [self.scrollView triggerPullToRefresh] instead
- (void)triggerRefresh DEPRECATED_ATTRIBUTE;

@end
