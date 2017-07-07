//
//  FGLoginView.m
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

//#import "QQApiWrapper.h"
//#import "FBApiWrapper.h"
#import "FGAlignmentLabel.h"
#import "FGCustomUnderlineButton.h"
#import "FGLoginInputView.h"
#import "FGLoginView.h"
#import "FGTimeCounterLabel.h"
#import "Global.h"
#import "NetworkManager_Training.h"

#import "UIButton+DefineStyle.h"
#import "UIView+CornerRaduis.h"
#import <Social/Social.h>

#define VIEW_MOBILE_TAG 100
#define VIEW_VERCODE_TAG 101

@interface FGLoginView () {
}
@end
@implementation FGLoginView

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [self internalInitalLoginView];
}
#pragma mark - 自定义方法
- (void)internalInitalLoginView {
  [commond useDefaultRatioToScaleView:self.iv_bg];
  [commond useDefaultRatioToScaleView:self.iv_logo];
  [commond useDefaultRatioToScaleView:self.btn_getStarted];
  [commond useDefaultRatioToScaleView:self.view_needhelp];
  [commond useDefaultRatioToScaleView:self.btn_login_qq];
  [commond useDefaultRatioToScaleView:self.btn_login_sina];
  [commond useDefaultRatioToScaleView:self.btn_login_wechat];
  [commond useDefaultRatioToScaleView:self.btn_login_fb];
  //[commond useDefaultRatioToScaleView:self.btn_sendsmscode];
  [commond useDefaultRatioToScaleView:self.view_sendsmsCode];
  [commond useDefaultRatioToScaleView:self.lb_or];
  [commond useDefaultRatioToScaleView:self.lb_title];
  [commond useDefaultRatioToScaleView:self.lb_smsTimeCounter];
  [commond useDefaultRatioToScaleView:self.view_mobile];
  [commond useDefaultRatioToScaleView:self.view_smscode];

    self.lb_title.text = multiLanguage(@"Register / Login with Mobile");
  self.lb_title.font = font(FONT_TEXT_REGULAR, 18);
  self.lb_or.text    = multiLanguage(@"or");
  self.lb_or.font    = font(FONT_TEXT_BOLD, 18);

    [self createLoginInputViewWithIcon:@"lg_icon_phone" placeholder:multiLanguage(@"Enter mobile number here") viewTag:VIEW_MOBILE_TAG inParentView:self.view_mobile];
  [self createLoginInputViewWithIcon:@"lg_icon_smscode" placeholder:multiLanguage(@"SMS Code") viewTag:VIEW_VERCODE_TAG inParentView:self.view_smscode];

  [self.view_needhelp.btn setTitle:multiLanguage(@"SKIP") forState:UIControlStateNormal];
  self.view_needhelp.btn.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
  [self.view_needhelp setupStyleWithButtonColor:[UIColor whiteColor] underlineColor:[UIColor clearColor]];

    [self.btn_getStarted setTitle:multiLanguage(@"GET STARTED") forState:UIControlStateNormal];
    [self.btn_getStarted setTitle:multiLanguage(@"GET STARTED") forState:UIControlStateHighlighted];
    
  self.btn_getStarted.titleLabel.font = font(FONT_TEXT_REGULAR, 19);
  [self.btn_getStarted makeWithCornerRadius:self.btn_getStarted.bounds.size.height / 2];

  [self.view_sendsmsCode.btn setTitle:multiLanguage(@"Send to me") forState:UIControlStateNormal];
  [self.view_sendsmsCode setupStyleWithButtonColor:[UIColor whiteColor] underlineColor:[UIColor whiteColor]];
  self.view_sendsmsCode.btn.titleLabel.font = font(FONT_TEXT_REGULAR, 15);
  [self.view_sendsmsCode.btn addTarget:self action:@selector(buttonAction_sendsmscode:) forControlEvents:UIControlEventTouchUpInside];
  [self internalInitalStartSMSCodeRecover];
}

- (void)internalInitalStartSMSCodeStartCount {
  self.lb_smsTimeCounter.hidden = NO;
  self.view_sendsmsCode.hidden  = YES;
  [self.view_smscode bringSubviewToFront:self.lb_smsTimeCounter];

  __weak FGLoginView *weakSelf = self;
  [self.lb_smsTimeCounter startCounterWithTime:60 timeInterval:1.0f completionHandler:^{
    [weakSelf internalInitalStartSMSCodeRecover];
  }];
}

- (void)internalInitalStartSMSCodeRecover {
  self.view_sendsmsCode.hidden = NO;
  [self.view_smscode bringSubviewToFront:self.view_sendsmsCode];
  self.lb_smsTimeCounter.hidden = YES;
}

- (void)createLoginInputViewWithIcon:(NSString *)icon placeholder:(NSString *)placeholder viewTag:(NSInteger)viewTag inParentView:(UIView *)parentView {
  FGLoginInputView *mobileInputView = (FGLoginInputView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLoginInputView" owner:nil options:nil] objectAtIndex:0];
  [mobileInputView updateViewWithIcon:icon Placeholder:placeholder];
  mobileInputView.tag = viewTag;
  [parentView addSubview:mobileInputView];
}

- (void)refreshData {
  FGLoginInputView *inputView = [self loginInputViewInParentView:self.view_mobile withTag:VIEW_MOBILE_TAG];
  NSString *_str_mobileForLogin = [NSString stringWithFormat:@"%@",[commond getUserDefaults:MOBILEFORLOGIN]];
  if (ISEXISTObj(_str_mobileForLogin)) {
    [inputView updateTFWithString:_str_mobileForLogin];
  }
}


- (FGLoginInputView *)loginInputViewInParentView:(UIView *)parentView withTag:(NSInteger)tag {
  return [parentView viewWithTag:tag];
}

- (IBAction)buttonAction_sendsmscode:(id)sender {
  NSString *_str_mobile      = @"";
  NSString *str_errorMessage = @"";
  BOOL isError               = [self isErrorPhoneNumber:&_str_mobile withErrorMessage:&str_errorMessage];
  if (isError) {
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(str_errorMessage) callback:nil];
    return;
  }

  [self internalInitalStartSMSCodeStartCount];
  NetworkManager_User *networkManager_User = (NetworkManager_User *)[NetworkManager_User sharedManager];
  [networkManager_User postRequest_SendVCodeMobileLogin:_str_mobile userinfo:nil];
}

- (IBAction)buttonAction_getStarted:(id)sender {
  NSString *_str_mobile = @"";
  NSString *_str_vcode  = @"";

  NSString *str_errorMessage = @"";
  BOOL isError               = [self isErrorPhoneNumber:&_str_mobile withErrorMessage:&str_errorMessage];
  if (isError) {
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(str_errorMessage) callback:nil];
    return;
  }
  isError = [self isErrorVerCode:&_str_vcode withErrorMessage:&str_errorMessage];
  if (isError) {
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(str_errorMessage) callback:nil];
    return;
  }
  
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"verifyCodeMobileLogin" forKey:@"verifyCodeMobileLogin"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [_dic_info setObject:_str_mobile forKey:MOBILEFORLOGIN];
  NetworkManager_User *networkManager_User = (NetworkManager_User *)[NetworkManager_User sharedManager];
  [networkManager_User postRequest_VerifyCodeMobileLogin:_str_mobile vCode:_str_vcode userinfo:_dic_info];
}

- (BOOL)isErrorPhoneNumber:(NSString **)mobile withErrorMessage:(NSString **)message {
  FGLoginInputView *inputView = [self loginInputViewInParentView:self.view_mobile withTag:VIEW_MOBILE_TAG];
  NSString *_str_mobile       = [inputView inputStr];
  NSString *str_errorMessage  = @"";

  *mobile  = _str_mobile;
  *message = str_errorMessage;

  if ([_str_mobile isEmptyStr]) {
      str_errorMessage = multiLanguage(@"To register, please enter your chinese mobile phone number in the space provided.");
    *message         = str_errorMessage;
  } else if (![_str_mobile isMobileNum]) {
    str_errorMessage = multiLanguage(@"To register, please enter your chinese mobile phone number in the space provided.");
    *message         = str_errorMessage;
  } else
    return NO;

  return YES;
}

- (BOOL)isErrorVerCode:(NSString **)verCode withErrorMessage:(NSString **)message {
  FGLoginInputView *inputView = [self loginInputViewInParentView:self.view_smscode withTag:VIEW_VERCODE_TAG];
  NSString *_str_verifyCode   = [inputView inputStr];
  NSString *str_errorMessage  = @"";

  *verCode = _str_verifyCode;
  *message = str_errorMessage;

  if ([_str_verifyCode length] != 6) {
    str_errorMessage = multiLanguage(@"Verification Code must be 6 digit numbers");
    *message         = str_errorMessage;
  } else
    return NO;

  return YES;
}

//#pragma mark - 测试代码
//- (IBAction)fbShareAction:(id)sender {
//  [[FBApiWrapper shareInstance] fbShareWithTitle:@"我是测试" shareURL:@"http://www.sina.com" sharePreviewURL:@"http://i.imgur.com/g3Qc1HN.png" inVCtrl:self.parentVCtrl];
//}
//
//- (IBAction)qqShareAction:(id)sender {
//  [[QQApiWrapper shareInstance] qqShareWithTitle:@"哈哈哈" desctiption:@"这是测试内容" shareURL:@"http://www.baidu.com/" sharePreviewURL:@"http://img1.gtimg.com/sports/pics/hv1/87/16/1037/67435092.jpg"];
//}

@end
