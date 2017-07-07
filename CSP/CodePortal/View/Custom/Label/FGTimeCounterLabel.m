//
//  FGTimeCounterLabel.m
//  CSP
//
//  Created by JasonLu on 16/9/22.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTimeCounterLabel.h"
@interface FGTimeCounterLabel () {
}
@property (nonatomic, assign) NSInteger totalTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) TimeCompletionHander completionHandler;
@end

@implementation FGTimeCounterLabel
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  self.textColor = [UIColor whiteColor];
}

#pragma mark - 自定义方法
- (void)startCounterWithTime:(NSInteger)totalTime timeInterval:(NSTimeInterval)timeInterval completionHandler:(TimeCompletionHander)handler {
  self.totalTime = totalTime;
  self.text      = [NSString stringWithFormat:@"%lds", self.totalTime];

  [self stopTimer];
  self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:YES];

  [self clearHandler];
  self.completionHandler = handler;
}

- (void)updateTimeLabel {
  self.totalTime--;
  self.text = [NSString stringWithFormat:@"%lds", self.totalTime];
  [self setNeedsDisplay];

  if (self.totalTime < 0) {
    [self stopTimer];

    self.completionHandler();
    [self clearHandler];
    return;
  }
}

- (void)stopTimer {
  if ([self.timer isValid])
    [self.timer invalidate];
  self.timer = nil;
}

- (void)clearHandler {
  self.completionHandler = nil;
}
@end
