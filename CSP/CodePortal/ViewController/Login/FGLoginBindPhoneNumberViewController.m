//
//  FGLoginBindPhoneNumberViewController.m
//  CSP
//
//  Created by JasonLu on 17/2/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLoginBindPhoneNumberViewController.h"
#import "FGBindPhoneNumberViewController.h"

@interface FGLoginBindPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;

@end

@implementation FGLoginBindPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  // Do any additional setup after loading the view from its nib.
  [commond useDefaultRatioToScaleView:self.iv_bg];
  
  [self internalInitalStartSMSCodeRecover];
  
  self.tf_phoneNumber.userInteractionEnabled = YES;
  self.tf_phoneNumber.textColor = [UIColor whiteColor];
  self.tf_smsCode.textColor = [UIColor whiteColor];
  
  self.lb_key_phoneNumber.text = multiLanguage(@"Phone Number");
  self.lb_key_phoneNumber.textColor = [UIColor whiteColor];
  self.lb_key_smsCode.textColor = [UIColor whiteColor];
  [self.btn_next setTitle:multiLanguage(@"NEXT") forState:UIControlStateNormal];
  [self.btn_next setTitle:multiLanguage(@"NEXT") forState:UIControlStateHighlighted];
  
  [self.cub_sendToMe setupStyleWithButtonColor:[UIColor whiteColor] underlineColor:[UIColor whiteColor]];
  
  [self.tf_smsCode setValue:color_calendar_timePassed forKeyPath:@"_placeholderLabel.textColor"];
  [self.tf_phoneNumber setValue:color_calendar_timePassed forKeyPath:@"_placeholderLabel.textColor"];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  SAFE_RemoveSupreView(self.view_topPanel);
  [self hideBottomPanelWithAnimtaion:NO];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonAction_next:(id)_sender;
{
  if([self isErrorVerCode:self.tf_smsCode.text])
  return;
  
  NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
  [[NetworkManager_User sharedManager] postRequest_USER_VerifyCodeBindingMobile:self.tf_smsCode.text mobile:self.tf_phoneNumber.text userinfo:_dic_info];
}

-(void)buttonAction_sendToMe:(id)_sender
{
  if(![self isErrorPhoneNumber:self.tf_phoneNumber.text])
  {
    [self internalInitalStartSMSCodeStartCount];
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_User sharedManager] postRequest_USER_SendVCodeBindingMobile:self.tf_phoneNumber.text userinfo:_dic_info]; //发送验证码
  }
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  
  //向旧手机号发送验证码
  if ([HOST(URL_USER_SendVCodeBindingMobile) isEqualToString:_str_url]) {
    
  }
  
  if([HOST(URL_USER_VerifyCodeBindingMobile) isEqualToString:_str_url])
  {
    
    [self go2LoginInputNickname];
//    if ([HOST(URL_USER_SetUserProfile) isEqualToString:_str_url]) {
//      FGLoginInputInvitationCodeViewController *vc_inputInvitation = [[FGLoginInputInvitationCodeViewController alloc] initWithNibName:@"FGLoginInputInvitationCodeViewController" bundle:nil];
//      FGControllerManager *manager = [FGControllerManager sharedManager];
//      [manager pushController:vc_inputInvitation navigationController:nav_current];
    
    
//    }
//    for(UIViewController *_vc in  nav_current.viewControllers)
//    {
//      if([_vc isKindOfClass:[FGProfileEditViewController class]])
//      {
//        FGProfileEditViewController *vc_edit = (FGProfileEditViewController *)_vc;
//        [nav_current popToViewController:vc_edit animated:YES];
//      }
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UpdateUserMobile object:self.tf_phoneNumber.text];
  }
  
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
  [super requestFailedFromNetwork:_notification];
}

- (void)go2LoginInputNickname {
  FGLoginInputNicknameViewController *vc_inputInvitation = [[FGLoginInputNicknameViewController alloc] initWithNibName:@"FGLoginInputNicknameViewController" bundle:nil];
  FGControllerManager *manager = [FGControllerManager sharedManager];
  [manager pushController:vc_inputInvitation navigationController:nav_current];
}

- (BOOL)isErrorPhoneNumber:(NSString *)_str_mobile {
  
  NSString *str_errorMessage  = @"";
  
  if ([_str_mobile isEmptyStr]) {
    str_errorMessage = multiLanguage(@"To register, please enter your chinese mobile phone number in the space provided.");
  } else if (![_str_mobile isMobileNum]) {
    str_errorMessage = multiLanguage(@"To register, please enter your chinese mobile phone number in the space provided.");
  }
  else
  {
    return NO;
  }
  [commond alert:multiLanguage(@"ALERT") message:str_errorMessage callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {}];
  return YES;
}

- (BOOL)isErrorVerCode:(NSString *)verCode{
  
  NSString *str_errorMessage  = @"";
  
  if ([verCode length] != 6) {
    str_errorMessage = multiLanguage(@"Verification Code must be 6 digit numbers");
  }
  else
  {
    return NO;
  }
  [commond alert:multiLanguage(@"ALERT") message:str_errorMessage callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {}];
  
  return YES;
}

@end
