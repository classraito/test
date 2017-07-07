//
//  FGMyBookingBundleForCouponCellView.m
//  CSP
//
//  Created by JasonLu on 16/12/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGMyBookingBundleForCouponCellView.h"
#import "UIView+CornerRaduis.h"
@implementation FGMyBookingBundleForCouponCellView
@synthesize lb_title;
@synthesize view_sepeator;

@synthesize view_blackBg;
@synthesize view_whiteBg;
@synthesize btn_useNow;
@synthesize lb_content;
@synthesize iv_gift;

@synthesize delegate;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
  [commond useDefaultRatioToScaleView:view_sepeator];
  [commond useDefaultRatioToScaleView:lb_title];
  
  [commond useDefaultRatioToScaleView:view_blackBg];
  [commond useDefaultRatioToScaleView:view_whiteBg];
  [commond useDefaultRatioToScaleView:btn_useNow];
  [commond useDefaultRatioToScaleView:lb_content];
  [commond useDefaultRatioToScaleView:iv_gift];
  
  self.lb_title.font = font(FONT_TEXT_BOLD, 18);
  self.lb_title.textColor = color_homepage_black;
  self.lb_title.text = multiLanguage(@"YOUR COUPON");
  [self.view_whiteBg makeWithCornerRadius:5];
  [self.btn_useNow makeWithCornerRadius:self.btn_useNow.bounds.size.height / 2];
  
  [self.btn_useNow addTarget:self action:@selector(buttonAction_useCouponNow:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn_useNow setTitle:multiLanguage(@"USE NOW") forState:UIControlStateNormal];
    [self.btn_useNow setTitle:multiLanguage(@"USE NOW") forState:UIControlStateHighlighted];
}

-(void)updateCellViewWithInfo:(id)_dataInfo {
  NSLog(@"_dataInfo=%@",_dataInfo);
  BOOL _bool_hidden = [_dataInfo[@"hidden"] boolValue];
  if (_bool_hidden) {
    self.hidden = YES;
    return;
  }
  
  
  NSInteger _int_currentIndex = [_dataInfo[@"currentIndex"] integerValue];
  id _hasInvitationCoupon = _dataInfo[@"hasInvitationCoupon"];
  if (!ISNULLObj(_hasInvitationCoupon)) {
    NSInteger _int_invitationIndex = [_dataInfo[@"InvitationCouponIndex"] integerValue];
    BOOL _bool_hasInvitationCoupon = [_hasInvitationCoupon boolValue];
    if (_bool_hasInvitationCoupon && _int_currentIndex == _int_invitationIndex) {
      self.view_blackBg.backgroundColor = rgb(55, 151, 147);
    }
  }
  
  NSInteger _int_couponValue = [_dataInfo[@"couponValue"] integerValue];
  NSString *_str_couponValue = [NSString stringWithFormat:@"¥ %ld", _int_couponValue];
  NSString *_str_content = _dataInfo[@"content"];
  
  NSArray *_arr_infos = @[
                          [FGUtils createAttributeTextInfo:_str_couponValue font:font(FONT_TEXT_BOLD, 24) color:color_homepage_black paragraphSpacing:6 lineSpacing:6 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"],
                          [FGUtils createAttributeTextInfo:_str_content font:font(FONT_TEXT_REGULAR, 16) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:3 textAlignment:NSTextAlignmentCenter sepeatorByString:@"\n"]];
  NSMutableAttributedString *mattr_str = [FGUtils createAttributedStringWithContentInfo:_arr_infos];
  self.lb_content.attributedText = mattr_str;
  
  self.hidden = NO;
}

- (void)buttonAction_useCouponNow:(id)sender {
  if (self.delegate) {
    [self.delegate action_didClickToUseCoupon:sender];
  }
}

@end
