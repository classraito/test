//
//  FGBindPhoneNumberViewController.h
//  CSP
//
//  Created by Ryan Gong on 17/1/16.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGCustomUnderlineButton.h"
#import "FGTimeCounterLabel.h"
@interface FGBindPhoneNumberViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_key_phoneNumber;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_smsCode;
@property(nonatomic,weak)IBOutlet UITextField *tf_phoneNumber;
@property(nonatomic,weak)IBOutlet UIView *view_separatorLine;
@property(nonatomic,weak)IBOutlet UIView *view_separatorLine1;
@property(nonatomic,weak)IBOutlet UITextField *tf_smsCode;
@property(nonatomic,weak)IBOutlet FGTimeCounterLabel *lb_smsTimeCounter;
@property(nonatomic,weak)IBOutlet FGCustomUnderlineButton *cub_sendToMe;
@property(nonatomic,weak)IBOutlet UIButton *btn_next;
-(IBAction)buttonAction_next:(id)_sender;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mobileNum:(NSString *)_str_mobileNum;
- (BOOL)isErrorPhoneNumber:(NSString *)_str_mobile;
- (BOOL)isErrorVerCode:(NSString *)verCode;

- (void)internalInitalStartSMSCodeRecover;
- (void)internalInitalStartSMSCodeStartCount;
@end
