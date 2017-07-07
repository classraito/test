//
//  FGCircluarWithRightButton.m
//  CSP
//
//  Created by JasonLu on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircluarWithRightButton.h"

@implementation FGCircluarWithRightButton

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  CGRect frame       = self.vi_icon.frame;
  self.vi_icon.frame = CGRectMake(frame.origin.x, (self.bounds.size.height - self.vi_icon.bounds.size.height) / 2, frame.size.width, frame.size.height);

  frame               = self.lb_title.frame;
  self.lb_title.frame = CGRectMake(frame.origin.x, self.bounds.size.height / 2 - frame.size.height, frame.size.width, frame.size.height);

  frame          = self.btn.frame;
  self.btn.frame = CGRectMake(frame.origin.x, self.bounds.size.height / 2, frame.size.width, frame.size.height);
}

@end
