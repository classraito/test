//
//  UIView+ViewController.m
//  CSP
//
//  Created by JasonLu on 16/10/31.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)
#pragma mark - 获取UIViewController
- (UIViewController*)viewController {
  for (UIView* next = [self superview]; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}@end
