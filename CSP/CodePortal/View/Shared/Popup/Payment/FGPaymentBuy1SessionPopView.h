//
//  FGPaymentBuy1SessionPopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGPaymentBuy1SessionPopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_price;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIImageView *iv_wechat;
@property(nonatomic,weak)IBOutlet UIImageView *iv_alipay;
@property(nonatomic,weak)IBOutlet UIImageView *iv_checkBox_coupon;
@property(nonatomic,weak)IBOutlet UIImageView *iv_checkBox_invitationCode;
@property(nonatomic,weak)IBOutlet UILabel *lb_coupon;
@property(nonatomic,weak)IBOutlet UILabel *lb_invitationCode;
@property(nonatomic,weak)IBOutlet UIButton *btn_confirmToPay;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancelRequest;
@property(nonatomic,weak)IBOutlet UIButton *btn_wechat;
@property(nonatomic,weak)IBOutlet UIButton *btn_aliPay;
@property(nonatomic,weak)IBOutlet UIButton *btn_coupon;
@property(nonatomic,weak)IBOutlet UIButton *btn_invitationCode;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBg;
@property(nonatomic,weak)IBOutlet UIView *view_separator_h;
-(IBAction)buttonAction_clickWeCaht:(id)_sender;
-(IBAction)buttonAction_clickAliPay:(id)_sender;
-(IBAction)buttonAction_useCoupon:(id)_sender;
-(IBAction)buttonAction_useInvitationCode:(id)_sender;
-(void)bindDataToUI;
@end
