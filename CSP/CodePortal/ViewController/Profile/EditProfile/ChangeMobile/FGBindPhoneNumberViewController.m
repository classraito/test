//
//  FGBindPhoneNumberViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/1/16.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBindPhoneNumberViewController.h"
#import "Global.h"
@interface FGBindPhoneNumberViewController ()
{
    NSString *str_mobileNum;
}
@end

@implementation FGBindPhoneNumberViewController
@synthesize lb_key_phoneNumber;
@synthesize lb_key_smsCode;
@synthesize tf_phoneNumber;
@synthesize view_separatorLine;
@synthesize view_separatorLine1;
@synthesize tf_smsCode;
@synthesize lb_smsTimeCounter;
@synthesize cub_sendToMe;
@synthesize btn_next;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mobileNum:(NSString *)_str_mobileNum
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_mobileNum = [_str_mobileNum mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [commond useDefaultRatioToScaleView:lb_key_phoneNumber];
    [commond useDefaultRatioToScaleView:lb_key_smsCode];
    [commond useDefaultRatioToScaleView:tf_phoneNumber];
    [commond useDefaultRatioToScaleView:tf_smsCode];
    [commond useDefaultRatioToScaleView:cub_sendToMe];
    [commond useDefaultRatioToScaleView:btn_next];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separatorLine];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separatorLine1];
    
    self.view_topPanel.str_title = multiLanguage(@"EDIT PHONE NUMBER");
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_right.hidden = YES;
    [self hideBottomPanelWithAnimtaion:NO];
    
    
    lb_key_phoneNumber.text = multiLanguage(@"Phone Number");
    lb_key_smsCode.text = multiLanguage(@"SMS Code");
    
    [cub_sendToMe setupStyleWithButtonColor:color_red_panel underlineColor:color_red_panel];
    
    
    [cub_sendToMe.btn setTitle:multiLanguage(@"Send to me") forState:UIControlStateNormal];
    [cub_sendToMe.btn addTarget:self action:@selector(buttonAction_sendToMe:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [btn_next setTitle:multiLanguage(@"NEXT") forState:UIControlStateNormal];
    [btn_next setTitle:multiLanguage(@"NEXT") forState:UIControlStateHighlighted];
    
    btn_next.layer.cornerRadius = btn_next.frame.size.height / 2;
    btn_next.layer.masksToBounds = YES;
    btn_next.backgroundColor = color_red_panel;
    
    tf_phoneNumber.font = font(FONT_TEXT_REGULAR, 16);
    tf_smsCode.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_phoneNumber.font = font(FONT_TEXT_REGULAR, 16);
    lb_key_smsCode.font = font(FONT_TEXT_REGULAR, 16);
    cub_sendToMe.btn.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_next.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    [self setTFPadding:15 tf:tf_phoneNumber];
    [self setTFPadding:15 tf:tf_smsCode];
    
    tf_phoneNumber.placeholder = multiLanguage(@"Enter mobile number here");
    tf_smsCode.placeholder = multiLanguage(@"SMS Code");
    
    tf_phoneNumber.userInteractionEnabled = NO;
    tf_phoneNumber.text = str_mobileNum;
    tf_phoneNumber.textColor = [UIColor lightGrayColor];
    
    [tf_phoneNumber addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [tf_smsCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

#pragma mark - 设置textField 边距
-(void)setTFPadding:(CGFloat)_padding tf:(UITextField *)_tf
{
    UIView *tmp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _padding, 0)];
    _tf.leftView = tmp;
    tmp = nil;
    _tf.leftViewMode = UITextFieldViewModeAlways;
    
    tmp = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _padding, 0)];
    _tf.rightView = tmp;
    tmp = nil;
    _tf.rightViewMode = UITextFieldViewModeAlways;
}


-(void)buttonAction_sendToMe:(id)_sender
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_User sharedManager] postRequest_USER_SendVCodeOldMobile:_dic_info]; //发送验证码
}

-(IBAction)buttonAction_next:(id)_sender;
{
    if([self isErrorVerCode:tf_smsCode.text])
        return;
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_User sharedManager] postRequest_USER_VerifyCodeOldMobile:tf_smsCode.text userinfo:_dic_info];
}

- (void)internalInitalStartSMSCodeStartCount {
    self.lb_smsTimeCounter.hidden = NO;
    self.cub_sendToMe.hidden  = YES;
    [self.view bringSubviewToFront:self.lb_smsTimeCounter];
    
    __weak FGBindPhoneNumberViewController *weakSelf = self;
    [self.lb_smsTimeCounter startCounterWithTime:60 timeInterval:1.0f completionHandler:^{
        [weakSelf internalInitalStartSMSCodeRecover];
    }];
}

- (void)internalInitalStartSMSCodeRecover {
    self.cub_sendToMe.hidden = NO;
    [self.view bringSubviewToFront:self.lb_smsTimeCounter];
    self.lb_smsTimeCounter.hidden = YES;
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

-(void)go2NewPhoneVC
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGBindPhoneNumberNewPhoneViewController *vc_bindPhoneNumber = [[FGBindPhoneNumberNewPhoneViewController alloc] initWithNibName:@"FGBindPhoneNumberNewPhoneViewController" bundle:nil];
    [manager pushController:vc_bindPhoneNumber navigationController:nav_current];
}


-(void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"textField.text = %@",textField.text);
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    //向旧手机号发送验证码
    if ([HOST(URL_USER_SendVCodeOldMobile) isEqualToString:_str_url]) {
       
    }
    
    if([HOST(URL_USER_VerifyCodeOldMobile) isEqualToString:_str_url])
    {
        [self go2NewPhoneVC];
    }
    
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_mobileNum = nil;
}
@end
