//
//  FGUserInputPageBaseView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"
#import "Global.h"
@interface FGUserInputPageBaseView () {
    CGRect originalFrame;
    CGSize origianlContentSize;
    
}
@end

@implementation FGUserInputPageBaseView
@synthesize currentSlideUpHeight;
@synthesize currentInputType;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  currentInputType = InputType_Inital;

  //注册键盘事件
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  /*点击取消键盘*/
  UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getsture_cancelKeyboard:)];
  _tap.cancelsTouchesInView    = NO;
  _tap.delegate                = self;
  [self addGestureRecognizer:_tap];

  currentSlideUpHeight = [self normalKeyboardHeight]; //获取当前设备键盘高度
    
    
}

-(void)setupByOriginalContentSize:(CGSize)_contentSize
{
    self.contentSize = _contentSize;
    origianlContentSize = _contentSize;
    originalFrame = self.frame;
}

-(void)bindDataToUI:(NSMutableArray *)_arr_imgs videoFilePath:(NSString *)_str_filePath
{
    if(_arr_imgs)
    {
        
    }
    
    if(_str_filePath)
    {
        
    }
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)layoutSubviews {
  //static dispatch_once_t onceToken;
//  dispatch_once(&onceToken, ^{
    [commond setTextFieldDelegate:self inView:self];
//  });
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


#pragma mark - 键盘相关回调
- (void)keyboardWillShow:(NSNotification *)notification {
  [self removeAllInputView];
  NSDictionary *info = [notification userInfo];
  NSLog(@"info = %@", info);
  CGSize kbSize        = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  currentSlideUpHeight = kbSize.height;

  /*if (currentSlideUpHeight < [self normalKeyboardHeight]) {
    currentSlideUpHeight = [self normalKeyboardHeight];
  }*/

  [self adjustVisibleRegion:currentSlideUpHeight];

  
  
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
  [self resetVisibleRegion];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  return YES;
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
}

#pragma mark - 根据弹出的键盘或view 调整scrollview 的高度 并且进入输入模式
- (void)adjustVisibleRegion:(CGFloat)_slideUpHeight {
  //if (currentInputType == InputType_Inputing)
  //  return;
    
  currentSlideUpHeight = _slideUpHeight;
  CGRect _frame        = self.frame;
  _frame.size.height = originalFrame.size.height - currentSlideUpHeight;
  self.frame       = _frame;
  currentInputType = InputType_Inputing;
    
  NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
}

#pragma mark - 恢复scrolview到初始状态
- (void)resetVisibleRegion {
   
  //  if (currentInputType == InputType_Inital)
  //    return;

  CGRect _frame = self.frame;
  _frame.size.height = originalFrame.size.height;
  self.frame       = _frame;
  self.contentSize = self.bounds.size;
  currentInputType = InputType_Inital;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
  [textField resignFirstResponder];
  return YES;
}

#pragma mark - 滚动到底部
- (void)scrollsToBottomAnimated:(BOOL)animated
{
    CGFloat offset = self.contentSize.height - self.bounds.size.height;
    if (offset > 0)
    {
        
        [self setContentOffset:CGPointMake(0, offset) animated:animated];
    }
}

#pragma mark - 这个方法指定子视图滚动到底部 如果需要的话
#pragma mark - 这个方法必须在 adjustVisibleRegion 之后调用 adjustVisibleRegion方法指定了现在是输入模式的状态
- (void)scrollSubViewToBottomIfNeeded:(UIView *)_view_subviewOfScrollView heightOccupied:(CGFloat)_heightOccupied //告知这个view占用了多少高度
{
  if (currentInputType == InputType_Inputing) {
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
@end
