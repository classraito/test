//
//  UIView+CornerRaduis.m
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "UIView+CornerRaduis.h"

@implementation UIView (CornerRaduis)
- (void)makeWithCornerRadius:(float)raduis {
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius  = raduis;
}
@end
