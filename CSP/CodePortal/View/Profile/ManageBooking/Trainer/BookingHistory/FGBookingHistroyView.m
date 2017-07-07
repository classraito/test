//
//  FGBookingHistroyView.m
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBookingHistroyView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "FGTrainerBookingHistoryFirstCellView.h"
#import "FGTrainerBookingHistoryCellView.h"
@interface FGBookingHistroyView () {
  UIView *view_bg;
}
@end
@implementation FGBookingHistroyView
@synthesize tb_booking;
@synthesize marr_data;
@synthesize str_orderId;
@synthesize view_bookingCancelPopup;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  NSDictionary *_mdic = @{@"hidden":[NSNumber numberWithBool:YES]};
  self.marr_data = [NSMutableArray arrayWithObject:_mdic];
  
  [self internalInitalView];
}

- (void)internalInitalView {
  self.tb_booking.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tb_booking.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tb_booking.delegate = self;
  self.tb_booking.dataSource = self;
  [commond useDefaultRatioToScaleView:self.tb_booking];
  
  __weak __typeof(self) weakSelf = self;
  self.tb_booking.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_orderDetail];
  }];
}

- (void)dealloc {
  self.marr_data       = nil;
  self.tb_booking = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - FGManageBookingPendingCellViewDelegate
- (void)didSelectedContactWithButtonView:(UIView *)_view {
  NSDictionary * _dic_bookingInfo;
  _dic_bookingInfo = self.marr_data[0];
  
  NSString *_str_mobile = _dic_bookingInfo[@"user"][@"Mobile"];
  [commond alertPhoneCallWebViewWithMobile:_str_mobile];
}

- (void)didSelectedCancelWithButtonView:(UIView *)_view {
  NSDictionary * _dic_bookingInfo;
  _dic_bookingInfo = self.marr_data[0];
  self.str_orderId = _dic_bookingInfo[@"orderId"];
  NSLog(@"_dic_bookingInfo==%@", _dic_bookingInfo);
  
  view_bookingCancelPopup = (FGBookingCancelCoursePopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBookingCancelCoursePopView" owner:nil options:nil] objectAtIndex:0];
  [view_bookingCancelPopup setupViewWithInfo:_dic_bookingInfo];
  [commond useDefaultRatioToScaleView:view_bookingCancelPopup];
  view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
  [appDelegate.window addSubview:view_bg];
  [appDelegate.window addSubview:view_bookingCancelPopup];
  
  [view_bookingCancelPopup.btn_cancel addTarget:self action:@selector(buttonAction_backToBookingList:) forControlEvents:UIControlEventTouchUpInside];
  [view_bookingCancelPopup.btn_done addTarget:self action:@selector(buttonAction_bookingCancelCourse:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didSelectedUserIconWithButtonView:(UIView *)_view {
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 144 * ratioH;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.marr_data count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  cell = [self manageBookingHistoryFirstViewCell:tableView];
  
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:self.marr_data[indexPath.row]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

#pragma mark - 自定义cell
- (UITableViewCell *)manageBookingHistoryFirstViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGTrainerBookingHistoryFirstCellView";
  FGTrainerBookingHistoryFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGTrainerBookingHistoryFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

#pragma mark - 订单详情请求
- (void)runRequest_orderDetail {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"orderDetail" forKey:@"orderDetail"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_orderDetailWithOrderId:self.str_orderId userinfo:_dic_info];
}

#pragma mark - 取消订单请求
- (void)runRequest_cancelOrderWithOrderId:(NSString *)_str_orderId {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"cancelOrder" forKey:@"cancelOrder"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_orderCancel:_str_orderId userinfo:_dic_info];
}


#pragma mark - 按钮事件
- (void)buttonAction_backToBookingList:(id)_sender {
  [self clearBookingCancelCourseView];
}

- (void)buttonAction_bookingCancelCourse:(id)_sender {
  [self runRequest_cancelOrderWithOrderId:self.str_orderId];
}

#pragma mark - 刷新界面
- (void)bindDataToUI {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderDetail)];
  
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    [self.tb_booking reloadData];
    [self.tb_booking.mj_header endRefreshing];
    return;
  }
  
  NSMutableArray *_marr_tmp = [NSMutableArray array];
  NSInteger maxLength = 40;

  NSDictionary *_dic_orderInfo = _dic_info;//_arr_orders[i];
  NSString *_str_orderId = _dic_orderInfo[@"OrderId"];
  NSString *_str_key = @"User";
  
  NSDictionary *_dic_userInfo = _dic_orderInfo[_str_key];
  NSString *_str_bookingTime = _dic_orderInfo[@"BookTime"];
  _str_bookingTime = [FGUtils dateSpecificTimeWithTimeIntervalSecondStr:_str_bookingTime withFormat:@"yyyy-MM-dd h:mm a"];
  
  NSArray *_arr_bookingTime = [_str_bookingTime componentsSeparatedByString:@" "];
  NSString *_str_bookingTime_Detail = [NSString stringWithFormat:@"%@: %@ %@",multiLanguage(@"Time"),_arr_bookingTime[1], _arr_bookingTime[2]];
  NSString *_str_bookingTime_Date = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"Date"), _arr_bookingTime[0]];
  
  NSString *_str_AddressDetail = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"AddressDetial"), _dic_orderInfo[@"AddressDetial"]];
  NSString *_str_Address = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"Location"), _dic_orderInfo[@"Address"]];
  
  NSString *_str_otherMsg = _dic_orderInfo[@"OtherMsg"];
  if ([_str_otherMsg isEmptyStr]) {
    _str_otherMsg = @"-";
  }
  _str_otherMsg = [_str_otherMsg stringByAppendingString:@"\n"];
  NSString *str_cotent = [NSString stringWithFormat:@"%@: %@",multiLanguage(@"OtherMsg"),_str_otherMsg];
  str_cotent = [FGUtils limitWithString:str_cotent maxLength:maxLength];
  
  NSDictionary *dic_info = @{ @"content" : @[
                                  [FGUtils createAttributeTextInfo:str_cotent font:font(FONT_TEXT_REGULAR, 15) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:4 textAlignment:NSTextAlignmentLeft sepeatorByString:@""]
                                  ]
                              };
  
  NSMutableAttributedString *mattr_str = [FGUtils createAttributedStringWithContentInfo:dic_info[@"content"]];
  
  NSString *_str_status = [NSString stringWithFormat:@"%@",_dic_orderInfo[@"Status"]];
  NSTimeInterval _time_left = [_dic_orderInfo[@"TimeLeft"] doubleValue];
  
  [_marr_tmp addObject:@{@"content": mattr_str,
                         @"user":_dic_userInfo,
                         @"date": _str_bookingTime_Date,
                         @"dateTime": _str_bookingTime_Detail,
                         @"location": _str_Address,
                         @"locationDetail": _str_AddressDetail,
                         @"orderId":_str_orderId,
                         @"status":_str_status,
                         @"timeLeft":[NSNumber numberWithDouble:_time_left],
                         @"originContent": _str_otherMsg,
                         @"orderInfo": _dic_orderInfo}];
  
  self.marr_data = _marr_tmp;
  
  [self.tb_booking reloadData];
  [self.tb_booking.mj_header endRefreshing];
}

- (void)bindDataToUIForCancelOrder {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderCancel)];
  
  [self clearBookingCancelCourseView];
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code == 0) {
    NSMutableArray *_marr = [NSMutableArray arrayWithArray:self.marr_data];
    [_marr removeObjectAtIndex:0];
    self.marr_data = _marr;
    NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *_arr_delete = [NSArray arrayWithObject:_indexPath];
    [self.tb_booking deleteRowsAtIndexPaths:_arr_delete withRowAnimation:UITableViewRowAnimationAutomatic];
    return;
  }
}

#pragma mark - 删除取消界面
- (void)clearBookingCancelCourseView {
  SAFE_RemoveSupreView(view_bookingCancelPopup);
  SAFE_RemoveSupreView(view_bg);
  view_bg = nil;
  view_bookingCancelPopup = nil;
}


#pragma mark -
- (void)loadData {
  [self.tb_booking.mj_header beginRefreshing];
}
@end
