//
//  FGNewsInfoView.m
//  CSP
//
//  Created by JasonLu on 16/11/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGNewsInfoView.h"

@interface FGNewsInfoView () {
  UIProgressView *view_progress;
  
  NSTimer *timer_progress;
  BOOL bool_isFinished;
  BOOL bool_isOnline;
  float flt_progress;
}
@end

@implementation FGNewsInfoView
@synthesize wv_news;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [commond useDefaultRatioToScaleView:wv_news];
  [self internalInitalView];
}

- (void)internalInitalView {
  self.wv_news.delegate = self;
  
  [self internalInitalProgressView];
}

- (void)internalInitalTimer {
  [self clearTimer];
  
  flt_progress = 0;
  timer_progress = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(updateWebLoadProgress) userInfo:nil repeats:YES];
  //加入主循环池中
  [[NSRunLoop mainRunLoop]addTimer:timer_progress forMode:NSDefaultRunLoopMode];
}

- (void)clearTimer {
  if ([timer_progress isValid]) {
    [timer_progress invalidate];
    timer_progress = nil;
  }
}

- (void)internalInitalProgressView {
  CGFloat progressBarHeight = 2.f;
  CGRect barFrame = CGRectMake(0, 0 , 320*ratioW , progressBarHeight);
  view_progress = [[UIProgressView alloc] initWithFrame:barFrame];
  view_progress.tintColor = color_red_panel;
  [view_progress setProgress:0 animated:NO];
  view_progress.backgroundColor = [UIColor clearColor];
  [self addSubview:view_progress];
}

- (void)clearProgressView {
  [view_progress removeFromSuperview];
}

- (void)setupNewsInfoWithLink:(NSString *)_link {

  NSURL *url = [[NSURL alloc]initWithString:_link];

    bool_isFinished = NO;
    bool_isOnline = [commond isNetworkReachable];
    flt_progress = 0;
    [self.wv_news loadRequest:[NSURLRequest requestWithURL:url]];

  //  [self.wv_news reload];
}

- (void)dealloc {
  //  [self.tb_homepage setRefreshFooter:nil];
  self.wv_news       = nil;
  view_progress = nil;
  [self clearTimer];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - webview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
  return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
  NSLog(@"webViewDidStartLoad");
  [self internalInitalTimer];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
  NSLog(@"webViewDidFinishLoad");
  bool_isFinished = YES;
  [self updateWebLoadProgress];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
  NSLog(@"didFailLoadWithError");
  [self clearTimer];
  [self clearProgressView];
}


- (void)updateWebLoadProgress{
  if (bool_isOnline == NO) {
    
    flt_progress += 0.01f;
    [view_progress setProgress:flt_progress animated:NO];
    
    if (flt_progress >= 1.0f) {
      [self clearTimer];
      [self clearProgressView];
      return;
    }
    return;
  }
  
  
  if (bool_isFinished == NO) {
    if (flt_progress < 0.9f) {
      flt_progress += 0.01f;
      [view_progress setProgress:flt_progress animated:NO];
    }
  } else {
    flt_progress = 1.0f;
    [view_progress setProgress:flt_progress animated:YES];
    [self clearTimer];
    [self clearProgressView];
  }
}

@end
