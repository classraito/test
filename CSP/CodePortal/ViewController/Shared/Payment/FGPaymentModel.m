//
//  FGPaymentModel.m
//  CSP
//
//  Created by Ryan Gong on 16/12/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPaymentModel.h"
#import "Global.h"
static FGPaymentModel *paymentModel;
@implementation FGPaymentModel
@synthesize arr_bundleLessons;
@synthesize arr_bundles;
@synthesize str_currentRequestedOrderId;
@synthesize currentRequestedOrderStatus;
@synthesize str_trainerId;

@synthesize lat;
@synthesize lng;
@synthesize str_address;
@synthesize str_addressDetail;
@synthesize str_otherMessage;
@synthesize oneSessionPrice;
@synthesize dic_acceptedTrainerInfo;

@synthesize dic_coupon_inviteCodeInfo;
@synthesize paymentGateWay;
@synthesize paymentCheckType;//支付宝得到同步回调后做哪个异步回调检查
@synthesize paymentCouponType;
@synthesize allCouponPrice;
@synthesize inviteCodeCouponPrice;

@synthesize sessionCount;
/*以下状态区分预订单个 或者 预订多个订单*/
@synthesize bookTime;       //预订单个订单时要用到的时间

@synthesize arr_multiClass_bookClocks;  //预订多个订单时要用到的时间 时钟数组
@synthesize multiClass_numberOfTimes;   //预订多个订单时要用到的 日期循环次数
@synthesize multiClass_startDate;   //预订多个订单时的开始日期 以秒数表示


+(FGPaymentModel *)sharedModel
{
    @synchronized(self)     {
        if(!paymentModel)
        {
            paymentModel=[[FGPaymentModel alloc]init];
            
            
            return paymentModel;
        }
    }
    return paymentModel;
}

-(id)init
{
    if(self = [super init])
    {
        
        
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(paymentModel == nil, @"企圖重复創建一個singleton模式下的FGPaymentModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self resetPayment_requestOrder];
    arr_multiClass_bookClocks = nil;
    arr_bundles = nil;
    arr_bundleLessons = nil;
    str_trainerId = nil;
    str_addressDetail = nil;
    str_address = nil;
    str_otherMessage = nil;
    str_currentRequestedOrderId = nil;
    dic_acceptedTrainerInfo = nil;
    oneSessionPrice=0;
    dic_coupon_inviteCodeInfo = nil;
    paymentGateWay = 0;
}

-(void)resetPayment_requestOrder
{
    str_currentRequestedOrderId = nil;
    currentRequestedOrderStatus = 0;
}

+(void)clearModel
{
    if(!paymentModel)
        return;
    paymentModel = nil;
}

@end
