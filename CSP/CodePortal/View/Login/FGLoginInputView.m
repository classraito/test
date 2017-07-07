//
//  FGLoginInputView.m
//  CSP
//
//  Created by JasonLu on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLoginInputView.h"
#import "UIView+CornerRaduis.h"

@interface FGLoginInputView ()

@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_icon;
@property (weak, nonatomic) IBOutlet UITextField *tf_input;

@end

@implementation FGLoginInputView
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [self internalInitalLoginInputView];
}

#pragma mark - 私有方法
- (void)internalInitalLoginInputView {
  [commond useDefaultRatioToScaleView:self.iv_bg];
  [commond useDefaultRatioToScaleView:self.iv_icon];
  [commond useDefaultRatioToScaleView:self.tf_input];

  self.iv_bg.image   = IMGWITHNAME(@"btn_bg");
  [self.iv_bg makeWithCornerRadius:self.iv_bg.bounds.size.height / 2];

  self.tf_input.font = font(FONT_TEXT_REGULAR, 18);
}

- (void)updateViewWithIcon:(NSString *)iconName Placeholder:(NSString *)str {
  self.iv_icon.image                  = IMGWITHNAME(iconName);
  self.tf_input.attributedPlaceholder = [[NSAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

#pragma mark - 成员方法
- (NSString *)inputStr {
  if (ISNULLObj([self.tf_input text]))
    return @"";
  return [self.tf_input text];
}

- (void)updateTFWithString:(NSString *)_str {
  self.tf_input.text = _str;
}
@end
