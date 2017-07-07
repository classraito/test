//
//  FGPaymentBuy1SessionPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPaymentBuy1SessionPopView.h"
#import "Global.h"
@implementation FGPaymentBuy1SessionPopView
@synthesize lb_title;
@synthesize lb_price;
@synthesize lb_subtitle;
@synthesize iv_wechat;
@synthesize iv_alipay;
@synthesize iv_checkBox_coupon;
@synthesize iv_checkBox_invitationCode;
@synthesize lb_coupon;
@synthesize lb_invitationCode;
@synthesize btn_confirmToPay;
@synthesize btn_cancelRequest;
@synthesize btn_wechat;
@synthesize btn_aliPay;
@synthesize btn_coupon;
@synthesize btn_invitationCode;
@synthesize view_whiteBg;
@synthesize view_separator_h;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.view_bg.backgroundColor = [UIColor clearColor];
    
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator_h];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView: lb_price];
    [commond useDefaultRatioToScaleView: lb_subtitle];
    [commond useDefaultRatioToScaleView: iv_wechat];
    [commond useDefaultRatioToScaleView: iv_alipay];
    [commond useDefaultRatioToScaleView: iv_checkBox_coupon];
    [commond useDefaultRatioToScaleView: iv_checkBox_invitationCode];
    [commond useDefaultRatioToScaleView: lb_coupon];
    [commond useDefaultRatioToScaleView: lb_invitationCode];
    [commond useDefaultRatioToScaleView: btn_confirmToPay];
    [commond useDefaultRatioToScaleView: btn_cancelRequest];
    [commond useDefaultRatioToScaleView: btn_wechat];
    [commond useDefaultRatioToScaleView: btn_aliPay];
    [commond useDefaultRatioToScaleView: btn_coupon];
    [commond useDefaultRatioToScaleView: btn_invitationCode];
    [commond useDefaultRatioToScaleView: view_whiteBg];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_price.font = font(FONT_NUM_MEDIUM, 32);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 18);
    lb_coupon.font = font(FONT_TEXT_REGULAR, 18);
    lb_invitationCode.font = font(FONT_TEXT_REGULAR, 18);
    btn_confirmToPay.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_cancelRequest.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    iv_wechat.image = [UIImage imageNamed:@"paywechat_default.png"];
    iv_wechat.highlightedImage = [UIImage imageNamed:@"paywechat.png"];
    
    iv_alipay.image = [UIImage imageNamed:@"payalipay_default.png"];
    iv_alipay.highlightedImage = [UIImage imageNamed:@"payalipay.png"];
    
    iv_checkBox_coupon.image = [UIImage imageNamed:@"checkbox.png"];
    iv_checkBox_coupon.highlightedImage = [UIImage imageNamed:@"checkbox_choose.png"];
    
    iv_checkBox_invitationCode.image = [UIImage imageNamed:@"checkbox.png"];
    iv_checkBox_invitationCode.highlightedImage = [UIImage imageNamed:@"checkbox_choose.png"];
    
    lb_title.text = multiLanguage(@"Payment");
    
    lb_invitationCode.text = multiLanguage(@"use invitation code");
    NSString *_str_confirmToPay = multiLanguage(@"CONFIRM TO PAY");
    NSString *_str_cancelRequest = multiLanguage(@"CANCEL REQUEST");
    [btn_confirmToPay setTitle:_str_confirmToPay forState:UIControlStateNormal];
    [btn_confirmToPay setTitle:_str_confirmToPay forState:UIControlStateHighlighted];
    
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateNormal];
    [btn_cancelRequest setTitle:_str_cancelRequest forState:UIControlStateHighlighted];
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 优惠券状态
/*选中普通优惠券*/
-(void)highlightCoupon
{
    iv_checkBox_coupon.highlighted = YES;
    lb_coupon.textColor = [UIColor blackColor];
    
}

/*不选中普通优惠券*/
-(void)disHighlightCoupon
{
    iv_checkBox_coupon.highlighted = NO;
    lb_coupon.textColor = [UIColor lightGrayColor];
}

/*选中兑换码优惠券*/
-(void)highlightInviteCode
{
    iv_checkBox_invitationCode.highlighted = YES;
    lb_invitationCode.textColor = [UIColor blackColor];
}

/*不选中兑换码优惠券*/
-(void)disHighlightInviteCode
{
    iv_checkBox_invitationCode.highlighted = NO;
    lb_invitationCode.textColor = [UIColor lightGrayColor];
}

/*显示普通优惠券*/
-(void)enableCoupon
{
    
    lb_coupon.hidden = NO;
    btn_coupon.hidden = NO;
    btn_coupon.hidden = NO;
}

/*不显示普通优惠券*/
-(void)disableCoupon
{
    iv_checkBox_coupon.hidden = YES;
    lb_coupon.hidden = YES;
    btn_coupon.hidden = YES;
}

/*显示兑换码优惠券*/
-(void)enableInviteCode
{
    iv_checkBox_invitationCode.hidden = NO;
    lb_invitationCode.hidden = NO;
    btn_invitationCode.hidden = NO;
}

/*不显示兑换码优惠券*/
-(void)disableInviteCode
{
    iv_checkBox_invitationCode.hidden = YES;
    lb_invitationCode.hidden = YES;
    btn_invitationCode.hidden = YES;
}

/*关闭现金方式交互*/
-(void)disableCashPayIfNeeded
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    float finalPrice = paymentModel.oneSessionPrice - paymentModel.allCouponPrice;
    finalPrice = finalPrice <=0 ? 0 : finalPrice;
    if( finalPrice <=0 )
    {
        iv_alipay.highlighted = NO;
        iv_wechat.highlighted = NO;
        btn_aliPay.hidden = YES;
        btn_wechat.hidden = YES;
    }
}

/*打开现金方式按钮*/
-(void)enableCashPay
{
    btn_aliPay.hidden = NO;
    btn_wechat.hidden = NO;
}

/*打开支付按钮*/
-(void)hightlightConfirmToPay
{
    btn_confirmToPay.backgroundColor = rgb(61, 151, 146);
    btn_confirmToPay.userInteractionEnabled = YES;
    [self updatePaymentGateway];
}

/*关闭支付按钮*/
-(void)disHighlightConfirmToPay
{
    btn_confirmToPay.backgroundColor = [UIColor lightGrayColor];
    btn_confirmToPay.userInteractionEnabled = NO;
}

/*更新支付按钮状态*/
-(void)updateConfirmToPayStatus
{
    float finalPrice = [[lb_price.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] floatValue];
    finalPrice = finalPrice <=0 ? 0 : finalPrice;
    if(finalPrice <= 0)
    {
        [self hightlightConfirmToPay];
        
    }
    else
    {
        if(!iv_wechat.highlighted && !iv_alipay.highlighted)
            [self disHighlightConfirmToPay];
    }
}

/*更新支付模型中的支付方式*/
-(void)updatePaymentGateway
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    if(iv_wechat.highlighted)
        paymentModel.paymentGateWay = PaymentGateWay_Wechat;
    else if(iv_alipay.highlighted)
        paymentModel.paymentGateWay = PaymentGateWay_AliPay;
    else
        paymentModel.paymentGateWay = PaymentGateWay_JustUseTicket;
}

#pragma mark - buttonAction
/*点击微信按钮*/
-(IBAction)buttonAction_clickWeCaht:(id)_sender;
{
    iv_wechat.highlighted = YES;
    iv_alipay.highlighted = NO;
    [self hightlightConfirmToPay];
    
}

/*点击支付宝按钮*/
-(IBAction)buttonAction_clickAliPay:(id)_sender;
{
    iv_wechat.highlighted = NO;
    iv_alipay.highlighted = YES;
    [self hightlightConfirmToPay];
}

/*勾选普通优惠券*/
-(IBAction)buttonAction_useCoupon:(id)_sender;
{
    if(btn_coupon.hidden)
        return;
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    if(iv_checkBox_coupon.highlighted)
    {
        [self disHighlightCoupon];
        [self enableCashPay];
        lb_price.text = [NSString stringWithFormat:@"￥%.2f",paymentModel.oneSessionPrice];
        paymentModel.paymentCouponType = PaymentCouponType_NOTUSE;
    }//取消选中普通优惠券
    else
    {
        
        paymentModel.paymentCouponType = PaymentCouponType_Normal;
        [self highlightCoupon];             //高亮普通优惠券按钮，如果普通优惠券和兑换码优惠券同时可选 默认选中普通优惠券
        [self disHighlightInviteCode];      //屏蔽邀请码优惠券
        [self disableCashPayIfNeeded];      //是否屏蔽现金支付
        float finalPrice = paymentModel.oneSessionPrice - paymentModel.allCouponPrice;
        finalPrice = finalPrice <=0 ? 0 : finalPrice;
       
        lb_price.text = [NSString stringWithFormat:@"￥%.2f",finalPrice];
    }//选中普通优惠券，并重新计算价格
    [self updateConfirmToPayStatus];//更新支付按钮状态
}

/*勾选邀请码优惠券*/
-(IBAction)buttonAction_useInvitationCode:(id)_sender;
{
     /*if(iv_checkBox_invitationCode.hidden)
     {
         FGPopupViewController *vc = (FGPopupViewController *)[self viewController];
         [vc go2InputInviteCode];
         return;
     }//go to input invitation code*/
    
    /*select check box*/
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    if(iv_checkBox_invitationCode.highlighted)
    {
        [self disHighlightInviteCode];
        [self enableCashPay];
        lb_price.text = [NSString stringWithFormat:@"￥%.2f",paymentModel.oneSessionPrice];
        paymentModel.paymentCouponType = PaymentCouponType_NOTUSE;
    }//取消选中兑换码优惠券
    else
    {
        paymentModel.paymentCouponType = PaymentCouponType_InviteCoupon;
        [self highlightInviteCode];
        [self disHighlightCoupon];
         [self disableCashPayIfNeeded];
        float finalPrice = paymentModel.oneSessionPrice - paymentModel.inviteCodeCouponPrice;
        finalPrice = finalPrice <=0 ? 0 : finalPrice;
        lb_price.text = [NSString stringWithFormat:@"￥%.2f",finalPrice];
    }//选中兑换码优惠券,并重新计算价格
    
    [self updateConfirmToPayStatus];//更新支付按钮状态
}

/*获取网络数据后的逻辑*/
-(void)bindDataToUI
{
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];

    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CouponList)];
    NSLog(@"_dic_result = %@",_dic_result);
    

    paymentModel.dic_coupon_inviteCodeInfo = nil;
    paymentModel.dic_coupon_inviteCodeInfo = [_dic_result mutableCopy];//获得普通优惠券和邀请码优惠券
    //paymentModel.oneSessionPrice = 3000;//TODO: fix-it
    
    //NSString *_str_trainerName =  [paymentModel.dic_acceptedTrainerInfo objectForKey:@"UserName"];
    lb_subtitle.text = multiLanguage(@"If you have a coupon or a friends discount user code please tick the box below.");
    lb_price.text = [NSString stringWithFormat:@"￥%.2f",paymentModel.oneSessionPrice];//显示单次课程价格
    
    NSMutableArray *arr_coupons = [paymentModel.dic_coupon_inviteCodeInfo objectForKey:@"Coupons"];//普通优惠券信息
     NSMutableDictionary *dic_inviteCoupons = [paymentModel.dic_coupon_inviteCodeInfo objectForKey:@"InviteCoupon"];//邀请码优惠券信息
    
    //==============================以下代码处理普通优惠券逻辑======================
    BOOL isInviteCodeUsed = [[paymentModel.dic_coupon_inviteCodeInfo objectForKey:@"IsInviteCodeUsed"] boolValue];//是否已兑换别人分享的邀请码
    NSInteger couponCount = [arr_coupons count];//普通优惠券个数
    NSInteger inviteCouponCount = [[dic_inviteCoupons allKeys] count];//邀请码优惠券个数
   
    if(couponCount == 0)//没有普通邀请码
        [self disableCoupon];
    else
    {
        [self enableCoupon];
        float allCouponPrice = 0;
        for(NSMutableDictionary *_dic_singleInfo in arr_coupons)
        {
            allCouponPrice += [[_dic_singleInfo objectForKey:@"CouponValue"] floatValue];
        }
        paymentModel.allCouponPrice = allCouponPrice;//所有普通优惠券抵扣价格的总和
        
        lb_coupon.text = [NSString stringWithFormat:@"%@ (-￥%.2f)",multiLanguage(@"use coupon"),paymentModel.allCouponPrice];//在界面上显示可抵扣的价格
        
       
        [self buttonAction_useCoupon:nil];//默认选中普通优惠券
        
        float finalPrice = paymentModel.oneSessionPrice - paymentModel.allCouponPrice;
        finalPrice = finalPrice <=0 ? 0 : finalPrice;
        if(finalPrice>0)
        {
            [self buttonAction_clickWeCaht:nil];//如果价格不够抵扣，那么默认选择微信支付
        }
    
    }//有普通邀请码
   
    //==============================以下代码处理兑换邀请码逻辑======================
    if(isInviteCodeUsed)//已经兑换过别人分享的邀请码
    {
        if(inviteCouponCount == 0)      //兑换过了并使用过
            [self disableInviteCode];
        else
        {
            [self enableInviteCode];
            int inviteCouponPrice = [[dic_inviteCoupons objectForKey:@"CouponValue"] intValue];
            paymentModel.inviteCodeCouponPrice = inviteCouponPrice;
        }//兑换了还没使用过

    }
    else
    {
        [self disableInviteCode];
    }//没有兑换过别人分享的邀请码
}
@end
