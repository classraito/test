//
//  FGBindPhoneNumberNewPhoneViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/1/16.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBindPhoneNumberNewPhoneViewController.h"
#import "Global.h"
@interface FGBindPhoneNumberNewPhoneViewController ()
{
    
}
@end

@implementation FGBindPhoneNumberNewPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tf_phoneNumber.userInteractionEnabled = YES;
    self.tf_phoneNumber.textColor = [UIColor blackColor];
    self.lb_key_phoneNumber.text = multiLanguage(@"New Phone");
    [self.btn_next setTitle:multiLanguage(@"DONE") forState:UIControlStateNormal];
    [self.btn_next setTitle:multiLanguage(@"DONE") forState:UIControlStateHighlighted];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)buttonAction_sendToMe:(id)_sender
{
    if(![self isErrorPhoneNumber:self.tf_phoneNumber.text])
    {
        NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
        [[NetworkManager_User sharedManager] postRequest_USER_SendVCodeBindingMobile:self.tf_phoneNumber.text userinfo:_dic_info]; //发送验证码
    }
}

-(IBAction)buttonAction_next:(id)_sender;
{
    if([self isErrorVerCode:self.tf_smsCode.text])
        return;
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_User sharedManager] postRequest_USER_VerifyCodeBindingMobile:self.tf_smsCode.text mobile:self.tf_phoneNumber.text userinfo:_dic_info];
    
    
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

        for(UIViewController *_vc in  nav_current.viewControllers)
        {
            if([_vc isKindOfClass:[FGProfileEditViewController class]])
            {
                FGProfileEditViewController *vc_edit = (FGProfileEditViewController *)_vc;
                [nav_current popToViewController:vc_edit animated:YES];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UpdateUserMobile object:self.tf_phoneNumber.text];
    }
    
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

@end
