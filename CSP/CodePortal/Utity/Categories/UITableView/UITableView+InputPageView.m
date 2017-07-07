//
//  UITableView+InputPageView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/25.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "CUtils.h"
#import "UITableView+InputPageView.h"
#import <UIKit/UIGeometry.h>

#define TAG_DONEBAR 133

@implementation UITableView (InputPageView)
+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class class = [self class];

    swizzleMethod(class, @selector(touchesEnded:withEvent:), @selector(AOP_touchesEnded:withEvent:));
  });
}
#pragma mark - 生命周期
- (void)setupByOriginalContentSize:(CGSize)_contentSize delegate:(id<TableViewInputDelegate>)delegate inView:(UIView *)view {
  //  self.contentSize         = _contentSize;
  //  self.origianlContentSize = _contentSize;
  //  self.originalFrame       = self.frame;
  //  self.currentInputType = InputType_Inital;

  [self setOrigianlContentSize:_contentSize];
  [self setContentSize:_contentSize];
  [self setOriginalFrame:self.frame];
  [self setCurrentInputType:TableInputType_Inital];
  [self setTableViewInputDelegate:delegate];
  [self setIsAllowScrollAuto:isAllowAutoScroll_yes];

  //注册键盘事件
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
  
  UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsture_handleSingleTap:)];
  [view addGestureRecognizer:singleTap];
  singleTap.delegate = self;
  singleTap.cancelsTouchesInView = NO;
  
  /*点击取消键盘*/
  UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsture_cancelKeyboard:)];
  _tap.cancelsTouchesInView    = NO;
  _tap.delegate                = self;
  [self addGestureRecognizer:_tap];

  //  self.currentSlideUpHeight = [self normalKeyboardHeight]; //获取当前设备键盘高度
  [self setCurrentSlideUpHeight:[self normalKeyboardHeight]];
  [commond setTextFieldDelegate:self inView:view];
}

- (void)clearMemory {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
  [self setTableViewInputDelegate:nil];
  [self setCurrentInputType:TableInputType_None];
  [self setDelegate:nil];
  [self setOriginalFrame:CGRectZero];
  [self setOrigianlContentSize:CGSizeZero];
  [self setCurrentSlideUpHeight:-1];
  [self setKeyboardType:-1];
  [self setTextField:nil];
  
  [self setIsAllowScrollAuto:isAllowAutoScroll_none];

  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
}

#pragma mark - 点击回收键盘
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
  return YES;
}

/*收回所有键盘*/
- (void)getsture_cancelKeyboard:(id)_sender {
  [self removeAllInputView];
  [commond dismissKeyboard:appDelegate.window];
}

- (void)getsture_handleSingleTap:(id)_sender {
  CGPoint point = [_sender locationInView:self];
  NSLog(@"handleSingleTap!pointx:%f,y:%f",point.x,point.y);
  ;
}
#pragma mark - 键盘相关回调
- (void)keyboardWillShow:(NSNotification *)notification {
  [self removeAllInputView];
  NSDictionary *info = [notification userInfo];
  NSLog(@"info = %@", info);
  CGSize kbSize             = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  self.currentSlideUpHeight = kbSize.height;

  [self setCurrentSlideUpHeight:[self normalKeyboardHeight] + ([self keyboardType] == UIKeyboardTypeNumberPad ? (10) : 0)];
  if ([self keyboardType] == UIKeyboardTypeNumberPad) {
    [self performSelector:@selector(action_addDoneBarForNumberPad) withObject:nil afterDelay:.5f];
  }
  [self adjustVisibleRegion:self.currentSlideUpHeight];
}

- (void)keyboardWillHide:(NSNotification *)notification {
  
  if ([self keyboardType] == UIKeyboardTypeNumberPad) {
    [self action_removeDoneBarForNumberPad];
  }
  [self resetVisibleRegion];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
  [textField resignFirstResponder];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  NSLog(@"textFieldDidBeginEditing");
}

- (void)textFieldTextDidBeginEditing:(NSNotification *)notification {
  if ([[notification object] isKindOfClass:[UITextField class]]) {
    UITextField *textField = [notification object];
    if ([[[textField superview] superview] isKindOfClass:[UITableViewCell class]]) {
      //获取cell的位置,利用contentOffSet,来计算当前cell在屏幕的哪个位置
      UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
      CGRect rect_cell = cell.frame;
      CGFloat offset_y = rect_cell.origin.y - self.contentOffset.y;
      [self setKeyboardType:textField.keyboardType];
      [self setTextField:textField];
      [self setTouchScreenPoint:CGPointMake(0, offset_y)];
    }
  }
}
#pragma mark - 获得不同iphone上键盘的高度
- (CGFloat)normalKeyboardHeight {
  if (H <= 568) {
    return DEFAULT_KEYBOARDHEIGHT_IPHONE5;
  } else if (H <= 667) {
    return DEFAULT_KEYBOARDHEIGHT_IPHONE6;
  } else if (H <= 960) {
    return DEFAULT_KEYBOARDHEIGHT_IPHONE6PLUS;
  }
  return DEFAULT_KEYBOARDHEIGHT_IPHONE5;
}

#pragma mark - 子类需要实现此方法 把 其他自定义控件移除
- (void)removeAllInputView {
  if ([self tableViewInputDelegate]) {
    [[self tableViewInputDelegate] clearTableViewInput];
  }
}

#pragma mark - 根据弹出的键盘或view 调整scrollview 的高度 并且进入输入模式
- (void)adjustVisibleRegion:(CGFloat)_slideUpHeight {
  //if (currentInputType == InputType_Inputing)
  //  return;

  //  self.currentSlideUpHeight = _slideUpHeight;
  [self setCurrentSlideUpHeight:_slideUpHeight];
  CGRect _frame      = self.frame;
  _frame.size.height = [self originalFrame].size.height - self.currentSlideUpHeight;
  self.frame         = _frame;
  [self setCurrentInputType:TableInputType_Inputing];

  //调整scrollView的offset位置
  if ([self currentInputType] == TableInputType_Inputing) {
    CGFloat offset         = self.contentOffset.y;
    CGFloat dyNeedToScroll = [self offsetHeight];
    CGFloat ret_height  = dyNeedToScroll + offset;
    CGPoint screenPoint = [self touchScreenPoint];
    
    NSLog(@"screenPoint==%@", NSStringFromCGPoint(screenPoint));
    NSLog(@"H==%f", H);
    NSLog(@"upHeight==%f", [self currentSlideUpHeight]);
    
    if (dyNeedToScroll > 0 &&
        screenPoint.y > (H-[self currentSlideUpHeight])) {
      
      // 如果是数字键盘的话就需要添加确定按钮
//      CGFloat _flt = [self keyboardType] == UIKeyboardTypeNumberPad ? (150 * ratioH) : 0;
      [self setContentOffset:CGPointMake(0, ret_height + 50 * ratioH) animated:YES];
    } else {
      
    }
  }
}

#pragma mark - 恢复scrolview到初始状态
- (void)resetVisibleRegion {
  //  if (curr\entInputType == InputType_Inital)
  //    return;
  NSLog(@"originalFrame=%@", NSStringFromCGRect([self originalFrame]));
  CGRect _frame      = self.frame;
  _frame.size.height = [self originalFrame].size.height;
  self.frame         = _frame;
  self.contentSize   = [self origianlContentSize]; //self.bounds.size;
                                                   //  self.currentInputType = TableInputType_Inital;

  [self setCurrentInputType:TableInputType_Inital];
}

#pragma mark - 为数字键盘添加确定按钮栏
- (void)action_addDoneBarForNumberPad {
  UIView *_view_bar = [[UIView alloc] initWithFrame:CGRectMake(0, H - [self currentSlideUpHeight], W, 50*ratioH)];
  _view_bar.backgroundColor = color_calendar_lightGray;
  _view_bar.tag = TAG_DONEBAR;
  
  //添加按钮
  UIButton *_btn_done = [UIButton buttonWithType:UIButtonTypeCustom];
  [_btn_done setShowsTouchWhenHighlighted:YES];
  [_btn_done setTitle:multiLanguage(@"Done") forState:UIControlStateNormal];
  [_btn_done setTitle:multiLanguage(@"Done") forState:UIControlStateHighlighted];
  [_btn_done setTitleColor:color_homepage_black forState:UIControlStateNormal];
  [[_btn_done titleLabel] setFont:font(FONT_TEXT_REGULAR, 18)];
  _btn_done.frame = CGRectMake(W-60, 5, 50, 40);
  [_btn_done addTarget:self action:@selector(buttonAction_resignKeyboard) forControlEvents:UIControlEventTouchUpInside];
  [_view_bar addSubview:_btn_done];
  [appDelegate.window addSubview:_view_bar];
}

- (void)action_removeDoneBarForNumberPad {
  [[appDelegate.window viewWithTag:TAG_DONEBAR] removeFromSuperview];
}

#pragma mark - 按钮事件
- (void)buttonAction_resignKeyboard {
  if ([self keyboardType] == UIKeyboardTypeNumberPad) {
    [self action_removeDoneBarForNumberPad];
  }
  
  [self resetVisibleRegion];
  UITextField *_tf = [self textField];
  if (_tf)
    [_tf resignFirstResponder];
}

#pragma mark - 这个方法指定子视图滚动到底部 如果需要的话
#pragma mark - 这个方法必须在 adjustVisibleRegion 之后调用 adjustVisibleRegion方法指定了现在是输入模式的状态
- (void)scrollSubViewToBottomIfNeeded:(UIView *)_view_subviewOfScrollView heightOccupied:(CGFloat)_heightOccupied //告知这个view占用了多少高度
{
  if ([self currentInputType] == TableInputType_Inputing) {
    if ([_view_subviewOfScrollView isDescendantOfView:self]) {
      CGPoint currentCoordinatePoint = [self convertPoint:_view_subviewOfScrollView.frame.origin toView:self]; //把子视图的坐标转换到本坐标系统中
      NSLog(@"currentCoordinatePoint = %@", NSStringFromCGPoint(currentCoordinatePoint));
      if (currentCoordinatePoint.y + _heightOccupied > self.frame.size.height /*已经调整过高度了*/) {
        CGFloat dyNeedToScroll = currentCoordinatePoint.y - self.frame.size.height + _heightOccupied;
        NSLog(@"dyNeedToScroll = %f , _heightOccupied = %f", dyNeedToScroll, _heightOccupied);
        [self setContentOffset:CGPointMake(0, dyNeedToScroll) animated:YES];
      }
    }
  }
}

- (void)AOP_touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if ([self isAllowScrollAuto]) {
    UITouch *touch      = [touches anyObject];
    CGPoint touchPoint  = [touch locationInView:self];
    CGPoint screenPoint = [self convertPoint:touchPoint toView:appDelegate.window];
    NSLog(@"screenPoint:%f==%f", screenPoint.x, screenPoint.y);
    [self setTouchScreenPoint:screenPoint];
    CGFloat ret = ([self currentSlideUpHeight] - (H - screenPoint.y));
    [self setoffsetHeight:ret < 0 ? 0 : ret];
  }
  [self AOP_touchesEnded:touches withEvent:event];
}


- (void)setOrigianlContentSize:(CGSize)size {
  if (CGSizeEqualToSize(size, CGSizeZero)) {
    objc_setAssociatedObject(self, &TAG_origianlContentSize, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_origianlContentSize, NSStringFromCGSize(size), OBJC_ASSOCIATION_RETAIN);
}

- (CGSize)origianlContentSize {
  return CGSizeFromString(objc_getAssociatedObject(self, &TAG_origianlContentSize));
}

- (void)setOriginalFrame:(CGRect)rect {
  if (CGRectIsEmpty(rect)) {
    objc_setAssociatedObject(self, &TAG_originalFrame, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }

  objc_setAssociatedObject(self, &TAG_originalFrame, NSStringFromCGRect(rect), OBJC_ASSOCIATION_RETAIN);
}

- (CGRect)originalFrame {
  return CGRectFromString(objc_getAssociatedObject(self, &TAG_originalFrame));
}

- (void)setCurrentSlideUpHeight:(CGFloat)height {
  if (height < 0) {
    objc_setAssociatedObject(self, &TAG_currentSlideUpHeight, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_currentSlideUpHeight, [NSNumber numberWithFloat:height], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)currentSlideUpHeight {
  return [objc_getAssociatedObject(self, &TAG_currentSlideUpHeight) floatValue];
}

- (void)setCurrentInputType:(TableInputType)style {
  if (style == TableInputType_None) {
    objc_setAssociatedObject(self, &TAG_currentInputType, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_currentInputType, [NSNumber numberWithInt:style], OBJC_ASSOCIATION_RETAIN);
}

- (TableInputType)currentInputType {
  return [objc_getAssociatedObject(self, &TAG_currentInputType) intValue];
}

- (void)setTableViewInputDelegate:(id<TableViewInputDelegate>)delegate {
  objc_setAssociatedObject(self, &TAG_tableViewInputDelegate, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<TableViewInputDelegate>)tableViewInputDelegate {
  return objc_getAssociatedObject(self, &TAG_tableViewInputDelegate);
}

- (void)setIsAllowScrollAuto:(TableISAllowAutoScroll)isAllowScrollAuto {
  if (isAllowScrollAuto == isAllowAutoScroll_none) {
    objc_setAssociatedObject(self, &TAG_isAllowScrollAuto, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }

  objc_setAssociatedObject(self, &TAG_isAllowScrollAuto, [NSNumber numberWithBool:isAllowScrollAuto == isAllowAutoScroll_yes ? YES : NO], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isAllowScrollAuto {
  return objc_getAssociatedObject(self, &TAG_isAllowScrollAuto);
}

- (void)setoffsetHeight:(CGFloat)height {
  if (height < 0) {
    objc_setAssociatedObject(self, &TAG_offsetHeight, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_offsetHeight, [NSNumber numberWithFloat:height], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)offsetHeight {
  return [objc_getAssociatedObject(self, &TAG_offsetHeight) floatValue];
}

- (void)setTouchScreenPoint:(CGPoint)point {
  if (CGPointEqualToPoint(CGPointZero, point)) {
    objc_setAssociatedObject(self, &TAG_touchScreenPoint, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_touchScreenPoint, NSStringFromCGPoint(point), OBJC_ASSOCIATION_RETAIN);
}

- (CGPoint)touchScreenPoint {
  return CGPointFromString(objc_getAssociatedObject(self, &TAG_touchScreenPoint));
}

- (void)setKeyboardType:(NSInteger)type {
  if (type < 0) {
    objc_setAssociatedObject(self, &TAG_keyboardType, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_keyboardType, [NSNumber numberWithInteger:type], OBJC_ASSOCIATION_RETAIN);
}

- (UIKeyboardType)keyboardType {
  return [objc_getAssociatedObject(self, &TAG_keyboardType) integerValue];
}


- (void)setTextField:(UITextField *)_tf {
  if (_tf == nil) {
    objc_setAssociatedObject(self, &TAG_textField, nil, OBJC_ASSOCIATION_RETAIN);
    return;
  }
  objc_setAssociatedObject(self, &TAG_textField, _tf, OBJC_ASSOCIATION_RETAIN);
}

- (UITextField *)textField {
  return objc_getAssociatedObject(self, &TAG_textField);
}
@end
