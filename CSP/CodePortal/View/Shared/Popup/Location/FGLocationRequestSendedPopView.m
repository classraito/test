//
//  FGLocationRequestSendedPopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationRequestSendedPopView.h"
#import "Global.h"
#define CHECK_FREQUENCY 5   //每5秒检查一次状态
@interface FGLocationRequestSendedPopView()
{
    NSTimer *timer;
    long totalDutaion;
}
@end

@implementation FGLocationRequestSendedPopView
@synthesize orderStatus;
@synthesize view_whiteBg;
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize btn_cancelRequest;
@synthesize discount;
@synthesize view_uploading;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.view_bg.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:view_whiteBg];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:btn_cancelRequest];
    
    lb_title.text = multiLanguage(@"Request sent.");
    lb_subtitle.text = multiLanguage(@"Hold tight. We’re waiting for a nearby trainer to accept your session.");
    [btn_cancelRequest setTitle:multiLanguage(@"Cancel request") forState:UIControlStateNormal];
    [btn_cancelRequest setTitle:multiLanguage(@"Cancel request") forState:UIControlStateHighlighted];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 18);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 16);
    btn_cancelRequest.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)internalInitalCircularProgressView
{
    if(view_uploading)
        return;
    view_uploading = (FGCircularUploadProgressView *)[[[NSBundle mainBundle] loadNibNamed:@"FGCircularUploadProgressView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_uploading];
    view_uploading.center = CGPointMake(W/2, H/2);
    view_uploading.lb_title.font = font(FONT_NUM_MEDIUM, 25);
    view_uploading.lb_title.textColor = color_red_panel;
    view_uploading.iv_uploading.hidden = YES;
    [view_uploading setStatusToUpLoading];
    [self addSubview:view_uploading];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
}

-(void)updateTimer:(id)_sender
{
    discount = discount > 0 ? discount - 1 : 0;
    view_uploading.lb_title.text = [commond clockFormatBySeconds:discount];
    view_uploading.processPercent = (float)discount / (float)totalDutaion;
    NSLog(@"%ld / %ld",discount,totalDutaion);
    [view_uploading setNeedsDisplay];
    
    if(discount % CHECK_FREQUENCY == 0)
        [self postRequest_location_requestSended_checkOrder];//每5秒检查一次状态
    
    if(discount == 0)
    {
        [self cancelTimer];
        FGPopupViewController *vc = (FGPopupViewController *)[self viewController];
        [vc go2NoRequestAccepting];
    }
}

-(void)cancelTimer
{
    if(!timer)
        return;
    SAFE_INVALIDATE_TIMER(timer);
    timer = nil;
}

-(void)setupProgressOnce
{
    if(view_uploading)
        return;
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CheckOrder)];
    totalDutaion = [[_dic_result objectForKey:@"TimeDuration"] floatValue];
    discount = [[_dic_result objectForKey:@"TimeLeft"] floatValue];
    
    [self internalInitalCircularProgressView];
}

-(void)updateAcceptStatus
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CheckOrder)];
    NSLog(@"_dic_result = %@",_dic_result);
    orderStatus = [[_dic_result objectForKey:@"Status"] intValue];
    FGPaymentModel *paymentModel = [FGPaymentModel sharedModel];
    paymentModel.str_currentRequestedOrderId = [NSString stringWithFormat:@"%@",[_dic_result objectForKey:@"OrderId"]];
    paymentModel.str_trainerId = [NSString stringWithFormat:@"%@",[_dic_result objectForKey:@"TrainerId"]];
    paymentModel.oneSessionPrice = [[_dic_result objectForKey:@"Price"] floatValue];
    paymentModel.sessionCount = [[_dic_result objectForKey:@"SessionCount"] intValue];
    NSLog(@"paymentModel.sessionCount = %d",paymentModel.sessionCount);
    paymentModel.currentRequestedOrderStatus = orderStatus;
    NSLog(@"orderStatus = %d",orderStatus);
    //0:订单已取消
    //1:订单已发送
    //2:订单已接受
    //3:订单已付款
    //4:订单已完成
    //5:订单已评论
    if(orderStatus == OrderStatus_Accepted)
    {
        FGPopupViewController *vc = (FGPopupViewController *)[self viewController];
        [vc postRequest_getBundleList];
        
        [NetworkEventTrack track:KEY_MIXPANEL_EVENTID_BOOKATRAINER attrs:nil]; //mixpanel统计用户成功预订了一个教练
    }
}

-(void)postRequest_location_requestSended_checkOrder
{
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_checkOrder:nil];
}


@end
