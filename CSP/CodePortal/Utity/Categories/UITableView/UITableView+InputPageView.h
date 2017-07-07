//
//  UITableView+InputPageView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/25.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TableInputType) {
  TableInputType_Inital   = 0,
  TableInputType_Inputing = 1,
  TableInputType_None     = 2
};

typedef NS_ENUM(NSInteger, TableISAllowAutoScroll) {
  isAllowAutoScroll_yes  = 1,
  isAllowAutoScroll_no   = 0,
  isAllowAutoScroll_none = 2
};

@protocol TableViewInputDelegate <NSObject>

- (void)clearTableViewInput;

@end

static char TAG_currentSlideUpHeight;
static char TAG_originalFrame;
static char TAG_origianlContentSize;
static char TAG_currentInputType;
static char TAG_tableViewInputDelegate;
static char TAG_isAllowScrollAuto;
static char TAG_offsetHeight;
static char TAG_touchScreenPoint;
static char TAG_keyboardType;
static char TAG_textField;


@interface UITableView (InputPageView) <UIGestureRecognizerDelegate, UITextFieldDelegate, UIScrollViewDelegate> {
}
- (void)setupByOriginalContentSize:(CGSize)_contentSize delegate:(id<TableViewInputDelegate>)delegate inView:(UIView *)view;
- (void)adjustVisibleRegion:(CGFloat)_slideUpHeight;
- (void)resetVisibleRegion;
- (void)removeAllInputView;
#pragma mark - 这个方法指定子视图滚动到底部 如果需要的话
#pragma mark - 这个方法必须在 adjustVisibleRegion 之后调用 adjustVisibleRegion方法指定了现在是输入模式的状态
//_heightOccupied 告知这个view占用了多少高度
- (void)scrollSubViewToBottomIfNeeded:(UIView *)_view_subviewOfScrollView heightOccupied:(CGFloat)_heightOccupied;
- (void)clearMemory;
@end
