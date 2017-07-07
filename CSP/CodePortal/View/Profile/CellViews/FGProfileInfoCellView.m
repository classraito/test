//
//  FGProfileInfoCellView.m
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGCircluarWithBottomTitleButton.h"
#import "FGCircluarForUserIconButton.h"
#import "FGProfileInfoCellView.h"
#import "UIImage+BlurEffect.h"
#import "UIImage+SubImage.h"
#import "UITableViewCell+BindDataToUI.h"
#import <Accelerate/Accelerate.h>
#import "Global.h"
@interface FGProfileInfoCellView () {
  CGRect rect_youhuiview;
}
@end

@implementation FGProfileInfoCellView
@synthesize view_useIconAndname;
@synthesize view_youhuibg;
@synthesize iv_bg;

@synthesize btn_follower;
@synthesize btn_post;
@synthesize btn_follow;
@synthesize btn_copyYouhui;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  [commond useDefaultRatioToScaleView:self.iv_bg];
  [commond useDefaultRatioToScaleView:self.view_useIconAndname];
  [commond useDefaultRatioToScaleView:self.lb_edit];
  [commond useDefaultRatioToScaleView:self.btn_follower];
  [commond useDefaultRatioToScaleView:self.btn_follow];
  [commond useDefaultRatioToScaleView:self.btn_post];
  [commond useDefaultRatioToScaleView:self.lb_username];
  [commond useDefaultRatioToScaleView:self.lb_youhuiCode];
  [commond useDefaultRatioToScaleView:self.view_youhuibg];
  [commond useDefaultRatioToScaleView:self.btn_copyYouhui];

  [self.btn_copyYouhui setTitle:multiLanguage(@"Share") forState:UIControlStateNormal];
  [self.btn_copyYouhui setTitle:multiLanguage(@"Share") forState:UIControlStateHighlighted];
  [self.btn_copyYouhui setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.btn_copyYouhui.titleLabel.font          = font(FONT_TEXT_REGULAR, 16);
  [self.btn_copyYouhui addTarget:self action:@selector(buttonAction_copyYouhuiCode:) forControlEvents:UIControlEventTouchUpInside];
  
  self.btn_follower.titleLabel.numberOfLines = 0;
  self.btn_follower.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.btn_follower.titleLabel.textColor     = [UIColor whiteColor];
  self.btn_follower.titleLabel.font          = font(FONT_TEXT_REGULAR, 16);
  self.btn_follower.backgroundColor          = [UIColor clearColor];
  
  self.btn_post.titleLabel.numberOfLines = 0;
  self.btn_post.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.btn_post.titleLabel.textColor     = [UIColor whiteColor];
  self.btn_post.titleLabel.font          = font(FONT_TEXT_REGULAR, 16);
  self.btn_post.backgroundColor          = [UIColor clearColor];
  
  self.btn_follow.titleLabel.numberOfLines = 0;
  self.btn_follow.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.btn_follow.titleLabel.textColor     = [UIColor whiteColor];
  self.btn_follow.titleLabel.font          = font(FONT_TEXT_REGULAR, 16);
  self.btn_follow.backgroundColor          = [UIColor clearColor];
  
  self.view_youhuibg.backgroundColor = [UIColor whiteColor];
  self.view_youhuibg.alpha = 0.5f;
  self.view_youhuibg.layer.cornerRadius = 12.0f;
  self.view_youhuibg.layer.masksToBounds = YES;
  rect_youhuiview = self.view_youhuibg.frame;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 成员方法
- (void)updateCellViewWithInfo:(id)_dataInfo {
  if (_dataInfo == nil)
    return;
  
  
  NSString *username = _dataInfo[@"username"];
  NSString *title    = [NSString stringWithFormat:@"%@", username];

  UIImage *blurImage = _dataInfo[@"imgbg"];
  UIImage *tmpImage  = _dataInfo[@"img"];

  [self.iv_bg setImage:blurImage];
  [self.view_useIconAndname setupButtonInfoWithTitle:title titleColor:[UIColor whiteColor] titleAlignment:VerticalAlignmentBottom textAlignment:NSTextAlignmentCenter buttonImage:tmpImage];
  
  [self.view_useIconAndname setProcessPercent:[_dataInfo[@"percent"] floatValue]];
  [self.view_useIconAndname setupStatusWithShowProcessBg:YES showProcess:YES];
  self.view_useIconAndname.backgroundColor = [UIColor clearColor];
  
  
  self.lb_username.text = username;
  self.lb_username.font      = font(FONT_TEXT_REGULAR, 18);
  self.lb_username.textColor = [UIColor whiteColor];
  self.backgroundColor    = [UIColor clearColor];
  [self.lb_username setTextAlignment:NSTextAlignmentLeft];
  
  self.lb_youhuiCode.text = _dataInfo[@"invitationCode"];//@"tuee8dan899t8";
  self.lb_youhuiCode.font      = font(FONT_TEXT_REGULAR, 16);
  self.lb_youhuiCode.textColor = [UIColor whiteColor];
  [self.lb_youhuiCode setTextAlignment:NSTextAlignmentCenter];
  
  [self.lb_youhuiCode sizeToFit];
  CGSize size_youhuicode = self.lb_youhuiCode.bounds.size;
  self.view_youhuibg.frame = CGRectMake(rect_youhuiview.origin.x-6, rect_youhuiview.origin.y-4, size_youhuicode.width+12, size_youhuicode.height+8);
  self.btn_copyYouhui.frame = CGRectMake(self.view_youhuibg.frame.origin.x + self.view_youhuibg.frame.size.width + 5,   rect_youhuiview.origin.y-4+((size_youhuicode.height+8)/2)-self.btn_copyYouhui.frame.size.height/2
, self.btn_copyYouhui.frame.size.width, self.btn_copyYouhui.frame.size.height);
  
  
  NSString * _str_post = _dataInfo[@"post"];
  NSString * _str_follow = _dataInfo[@"follow"];
  NSString * _str_follower = _dataInfo[@"follower"];
  [self setupPostBtnTitle:_str_post followBtnTitle:_str_follow followerBtnTitle:_str_follower];
  
  self.backgroundColor    = [UIColor clearColor];
}

- (void)setupPostBtnTitle:(NSString *)postTitle followBtnTitle:(NSString *)followTitle followerBtnTitle:(NSString *)followerTitle {
 ;
  [self.btn_post setTitle: [NSString stringWithFormat:@"%@\n%@", postTitle, multiLanguage(@"Post")] forState:UIControlStateNormal];
  [self.btn_follow setTitle: [NSString stringWithFormat:@"%@\n%@", followTitle, multiLanguage(@"Follow")] forState:UIControlStateNormal];
  [self.btn_follower setTitle: [NSString stringWithFormat:@"%@\n%@", followerTitle, multiLanguage(@"Follower")] forState:UIControlStateNormal];
}

- (void)buttonAction_copyYouhuiCode:(id)sender {
  
  UIViewController *_vc;
  for (UIView* next = [self superview]; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
//      return (UIViewController*)nextResponder;
      _vc = (UIViewController*)nextResponder;
      break;
    }
  }
  
  [[FGSNSManager shareInstance] actionToShareInviateCodeOnView:_vc.view title:share_inviationCode_title text:[NSString stringWithFormat:@"%@;%@;%@%@",share_inviationCode_content1,share_inviationCode_content2,multiLanguage(@"Invitation code:"), self.lb_youhuiCode.text] url:share_inviationCode_link inviateCode:self.lb_youhuiCode.text];
  
  
//  NSLog(@"youhuiCode=%@",self.lb_youhuiCode);
//  //  通用的粘贴板
//  UIPasteboard *pBoard = [UIPasteboard generalPasteboard];
//  pBoard.string = self.lb_youhuiCode.text;
//  
//  //显示提示信息
//  [commond showHUDAfterCopyToClipboardWithMessage:multiLanguage(@"Copied to clipboard")];
}
@end
