//
//  FGCircluarWithRightTitleButton.m
//  CSP
//
//  Created by JasonLu on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCircluarWithRightTitleButton.h"

@implementation FGCircluarWithRightTitleButton
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
//  [commond useDefaultRatioToScaleView:self.lb_youhuiCode];
//  self.lb_youhuiCode.font      = font(FONT_TEXT_REGULAR, 14);
//  self.lb_youhuiCode.textColor = color_homepage_black;
//  self.backgroundColor    = [UIColor clearColor];
//  [self.lb_youhuiCode setTextAlignment:NSTextAlignmentLeft];
}



- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  CGRect frame       = self.vi_icon.frame;
  self.vi_icon.frame = CGRectMake(frame.origin.x, (self.bounds.size.height - self.vi_icon.bounds.size.height) / 2, frame.size.width, frame.size.height);
  
  frame               = self.lb_title.frame;
  self.lb_title.frame = CGRectMake(frame.origin.x, (self.bounds.size.height - self.lb_title.bounds.size.height) / 2, frame.size.width, frame.size.height);
}
@end
