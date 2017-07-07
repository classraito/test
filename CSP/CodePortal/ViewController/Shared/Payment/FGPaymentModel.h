//
//  FGPaymentModel.h
//  CSP
//
//  Created by Ryan Gong on 16/12/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    PaymentGateWay_JustUseTicket = 0,//仅使用优惠券 或 打包券 或邀请码优惠券
    PaymentGateWay_AliPay = 1,      //使用支付宝支付
    PaymentGateWay_Wechat = 2     //使用微信支付
    
}PaymentGateWay;

typedef enum{
    PaymentCheckType_Buy1Session = 1,//检查购买一个课程卡的回调
    PaymentCheckType_BuyBundle = 2//检查购买打包课程卡的回调
}PaymentCheckType;

typedef enum{
    PaymentCouponType_NOTUSE = 0,
    PaymentCouponType_Normal = 1,       //普通优惠券类型
    PaymentCouponType_InviteCoupon = 2  //兑换码优惠券类型
}PaymentCouponType;

@interface FGPaymentModel : NSObject
{
    
}
/*用户发送请求*/
@property(nonatomic,strong)NSString *str_currentRequestedOrderId;//用户发送请求订单ID
@property OrderStatus currentRequestedOrderStatus;//当前订单状态
@property(nonatomic,strong)NSString *str_trainerId;//接单教练的ID
@property(nonatomic,strong)NSString *str_trainerName;//接单教练的名称
@property(nonatomic,strong)NSString *str_trainerThumbnailUrl;//接单教练的头像URL
@property float trainerRating;//接单教练的评分值
@property int sessionCount;//课程数量
@property long lat;
@property long lng;//预定经纬度
@property(nonatomic,strong)NSString *str_address;//预定地址
@property(nonatomic,strong)NSString *str_addressDetail;//预定详细地址
@property(nonatomic,strong)NSString *str_otherMessage;//预定其他信息
@property(nonatomic,strong)NSMutableDictionary *dic_acceptedTrainerInfo;//接受订单的教练的信息
@property CGFloat oneSessionPrice;//购买单个课程的价格
@property(nonatomic,strong)NSMutableDictionary *dic_coupon_inviteCodeInfo;//普通优惠券和邀请码优惠券信息
@property CGFloat allCouponPrice;//所有优惠券 总优惠价
@property int inviteCodeCouponPrice;//邀请码优惠券 价格
@property int paymentGateWay;//支付方式  0: 仅使用券 1: 使用支付宝 2: 使用微信支付
@property int paymentCheckType;//支付宝得到同步回调后做哪个异步回调检查
@property PaymentCouponType paymentCouponType;

@property BOOL isMultiClass; //标记是否预订多个课程
/*预订多个课程时要用到的*/
@property (nonatomic,strong)NSMutableArray *arr_multiClass_bookClocks;  //预订时间(指多个订单的预订时间) 是个数组 数组中是表示 时钟的字符串
@property int multiClass_numberOfTimes;   //循环多少次
@property long multiClass_startDate;     //预订多个订单时的开始日期 以秒数表示


/*预订单个课程时要用到的*/
@property long bookTime;//预定时间(指单个订单的预订时间)


/*Bundle*/
@property(nonatomic,strong)NSMutableArray *arr_bundleLessons;//打包购买信息
@property(nonatomic,strong)NSMutableArray *arr_bundles;//打包券信息
+(FGPaymentModel *)sharedModel;
+(void)clearModel;
-(void)resetPayment_requestOrder;
@end
