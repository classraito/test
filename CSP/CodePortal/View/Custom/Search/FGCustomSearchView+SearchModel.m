//
//  FGCustomSearchView+SearchModel.m
//  CSP
//
//  Created by JasonLu on 16/10/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCustomSearchView+SearchModel.h"
#define CANCELBUTTONTAG 100

@implementation FGCustomSearchView (SearchModel)
- (void)setupSearchModelWithFrame:(CGRect)frame padding:(UIEdgeInsets)padding searchCancleButtonTitle:(NSString *)title withAnimated:(BOOL)isAnimation {
  self.backgroundColor = rgb(180, 20, 35);

  CGRect searchIconFrame = self.iv_searchIcon.frame;
  CGRect textfieldFrame  = self.tf_search.frame;

  CGRect newSearchIconFrame = CGRectMake(padding.left, searchIconFrame.origin.y, searchIconFrame.size.width, searchIconFrame.size.height);
  searchIconFrame           = newSearchIconFrame;
  CGRect newSearchTFFrame   = CGRectMake(newSearchIconFrame.origin.x + newSearchIconFrame.size.width + 4, textfieldFrame.origin.y, (frame.size.width - searchIconFrame.size.width - searchIconFrame.origin.x - padding.right - padding.left - 4), textfieldFrame.size.height);
  textfieldFrame            = newSearchTFFrame;
  CGRect viewbgFrame        = CGRectMake(padding.left - 2, textfieldFrame.origin.y, textfieldFrame.size.width + padding.left + searchIconFrame.size.width - padding.left - 2, self.view_bg.frame.size.height);
  //如果title不为空添加按钮
  if (title != nil) {
    self.isEditing   = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(searchDidCancle:) forControlEvents:UIControlEventTouchUpInside];
    button.showsTouchWhenHighlighted = YES;
    button.frame                     = CGRectMake(viewbgFrame.origin.x + viewbgFrame.size.width + 5, 0, frame.size.width - (viewbgFrame.origin.x + viewbgFrame.size.width + 5 + padding.left), self.bounds.size.height);
    button.tag                       = CANCELBUTTONTAG;
    [self addSubview:button];
  }

  if (isAnimation) {
    [UIView animateWithDuration:.3 animations:^{
      self.frame               = frame;
      self.view_bg.frame       = viewbgFrame;
      self.tf_search.frame     = newSearchTFFrame;
      self.iv_searchIcon.frame = newSearchIconFrame;
    }
        completion:^(BOOL finished) {
          NSLog(@"animation finish...");
        }];
  }
}

- (void)setupOriginStyle {
  [[self viewWithTag:CANCELBUTTONTAG] removeFromSuperview];
  [UIView animateWithDuration:.3 animations:^{
    self.frame               = self.rect_originSelfFrame;
    self.iv_searchIcon.frame = self.rect_originSearchIcon;
    self.tf_search.frame     = self.rect_originSearchTF;
    self.view_bg.frame       = self.rect_originViewBgFrame;
  }
      completion:^(BOOL finished) {
        NSLog(@"animation finish...");
        [self.tf_search resignFirstResponder];
      }];
}

- (void)searchDidCancle:(UITextField *)textFiled {
  self.isEditing = NO;
  [self setupOriginStyle];

  [self.delegate searchDidCancle];
}

- (void)searchDidSearch {
  self.isEditing = NO;
  //  [self setupOriginStyle];
}
@end
