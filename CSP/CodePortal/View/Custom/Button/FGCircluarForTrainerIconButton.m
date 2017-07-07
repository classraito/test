//
//  FGCircluarForTrainerIconButton.m
//  CSP
//
//  Created by JasonLu on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCircluarForTrainerIconButton.h"

@implementation FGCircluarForTrainerIconButton
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.lb_title.hidden = NO;
  self.btn.showsTouchWhenHighlighted = NO;
}

- (void)setupButtonInfoWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleAlignment:(VerticalAlignment)alignment buttonImageName:(NSString *)imgName {
  self.lb_title.text      = title;
  self.lb_title.textColor = titleColor;
  [self.lb_title setVerticalAlignment:alignment];
  
  [self.vi_icon sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:IMG_PLACEHOLDER];
}
@end
