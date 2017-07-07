//
//  UIScrollView+FGRereshFooter.m
//  CSP
//
//  Created by JasonLu on 16/9/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIScrollView+FGRereshFooter.h"
#import <objc/runtime.h>

static const void *refreshFooterKey = &refreshFooterKey;//字符串类型
static char kWaitingProgressHUD;//对象类型

@implementation UIScrollView (FGRereshFooter)
- (void)addInfiniteScrollingWithActionHandler:(BeginRefreshingBlock)actionHandler {
  if (!self.refreshFooter) {
    __weak UIScrollView *weakSelf = self;
    FGRefreshFooter *refreshFooter     = [[FGRefreshFooter alloc] init];
    refreshFooter.scrollView           = weakSelf;
    refreshFooter.beginRefreshingBlock = actionHandler;
    [refreshFooter footer];
    self.refreshFooter = refreshFooter;
  }
}

- (FGRefreshFooter *)refreshFooter {
  return objc_getAssociatedObject(self, refreshFooterKey);
}

- (void)setRefreshFooter:(FGRefreshFooter *)aRefreshFooter {
  objc_setAssociatedObject(self, refreshFooterKey, aRefreshFooter, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)waitingProgressHUD {
  return objc_getAssociatedObject(self, &kWaitingProgressHUD);
}

- (void)setWaitingProgressHUD:(MBProgressHUD *)progressHUD {
  objc_setAssociatedObject(self, &kWaitingProgressHUD, progressHUD,
                           OBJC_ASSOCIATION_RETAIN);
}


- (void)allowedShowActivityAtFooter:(BOOL)isAllowed {
  [self.refreshFooter setupSrollViewRefreshStatus:isAllowed];
}

@end

@interface FGRefreshFooter () {
  float contentHeight;
  float scrollFrameHeight;
  float footerHeight;
  float scrollWidth;
  BOOL isAdd;     //是否添加了footer,默认是NO
  BOOL isRefresh; //是否正在刷新,默认是NO
  BOOL isAllowedRefresh;

  UIView *footerView;
  UIActivityIndicatorView *activityView;
}
@end

@implementation FGRefreshFooter
- (void)footer {
  scrollWidth       = _scrollView.frame.size.width;
  footerHeight      = 35;
  scrollFrameHeight = _scrollView.frame.size.height;
  isAdd             = NO;
  isRefresh         = NO;
  isAllowedRefresh  = YES;
  footerView        = [[UIView alloc] init];
  activityView      = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (![@"contentOffset" isEqualToString:keyPath])
    return;

  if (!isAllowedRefresh)
    return;

  contentHeight = _scrollView.contentSize.height;
  if (!isAdd) {
    isAdd            = YES;
    footerView.frame = CGRectMake(0, contentHeight, scrollWidth, footerHeight);
    [_scrollView addSubview:footerView];
    activityView.frame = CGRectMake((scrollWidth - footerHeight) / 2, 0, footerHeight, footerHeight);
    [footerView addSubview:activityView];
  }

  footerView.frame   = CGRectMake(0, contentHeight, scrollWidth, footerHeight);
  activityView.frame = CGRectMake((scrollWidth - footerHeight) / 2, 0, footerHeight, footerHeight);
  int currentPostion = _scrollView.contentOffset.y;
  // 进入刷新状态
  if ((currentPostion > (contentHeight - scrollFrameHeight)) && (contentHeight > scrollFrameHeight)) {
    [self beginRefreshing];
  }
}

/**
 *  开始刷新操作  如果正在刷新则不做操作
 */
- (void)beginRefreshing {
  if (!isRefresh) {
    isRefresh = YES;
    [activityView startAnimating];
    //        设置刷新状态_scrollView的位置
    [UIView animateWithDuration:0.3 animations:^{
      _scrollView.contentInset = UIEdgeInsetsMake(0, 0, footerHeight, 0);
    }];
    //        block回调
    _beginRefreshingBlock();
  }
}

/**
 *  关闭刷新操作  请加在UIScrollView数据刷新后，如[tableView reloadData];
 */
- (void)endRefreshing {
  isRefresh = NO;
  dispatch_async(dispatch_get_main_queue(), ^{
    [UIView animateWithDuration:0.3 animations:^{
      [activityView stopAnimating];
//      _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
      footerView.frame         = CGRectMake(0, contentHeight, [[UIScreen mainScreen] bounds].size.width, footerHeight);
    }];
  });
}

- (void)setupSrollViewRefreshStatus:(BOOL)isShow {
  isAllowedRefresh = isShow;
}

- (void)dealloc {
  [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}
@end
