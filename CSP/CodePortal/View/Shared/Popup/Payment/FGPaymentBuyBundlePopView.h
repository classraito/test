//
//  FGPaymentBuyBundlePopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGPaymentBuyBundlePopView : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_price;
@property(nonatomic,weak)IBOutlet UILabel *lb_subTitle;
@property(nonatomic,weak)IBOutlet UIImageView *iv_wechat;
@property(nonatomic,weak)IBOutlet UIImageView *iv_aliPay;
@property(nonatomic,weak)IBOutlet UIButton *btn_confirmToPay;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancelRequest;
@property(nonatomic,weak)IBOutlet UIButton *btn_wechat;
@property(nonatomic,weak)IBOutlet UIButton *btn_aliPay;
-(IBAction)buttonAction_clickWeCaht:(id)_sender;
-(IBAction)buttonAction_clickAliPay:(id)_sender;
@end
