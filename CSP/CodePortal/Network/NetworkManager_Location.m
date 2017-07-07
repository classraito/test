//
//  NetworkManager_Location.m
//  CSP
//
//  Created by Ryan Gong on 16/11/23.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "NetworkManager_Location.h"
#import "Global.h"
@implementation NetworkManager_Location
#pragma mark - 获取教练订单列表
- (void)postRequest_Locations_trainOrderListWithTrainerId:(NSString *)_trainerId orderFilter:(int)_filter isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo {
  NSString *_str_cursor = [self getCursorByURL:HOST(URL_LOCATION_TrainOrderList) isFirstPage:_isFirstPage];
  if(!_str_cursor) {
    if (_isFirstPage)
      _str_cursor = @"0";
    else
      return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
  }
  
  NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
  [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
  [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
  
  NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
  [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params setObjectSafty:_trainerId forKey:@"TrainId"];
  [dic_params setObjectSafty:[NSNumber numberWithInteger:_filter] forKey:@"Filter"];
  [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
  [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];

  [self requestUrl:HOST(URL_LOCATION_TrainOrderList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 提交训练要求
-(void)postRequest_Locations_orderTrain:(NSString *)_str_trainerId bookTime:(long)_bookTime Lat:(long)_lat Lng:(long)_lng address:(NSString *)_str_address addressDetail:(NSString *)_str_addressDetail otherMsg:(NSString *)_otherMsg userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainerId forKey:@"TrainerId"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_bookTime] forKey:@"BookTime"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lat] forKey:@"Lat"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lng] forKey:@"Lng"];
    [dic_params setObjectSafty:_str_address forKey:@"Address"];
    [dic_params setObjectSafty:_str_addressDetail forKey:@"AddressDetial"];
    [dic_params setObjectSafty:_otherMsg forKey:@"OtherMsg"];
    
    [self requestUrl:HOST(URL_LOCATION_OrderTrain) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 提交预订多个课程的订单
-(void)postRequest_Location_OrderTrainMultiClass:(NSString *)_str_trainerId startDate:(long)_startDate repeatTimes:(int)_repeatTimes bookTime:(NSMutableArray *)_arr_bookTimes Lat:(long)_lat Lng:(long)_lng address:(NSString *)_str_address addressDetail:(NSString *)_str_addressDetail otherMsg:(NSString *)_otherMsg userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_trainerId forKey:@"TrainerId"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_startDate] forKey:@"StartDate"];//
    [dic_params setObjectSafty:[NSNumber numberWithInt:_repeatTimes] forKey:@"RepeatTimes"];
    [dic_params setObjectSafty:_arr_bookTimes forKey:@"BookTimes"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lat] forKey:@"Lat"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lng] forKey:@"Lng"];
    [dic_params setObjectSafty:_str_address forKey:@"Address"];
    [dic_params setObjectSafty:_str_addressDetail forKey:@"AddressDetial"];
    [dic_params setObjectSafty:_otherMsg forKey:@"OtherMsg"];
    
    [self requestUrl:HOST(URL_LOCATION_OrderTrainMultiClass) params:dic_params headers:dic_headers userinfo:_userinfo];

}

#pragma mark - 取消课程定单
-(void)postRequest_Locations_orderCancel:(NSString *)_str_orderId userinfo:(NSMutableDictionary *)_userinfo;
{
 //   [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_orderId forKey:@"OrderId"];
    
    [NetworkEventTrack track:KEY_MIXPANEL_EVENTID_CANCEL_SESSION attrs:nil]; //mixpanel数据 用户取消了预订教练
    
    [self requestUrl:HOST(URL_LOCATION_OrderCancel) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 对课程打分，提交评价
-(void)postRequest_Locations_submitFeedback:(NSString *)_str_orderId trainerId:(NSString *)_str_trainerId rating:(NSInteger)_rating review:(NSString *)_str_review  userinfo:(NSMutableDictionary *)_userinfo;
{
  [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_orderId forKey:@"OrderId"];
    [dic_params setObjectSafty:_str_trainerId forKey:@"TrainerId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_rating] forKey:@"Rating"];
    [dic_params setObjectSafty:_str_review forKey:@"Review"];
    [self requestUrl:HOST(URL_LOCATION_SubmitFeedback) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 订单详细
-(void)postRequest_Locations_orderDetailWithOrderId:(NSString *)_str_orderId userinfo:(NSMutableDictionary *)_userinfo;
{
  [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params setObjectSafty:_str_orderId forKey:@"OrderId"];
    [self requestUrl:HOST(URL_LOCATION_OrderDetail) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 订单锁查询
-(void)postRequest_Locations_checkOrder:(NSMutableDictionary *)_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [self requestUrl:HOST(URL_LOCATION_CheckOrder) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 教练接受训练定单
-(void)postRequest_Locations_update_OrderAccept:(NSString *)_str_orderId absoulte:(BOOL)_bool_isAbsoulte userinfo:(NSMutableDictionary *)_userinfo;
{
  [commond showLoading];

    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
  [dic_params setObjectSafty:[NSNumber numberWithBool:_bool_isAbsoulte] forKey:@"absolute"];
    [dic_params setObjectSafty:_str_orderId forKey:@"OrderId"];
    [self requestUrl:HOST(URL_LOCATION_Update_OrderAccept) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取订单的列表
-(void)postRequest_Locations_orderList:(int)_filter isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_LOCATION_OrderList) isFirstPage:_isFirstPage];
  if(!_str_cursor) {
    if (_isFirstPage)
      _str_cursor = @"0";
    else
      return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
  }
  
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_filter] forKey:@"Filter"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger: _count] forKey:@"Count"];
    
    [self requestUrl:HOST(URL_LOCATION_OrderList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 订单申请支付
-(void)postRequest_Locations_checkByLesson:(NSString *)_str_orderID coupons:(NSMutableArray *)_arr_coupons inviteCoupon:(NSString *)_str_inviteCoupon bundle:(NSMutableArray *)_arr_bundles gatewary:(int)_gateway userinfo:(NSMutableDictionary *)_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_orderID forKey:@"OrderId"];
    if(!_arr_coupons)
        _arr_coupons = [NSMutableArray arrayWithCapacity:1];
    [dic_params setObjectSafty:_arr_coupons forKey:@"Coupons"];
    [dic_params setObjectSafty:_str_inviteCoupon forKey:@"InviteCoupon"];
    [dic_params setObjectSafty:_arr_bundles forKey:@"BundleId"];
    [dic_params setObjectSafty:[NSNumber numberWithInt:_gateway] forKey:@"GateWay"];
    [self requestUrl:HOST(URL_LOCATION_CheckBuyLesson) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 检查购买课程
-(void)postRequest_Locations_bundleList:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [self requestUrl:HOST(URL_LOCATION_BundleList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取优惠券列表
-(void)postRequest_Locations_couponList:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [self requestUrl:HOST(URL_LOCATION_CouponList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 兑换邀请码优惠券
-(void)postRequest_Locations_invitationExchange:(NSString *)_str_invitationCode userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_invitationCode forKey:@"InvitationCode"];
    [self requestUrl:HOST(URL_LOCATION_InvitationExchange) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 订单申请购买课程
-(void)postRequest_Locations_checkBuyBundle:(NSString *)_str_bundleSessonId gateWay:(int)_gateWay userinfo:(NSMutableDictionary *)_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_bundleSessonId forKey:@"BundleLessonId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_gateWay] forKey:@"GateWay"];
    [self requestUrl:HOST(URL_LOCATION_CheckBuyBundle) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取课程的信息
-(void)postRequest_Locations_GetBundleInfo:(NSMutableDictionary *)_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [self requestUrl:HOST(URL_LOCATION_GetBundleInfo) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取日历列表
-(void)postRequest_Locations_calendarList:(long)_startTime endTime:(long)_endTime trainerId:(NSString *)_trainerId userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_trainerId forKey:@"TrainerId"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_startTime] forKey:@"StartTime"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_endTime] forKey:@"EndTime"];
    [self requestUrl:HOST(URL_LOCATION_CalendarList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 设置日历列表
-(void)postRequest_Locations_setCalendar:(NSMutableArray *)_arr_schedule userinfo:(NSMutableDictionary *)_userinfo;
{
  [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_arr_schedule forKey:@"Schedule"];
    [self requestUrl:HOST(URL_LOCATION_SetCalendar) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取健身房列表
-(void)postRequest_Locations_getGymList:(BOOL)_isFirstPage count:(int)_count  lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_LOCATION_GymList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lat] forKey:@"Lat"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lng] forKey:@"Lng"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_LOCATION_GymList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 参加活动
-(void)postRequest_Locations_joinGroup:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_groupId forKey:@"GroupId"];
    [self requestUrl:HOST(URL_LOCATION_JoinGroup) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取我的活动列表
-(void)postRequest_Locations_myGroupList:(MyGroupListType)_filter isFirstPage:(BOOL)_isFirstPage count:(int)_count userinfo:(NSMutableDictionary *)_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_LOCATION_MyGroupList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_filter] forKey:@"Filter"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_LOCATION_MyGroupList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取参与活动的人员列表
-(void)postRequest_Locations_groupParticipant:(NSString *)_str_groupId isFirstPage:(BOOL)_isFirstPage count:(int)_count  userinfo:(NSMutableDictionary *)_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_LOCATION_GroupParticipant) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_groupId forKey:@"GroupId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_LOCATION_GroupParticipant) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 活动组织者
-(void)postRequest_Locations_groupOrganizer:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;
{
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_groupId forKey:@"GroupId"];
    [self requestUrl:HOST(URL_LOCATION_GroupOrganizer) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 获取活动详细内容 包含了活动列表此条数据(先前已得到) GroupParticipant GroupOrganizer 二个接口 其中GroupParticipant需要在页面上多次调用
-(void)postRequest_Locations_groupDetailPage:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    [dic_headers setObjectSafty:@"1080" forKey:@"ScreenResolution"];
    
    NSMutableArray *arr_paramsWrapper = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_groupId forKey:@"GroupId"];
    [dic_params setObjectSafty:@"" forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:10] forKey:@"Count"];
    [self appendParams:dic_params toArray:arr_paramsWrapper requestId:@"1" requestName:@"GroupParticipant"];
    
    NSMutableDictionary *dic_params1 = [NSMutableDictionary dictionary];
    [dic_params1 setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params1 setObjectSafty:_str_groupId forKey:@"GroupId"];
    [self appendParams:dic_params1 toArray:arr_paramsWrapper requestId:@"2" requestName:@"GroupOrganizer"];
    
    [self requestUrl:HOST(URL_LOCATION_GroupDetailPage) params:arr_paramsWrapper headers:dic_headers userinfo:_userinfo];

}

#pragma mark - 获取活动列表
-(void)postRequest_Locations_groupList:(BOOL)_isFirstPage count:(int)_count  lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_userinfo;
{
    NSString *_str_cursor = [self getCursorByURL:HOST(URL_LOCATION_GroupList) isFirstPage:_isFirstPage];
    if(!_str_cursor)
        return;//如果取出的cursor是nil 那么说明到了页尾 不再执行请求
    
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_cursor forKey:@"Cursor"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lat] forKey:@"Lat"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lng] forKey:@"Lng"];
    [dic_params setObjectSafty:[NSNumber numberWithInteger:_count] forKey:@"Count"];
    [self requestUrl:HOST(URL_LOCATION_GroupList) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 活动签到
-(void)postRequest_Locations_checkInGroup:(NSString *)_str_groupId lat:(long)_lat lng:(long)_lng userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_groupId forKey:@"GroupId"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lat] forKey:@"Lat"];
    [dic_params setObjectSafty:[NSNumber numberWithLong:_lng] forKey:@"Lng"];
    [self requestUrl:HOST(URL_LOCATION_CheckInGroup) params:dic_params headers:dic_headers userinfo:_userinfo];
}

#pragma mark - 离开活动
-(void)postRequest_Locations_leaveGroup:(NSString *)_str_groupId userinfo:(NSMutableDictionary *)_userinfo;
{
    [commond showLoading];
    NSMutableDictionary *dic_headers = [NSMutableDictionary dictionary];
    [dic_headers setObjectSafty:[self getAppLang] forKey:@"AppLang"];
    [dic_headers setObjectSafty:[commond getUserDefaults:KEY_API_USER_ACCESSTOKEN] forKey:@"AccessToken"];
    
    NSMutableDictionary *dic_params = [NSMutableDictionary dictionary];
    [dic_params setObjectSafty:[commond getUserDefaults:KEY_API_USER_USERID] forKey:@"UserId"];
    [dic_params setObjectSafty:_str_groupId forKey:@"GroupId"];
    [self requestUrl:HOST(URL_LOCATION_LeaveGroup) params:dic_params headers:dic_headers userinfo:_userinfo];
}
@end
