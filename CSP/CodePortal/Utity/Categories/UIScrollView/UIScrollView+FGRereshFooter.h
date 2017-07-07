//
//  UIScrollView+FGRereshFooter.h
//  CSP
//
//  Created by JasonLu on 16/9/26.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BeginRefreshingBlock)();

@interface FGRefreshFooter : NSObject
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
- (void)footer;
- (void)beginRefreshing;
- (void)endRefreshing;
- (void)setupSrollViewRefreshStatus:(BOOL)isShow;
@end

@interface UIScrollView (FGRereshFooter)
@property (nonatomic, strong) FGRefreshFooter *refreshFooter;
- (void)addInfiniteScrollingWithActionHandler:(BeginRefreshingBlock)actionHandler;
- (void)allowedShowActivityAtFooter:(BOOL)isAllowed;
@end
