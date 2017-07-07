//
//  FGPaymentBuyBundlePopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPaymentBuyBundlePopView.h"
#import "Global.h"
@implementation FGPaymentBuyBundlePopView
@synthesize view_whiteBG;
@synthesize lb_title;
@synthesize lb_price;
@synthesize lb_subTitle;
@synthesize iv_wechat;
@synthesize iv_aliPay;
@synthesize btn_confirmToPay;
@synthesize btn_cancelRequest;
@synthesize btn_wechat;
@synthesize btn_aliPay;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:view_whiteBG];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_price];
    [commond useDefaultRatioToScaleView:lb_subTitle];
    [commond useDefaultRatioToScaleView:iv_wechat];
    [commond useDefaultRatioToScaleView:iv_aliPay];
    [commond useDefaultRatioToScaleView:btn_confirmToPay];
    [commond useDefaultRatioToScaleView:btn_cancelRequest];
    [commond useDefaultRatioToScaleView:btn_wechat];
    [commond useDefaultRatioToScaleView:btn_aliPay];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subTitle.font = font(FONT_TEXT_REGULAR, 16);
    lb_price.font = font(FONT_NUM_MEDIUM, 35);
    
    iv_wechat.image = [UIImage imageNamed:@"paywechat_default.png"];
    iv_wechat.highlightedImage = [UIImage imageNamed:@"paywechat.png"];
    
    iv_aliPay.image = [UIImage imageNamed:@"payalipay_default.png"];
    iv_aliPay.highlightedImage = [UIImage imageNamed:@"payalipay.png"];
    
    btn_confirmToPay.titleLabel.font = font(FONT_TEXT_REGULAR, 20);
    btn_cancelRequest.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    NSString *_str_confirmToPay = multiLanguage(@"CONFIRM TO PAY");
    NSString *_str_cancelRequest = multiLanguage(@"CANCEL REQUEST");
    
    [btn_confirmToPay setTitle:_str_confirmToPay forState:UIControlStateNormal];
    [btn_confirmToPay setTitle:_str_confirmToPay forState:UIControlStateHighlighted];
    btn_confirmToPay.userInteractionEnabled = NO;
    
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateNormal];
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateHighlighted];
    
    lb_title.text = multiLanguage(@"Transfer Confirmation");
    lb_subTitle.text = multiLanguage(@"Make life easy with Alipay!");
    
    [self bindDataToUI];
    
    [self buttonAction_clickAliPay:nil];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - buttonAction
-(IBAction)buttonAction_clickWeCaht:(id)_sender;
{
    iv_wechat.highlighted = YES;
    iv_aliPay.highlighted = NO;
    btn_confirmToPay.backgroundColor = rgb(61, 151, 146);
    btn_confirmToPay.userInteractionEnabled = YES;
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    paymentModel.paymentGateWay = PaymentGateWay_Wechat;
}

-(IBAction)buttonAction_clickAliPay:(id)_sender;
{
    iv_wechat.highlighted = NO;
    iv_aliPay.highlighted = YES;
    btn_confirmToPay.backgroundColor = rgb(61, 151, 146);
    btn_confirmToPay.userInteractionEnabled = YES;
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    paymentModel.paymentGateWay = PaymentGateWay_AliPay;
}

-(void)bindDataToUI
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    if(paymentModel.arr_bundleLessons && [paymentModel.arr_bundleLessons count ]> 0)
    {
        NSString *_str_bundlePrice = [[paymentModel.arr_bundleLessons objectAtIndex:0] objectForKey:@"BundlePrice"];
        lb_price.text = [NSString stringWithFormat:@"￥%@",_str_bundlePrice];
    }
    
    lb_subTitle.text = multiLanguage(@"Make life easy with WeChat or Alipay!");
}
@end
