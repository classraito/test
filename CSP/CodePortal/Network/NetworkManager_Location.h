//
//  NetworkManager_Location.h
//  CSP
//
//  Created by Ryan Gong on 16/11/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager.h"

typedef enum
{
    MyGroupListType_CommingSoon = 1,
    MyGroupListType_History = 2
}MyGroupListType;

/*提交训练要求*/
#define URL_LOCATION_TrainOrderList @"/Location/TrainOrderList.ashx"
/*提交训练要求*/
#define URL_LOCATION_OrderTrain @"/Location/OrderTrain.ashx"

/*提交多个课程训练的要求*/
#define URL_LOCATION_OrderTrainMultiClass @"/Location/OrderTrainMultiClass.ashx"

/*教练接受训练定单*/
#define URL_LOCATION_Update_OrderAccept @"/Location/OrderAccept.ashx"

/*获取订单的列表*/
#define URL_LOCATION_OrderList @"/Location/OrderList.ashx"

/*订单详细*/
#define URL_LOCATION_OrderDetail @"/Location/OrderDetail.ashx"

/*提交训练要求*/
#define URL_LOCATION_OrderCancel @"/Location/OrderCancel.ashx"

/*订单锁查询*/
#define URL_LOCATION_CheckOrder @"/Location/CheckOrder.ashx"

/*对课程打分，提交评价*/
#define URL_LOCATION_SubmitFeedback @"/Account/SubmitFeedback.ashx"

/*订单申请购买课程*/
#define URL_LOCATION_CheckBuyBundle @"/Location/CheckBuyBundle.ashx"

/*获取课程的信息*/
#define URL_LOCATION_GetBundleInfo @"/Location/GetBundleInfo.ashx"

/*检查购买课程*/
#define URL_LOCATION_BundleList @"/Location/BundleList.ashx"

/*订单申请支付*/
#define URL_LOCATION_CheckBuyLesson @"/Location/CheckBuyLesson.ashx"

/*兑换邀请码优惠券*/
#define URL_LOCATION_InvitationExchange @"/Location/InvitationExchange.ashx"

/*获取优惠券列表*/
#define URL_LOCATION_CouponList @"/Location/CouponList.ashx"

/*设置日历列表*/
#define URL_LOCATION_SetCalendar @"/Account/SetCalendar.ashx"

/*获取日历列表*/
#define URL_LOCATION_CalendarList @"/Account/CalendarList.ashx"

/*获取健身房列表*/
#define URL_LOCATION_GymList @"/Location/GymList.ashx"

/*活动签到*/
#define URL_LOCATION_CheckInGroup @"/Location/CheckInGroup.ashx"//TODO

/*获取我的活动列表*/
#define URL_LOCATION_MyGroupList @"/Location/MyGroupList.ashx"

/*获取活动详细内容 包含了
 活动列表此条数据(先前已得到)
 GroupParticipant
 GroupOrganizer
 二个接口
 其中GroupParticipant需要在页面上多次调用*/
#define URL_LOCATION_GroupDetailPage @"/Location/GroupDetailPage.ashx"//TODO

/*活动组织者*/
#define URL_LOCATION_GroupOrganizer @"/Location/GroupOrganizer.ashx"

/*参加活动*/
#define URL_LOCATION_JoinGroup @"/Location/JoinGroup.ashx"

/*获取活动列表*/
#define URL_LOCATION_GroupList @"/Location/GroupList.ashx"

/*获取参与活动的人员列表*/
#define URL_LOCATION_GroupParticipant @"/Location/GroupParticipant.ashx"

/*离开活动*/
#define URL_LOCATION_LeaveGroup @"/Location/LeaveGroup.ashx"
@interface NetworkManager_Location : NetworkManager
{
    
}
#pragma mark - 获取教练订单列表
- (void)postRequest_Locations_trainOrderListWithTrainerId:(NSString *)_trainerId orderFilter:(int)_filter isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 提交训练要求
-(void)postRequest_Locations_orderTrain:(NSString *)_str_trainerId bookTime:(long)_bookTime Lat:(long)_lat Lng:(long)_lng address:(NSString *)_str_address addressDetail:(NSString *)_str_addressDetail otherMsg:(NSString *)_otherMsg userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 提交预订多个课程的订单
-(void)postRequest_Location_OrderTrainMultiClass:(NSString *)_str_trainerId startDate:(long)_startDate repeatTimes:(int)_repeatTimes bookTime:(NSMutableArray *)_arr_bookTimes Lat:(long)_lat Lng:(long)_lng address:(NSString *)_str_address addressDetail:(NSString *)_str_addressDetail otherMsg:(NSString *)_otherMsg userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 教练接受训练定单
-(void)postRequest_Locations_update_OrderAccept:(NSString *)_str_orderId absoulte:(BOOL)_bool_isAbsoulte userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取订单的列表
-(void)postRequest_Locations_orderList:(int)_filter isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 订单详细
-(void)postRequest_Locations_orderDetailWithOrderId:(NSString *)_str_orderId userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 取消课程定单
-(void)postRequest_Locations_orderCancel:(NSString *)_str_orderId userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 订单锁查询
-(void)postRequest_Locations_checkOrder:(NSMutableDictionary *)_userinfo;

#pragma mark - 对课程打分，提交评价
-(void)postRequest_Locations_submitFeedback:(NSString *)_str_orderId trainerId:(NSString *)_str_trainerId rating:(NSInteger)_rating review:(NSString *)_str_review  userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 订单申请购买课程
-(void)postRequest_Locations_checkBuyBundle:(NSString *)_str_bundleSessonId gateWay:(int)_gateWay userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取课程的信息
-(void)postRequest_Locations_GetBundleInfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 检查购买课程
-(void)postRequest_Locations_bundleList:(NSMutableDictionary *)_userinfo;

#pragma mark - 订单申请支付 
-(void)postRequest_Locations_checkByLesson:(NSString *)_str_orderID coupons:(NSMutableArray *)_arr_coupons inviteCoupon:(NSString *)_str_inviteCoupon bundle:(NSMutableArray *)_arr_bundles gatewary:(int)_gateway userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 兑换邀请码优惠券
-(void)postRequest_Locations_invitationExchange:(NSString *)_str_invitationCode userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取优惠券列表
-(void)postRequest_Locations_couponList:(NSMutableDictionary *)_userinfo;

#pragma mark - 设置日历列表
-(void)postRequest_Locations_setCalendar:(NSMutableArray *)_arr_schedule userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取日历列表
-(void)postRequest_Locations_calendarList:(long)_startTime endTime:(long)_endTime trainerId:(NSString *)_trainerId userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取健身房列表
-(void)postRequest_Locations_getGymList:(BOOL)_isFirstPage count:(int)_count lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 活动签到 //TODO
-(void)postRequest_Locations_checkInGroup:(NSString *)_str_groupId lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取我的活动列表
-(void)postRequest_Locations_myGroupList:(MyGroupListType)_filter isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取活动详细内容 包含了活动列表此条数据(先前已得到) GroupParticipant GroupOrganizer 二个接口 其中GroupParticipant需要在页面上多次调用 //TODO
-(void)postRequest_Locations_groupDetailPage:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 活动组织者
-(void)postRequest_Locations_groupOrganizer:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 参加活动
-(void)postRequest_Locations_joinGroup:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取活动列表
-(void)postRequest_Locations_groupList:(BOOL)_isFirstPage count:(int)_count lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 获取参与活动的人员列表
-(void)postRequest_Locations_groupParticipant:(NSString *)_str_groupId isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo;

#pragma mark - 离开活动
-(void)postRequest_Locations_leaveGroup:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;
@end
