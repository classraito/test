//
//  FGCircluarForUserIconButton.m
//  CSP
//
//  Created by JasonLu on 17/1/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCircluarForUserIconButton.h"

@implementation FGCircluarForUserIconButton

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.lb_title.hidden = YES;
//  NSString *_str_filePath = [FGUtils pathInDocumentsWithFileName:[NSString stringWithFormat:@"%@.%@",USERAVATAR, AVATARTYPE]];
  self.vi_icon.image = [UIImage imageNamed:@"ic_user_default"];
}

- (void)setupButtonInfoWithImageName:(NSString *)imgName {
  
  if ([imgName hasPrefix:@"http:"])
    [self.vi_icon sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:IMGWITHNAME(@"ic_user_default")];
  else
    self.vi_icon.image = IMAGEWITHPATH(imgName);
}

- (void)setIconButtonTouchWhenHighlighted:(BOOL)isHighlighted {
  [self.btn setShowsTouchWhenHighlighted:isHighlighted];
}

- (void)setupButtonInfoWithImage:(UIImage *)_img {
  self.vi_icon.image = _img;
}

//- (void)drawRect:(CGRect)rect {
//  [super drawRect:rect];
//  
//  CGRect frame       = self.vi_icon.frame;
//  self.vi_icon.frame = CGRectMake(frame.origin.x, (self.bounds.size.height - self.vi_icon.bounds.size.height) / 2, frame.size.width, frame.size.height);
//}

@end
