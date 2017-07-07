//
//  FGLoginView.h
//  CSP
//
//  Created by JasonLu on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGAlignmentLabel.h"
#import "FGCustomUnderlineButton.h"
#import "FGTimeCounterLabel.h"
#import "FGUserInputPageBaseView.h"
#import <UIKit/UIKit.h>
@interface FGLoginView : FGUserInputPageBaseView
#pragma mark - IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *btn_login_qq;
@property (weak, nonatomic) IBOutlet UIButton *btn_login_sina;
@property (weak, nonatomic) IBOutlet UIButton *btn_login_wechat;
@property (weak, nonatomic) IBOutlet UIButton *btn_login_fb;
@property (weak, nonatomic) IBOutlet UIButton *btn_getStarted;
@property (weak, nonatomic) IBOutlet UIImageView *iv_bg;
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;

@property (weak, nonatomic) IBOutlet UILabel *lb_or;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIView *view_mobile;
@property (weak, nonatomic) IBOutlet UIView *view_smscode;
@property (weak, nonatomic) IBOutlet FGCustomUnderlineButton *view_sendsmsCode;
@property (weak, nonatomic) IBOutlet FGCustomUnderlineButton *view_needhelp;
@property (weak, nonatomic) IBOutlet FGTimeCounterLabel *lb_smsTimeCounter;
- (void)refreshData;
@end
