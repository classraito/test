//
//  FGManageBookingView.m
//  CSP
//
//  Created by JasonLu on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGManageBookingView.h"
#import "FGManagingBookTitleView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "FGManageBookingPendingCellView.h"
#import "UITableView+ShowNoResult.h"
@interface FGManageBookingView () {
  FGBookingDetailInfoPopView *view_bookingDetailInfo;
  UIView *view_bg;
}

@end

@implementation FGManageBookingView
@synthesize marr_data;
@synthesize tb_bookingForPending;
@synthesize tb_bookingForAccepted;
@synthesize tb_bookingForHistory;
@synthesize marr_dataForPending;
@synthesize marr_dataForAccepted;
@synthesize marr_dataForHistory;
@synthesize section_currentSelected;
@synthesize str_id;
@synthesize str_orderId;
@synthesize int_cursor;
@synthesize int_cancelOrderIndex;
@synthesize view_bookingCancelPopup;

#pragma mark - 初始化
- (BOOL) internalInitalViewForPending {
  if ([self.tb_bookingForPending.mj_header isRefreshing])
    return NO;
  
  if (self.tb_bookingForPending == nil) {
    self.tb_bookingForPending = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 462)];
    self.tb_bookingForPending.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tb_bookingForPending.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tb_bookingForPending.delegate = self;
    self.tb_bookingForPending.dataSource = self;
    [commond useDefaultRatioToScaleView:self.tb_bookingForPending];
    [self addSubview:self.tb_bookingForPending];
  }
  
  self.marr_dataForPending = [NSMutableArray array];
  return YES;
//  __weak __typeof(self) weakSelf = self;
//  self.tb_bookingForPending.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    [weakSelf runRequest_trainerBookingForPending];
//  }];
//  
//  [self.tb_bookingForPending addInfiniteScrollingWithActionHandler:^{
//    [weakSelf loadMore_trainerPending];
//  }];
//  
//  [self.tb_bookingForPending.mj_header beginRefreshing];
}

- (BOOL) internalInitalViewForHistory {
  if ([self.tb_bookingForHistory.mj_header isRefreshing])
    return NO;
  
  if (self.tb_bookingForHistory == nil) {
    self.tb_bookingForHistory = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 462)];
    self.tb_bookingForHistory.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tb_bookingForHistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tb_bookingForHistory.delegate = self;
    self.tb_bookingForHistory.dataSource = self;
    [commond useDefaultRatioToScaleView:self.tb_bookingForHistory];
    [self addSubview:self.tb_bookingForHistory];
  }
  
  self.marr_dataForHistory = [NSMutableArray array];
  return YES;
//  __weak __typeof(self) weakSelf = self;
//  self.tb_bookingForHistory.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    [weakSelf runRequest_trainerBookingForHistory];
//  }];
//  
//  [self.tb_bookingForHistory addInfiniteScrollingWithActionHandler:^{
//    [weakSelf loadMore_trainerHistory];
//  }];
//  
//  [self.tb_bookingForHistory.mj_header beginRefreshing];
  
}

- (BOOL) internalInitalViewForAccepted {
  if ([self.tb_bookingForAccepted.mj_header isRefreshing])
    return NO;
  
  if (self.tb_bookingForAccepted == nil) {
    self.tb_bookingForAccepted = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 462)];
    self.tb_bookingForAccepted.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tb_bookingForAccepted.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tb_bookingForAccepted.delegate = self;
    self.tb_bookingForAccepted.dataSource = self;
    [commond useDefaultRatioToScaleView:self.tb_bookingForAccepted];
    [self addSubview:self.tb_bookingForAccepted];
  }
  self.marr_dataForAccepted = [NSMutableArray array];
  return YES;
}

#pragma mark - FGManageBookingPendingCellViewDelegate
- (void)handleDidSelectedUserIconWithButtonView:(UIView *)_view {
  
}

- (void)handleDidSelectedAcceptedWithButtonView:(UIView *)_view {
}

- (void)handleDidSelectedContactWithButtonView:(UIView *)_view {
  NSDictionary * _dic_bookingInfo;
  NSInteger _int_idx;
  _dic_bookingInfo = [self getCellInfoFromView:_view atIndex:&_int_idx];
  
  NSString *_str_mobile = _dic_bookingInfo[@"user"][@"Mobile"];
  [commond alertPhoneCallWebViewWithMobile:_str_mobile];
}

- (void)handleDidSelectedCancelWithButtonView:(UIView *)_view {
  NSDictionary * _dic_bookingInfo;
  NSInteger _int_idx;
  _dic_bookingInfo = [self getCellInfoFromView:_view atIndex:&_int_idx];
  int_cancelOrderIndex = _int_idx;
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
#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0) {
    return 144 * ratioH;
  }
  return 150 * ratioH;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self currentBookingDataSource] count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  NSDictionary *_dic_bookingInfo = [self currentBookingDataSource][indexPath.row];
  
  view_bookingDetailInfo = (FGBookingDetailInfoPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBookingDetailInfoPopView" owner:nil options:nil] objectAtIndex:0];
  [view_bookingDetailInfo setupBookingDetailWithInfo:_dic_bookingInfo];
  [commond useDefaultRatioToScaleView:view_bookingDetailInfo];
  view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
  [appDelegate.window addSubview:view_bg];
  [appDelegate.window addSubview:view_bookingDetailInfo];
  
  [view_bookingDetailInfo.btn_cancel addTarget:self action:@selector(buttonAction_removeBookingDetailInfoPopView:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 数据源
- (UITableView *)currentTableView {
  if (self.section_currentSelected == SECTION_PENDING) {
    return self.tb_bookingForPending;
  } else if (self.section_currentSelected == SECTION_ACCEPTED) {
    return self.tb_bookingForAccepted;
  } else {
    return self.tb_bookingForHistory;
  }
  return nil;
}

- (NSMutableArray *)currentBookingDataSource {
  if (self.section_currentSelected == SECTION_PENDING) {
    return self.marr_dataForPending;
  } else if (self.section_currentSelected == SECTION_ACCEPTED) {
    return self.marr_dataForAccepted;
  }
  
  return self.marr_dataForHistory;
}


- (void)updateCurrentBookingDataSourceWithArr:(NSMutableArray *)_marr {
  if (self.section_currentSelected == SECTION_PENDING) {
    self.marr_dataForPending = _marr;
  } else if (self.section_currentSelected == SECTION_ACCEPTED) {
    self.marr_dataForAccepted = _marr;
  } else {
    self.marr_dataForHistory = _marr;
  }
}

#pragma mark - 刷新界面
- (void)refreshUIWithInfo:(NSDictionary *)_dic_info {
  self.int_cursor = [_dic_info[@"Cursor"] integerValue];
  
  if ([self isErrorFromResponseInfo:_dic_info])
    return;
  
  NSMutableArray *_marr_tmp = [NSMutableArray array];
  NSMutableArray *_marr_ret = [self dataInfoFromReuqestWithInfo:_dic_info];
  
  if (!ISNULLObj(_marr_ret)) {
    _marr_tmp = _marr_ret;
  }
  [self updateCurrentBookingDataSourceWithArr:_marr_tmp];
  
  [[self currentTableView] reloadData];
  [[self currentTableView].mj_header endRefreshing];
  
  int cursor                    = [[_dic_info objectForKey:@"Cursor"] intValue];
  [self refreshTableViewFooterWithActivityStatus:cursor==-1?NO:YES];
  
  if (_marr_tmp.count <= 0) {
    [[self currentTableView] showNoResultWithText:multiLanguage(@"No booking records yet!")];
  }
}

- (void)refreshLoadMoreUIWithInfo:(NSDictionary *)_dic_info{
  if ([self isErrorFromResponseInfo:_dic_info])
    return;
  
  NSMutableArray *_marr_more = [self dataInfoFromReuqestWithInfo:_dic_info];
  if (_marr_more && _marr_more.count > 0) {
    NSMutableArray *_marr_current = [self currentBookingDataSource];
    [_marr_current addObjectsFromArray:_marr_more];
    
    [self updateCurrentBookingDataSourceWithArr:_marr_current];
  }
  
  [[self currentTableView] reloadData];
  [[self currentTableView].refreshFooter endRefreshing];
  
  int cursor                    = [[_dic_info objectForKey:@"Cursor"] intValue];
  [self refreshTableViewFooterWithActivityStatus:cursor==-1?NO:YES];
}

#pragma mark - 删除取消界面
- (void)clearBookingCancelCourseView {
  SAFE_RemoveSupreView(view_bookingCancelPopup);
  SAFE_RemoveSupreView(view_bg);
  
  view_bg = nil;
  view_bookingCancelPopup = nil;
}

#pragma mark - 刷新界面从取消订单请求
- (void)loadUIFromCancelOrder {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderCancel)];
  
  [self clearBookingCancelCourseView];
  
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code == 0) {
    NSMutableArray *_marr = [NSMutableArray arrayWithArray:[self currentBookingDataSource]];
    [_marr removeObjectAtIndex:self.int_cancelOrderIndex];
    [self updateCurrentBookingDataSourceWithArr:_marr];
    NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:self.int_cancelOrderIndex inSection:0];
    NSArray *_arr_delete = [NSArray arrayWithObject:_indexPath];
    [[self currentTableView] deleteRowsAtIndexPaths:_arr_delete withRowAnimation:UITableViewRowAnimationAutomatic];
    return;
  }
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

- (void)buttonAction_removeBookingDetailInfoPopView:(id)sender {
  SAFE_RemoveSupreView(view_bookingDetailInfo);
  SAFE_RemoveSupreView(view_bg);
  view_bg = nil;
  view_bookingDetailInfo = nil;
}
#pragma mark - 其它
- (NSDictionary *)getCellInfoFromView:(UIView *)_view atIndex:(NSInteger *)_int_idx {
  FGManageBookingPendingCellView *cell  = (FGManageBookingPendingCellView *)[[_view superview] superview];
  NSIndexPath *_indexPath = [[self currentTableView] indexPathForCell:cell];
  NSDictionary * _dic_bookingInfo = [self currentBookingDataSource][_indexPath.row];
  
  *_int_idx = _indexPath.row;
  return _dic_bookingInfo;
}

- (void)updateVisiableBookingDetailWithSection:(enum_section)_status {

  [self.view_manageBookingTitle setupSectionStatus:_status];
  [[self currentTableView] resetNoResultView];
  BOOL _bool_initSuccess = NO;
  if (_status == SECTION_PENDING) {
    _bool_initSuccess = [self internalInitalViewForPending];
    if (_bool_initSuccess == NO)
      return;
    
    if(self.tb_bookingForAccepted) {
      [self.tb_bookingForAccepted setRefreshFooter:nil];
      self.tb_bookingForAccepted.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_bookingForAccepted);
      self.tb_bookingForAccepted = nil;
    }
    if(self.tb_bookingForHistory) {
      [self.tb_bookingForHistory setRefreshFooter:nil];
      self.tb_bookingForHistory.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_bookingForHistory);
      self.tb_bookingForHistory = nil;
    }
  } else if (_status == SECTION_ACCEPTED){
    _bool_initSuccess = [self internalInitalViewForAccepted];
    if (_bool_initSuccess == NO)
      return;
    if(self.tb_bookingForPending) {
      [self.tb_bookingForPending setRefreshFooter:nil];
      self.tb_bookingForPending.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_bookingForPending);
      self.tb_bookingForPending = nil;
    }
    
    if(self.tb_bookingForHistory) {
      [self.tb_bookingForHistory setRefreshFooter:nil];
      self.tb_bookingForHistory.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_bookingForHistory);
      self.tb_bookingForHistory = nil;
    }
  } else {
    _bool_initSuccess = [self internalInitalViewForHistory];
    if (_bool_initSuccess == NO)
      return;
    if(self.tb_bookingForPending) {
      [self.tb_bookingForPending setRefreshFooter:nil];
      self.tb_bookingForPending.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_bookingForPending);
      self.tb_bookingForPending = nil;
    }
    
    if(self.tb_bookingForAccepted) {
      [self.tb_bookingForAccepted setRefreshFooter:nil];
      self.tb_bookingForAccepted.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_bookingForAccepted);
      self.tb_bookingForAccepted = nil;
    }
  }
  self.section_currentSelected = _status;
}

- (void)action_handleSection:(enum_section)section {
  [self setupManageBookingStatus:section];
}

- (BOOL)isErrorFromResponseInfo:(NSDictionary *)_dic_info {
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    [[self currentTableView] reloadData];
    [[self currentTableView].mj_header endRefreshing];
    return YES;
  }
  return NO;
}

- (NSMutableArray *)dataInfoFromReuqestWithInfo:(NSDictionary *)_dic_info {
  self.int_cursor = [_dic_info[@"Cursor"] integerValue];
  
  if ([self isErrorFromResponseInfo:_dic_info])
    return nil;
  
  NSArray *_arr_orders = _dic_info[@"Orders"];
  NSMutableArray *_marr_tmp = [NSMutableArray array];
  NSInteger maxLength = 40;
  for(int i=0;i<_arr_orders.count;i++) {
    NSDictionary *_dic_orderInfo = _arr_orders[i];
    
    NSString *_str_orderId = _dic_orderInfo[@"OrderId"];
    NSString *_str_key;
    if ([commond isUser])
      _str_key = @"Trainer";
    else
      _str_key = @"User";
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
  }
  
  return _marr_tmp;
}


-(void)hideFooterLoadingIfNeeded
{
  [[self currentTableView].refreshFooter endRefreshing];
  BOOL _bool_activity = (self.int_cursor == -1 ? YES:NO);
  [self refreshTableViewFooterWithActivityStatus:_bool_activity];
}

- (void)refreshTableViewFooterWithActivityStatus:(BOOL)_bool_activity {
  [[self currentTableView] allowedShowActivityAtFooter:_bool_activity];
}



- (FGManagingBookTitleView *)manageBookingTitleView {
  if (self.view_manageBookingTitle)
    return self.view_manageBookingTitle;
  FGManagingBookTitleView *titleView = (FGManagingBookTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGManagingBookTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  titleView.frame     = CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height);
  
  //  [titleView setupSectionStatus:SECTION_PENDING];
  //  [titleView setupSectionFirstButtonTitle:multiLanguage(@"PENDING") secondButtonTitle:multiLanguage(@"HISTORY") thirdButtonTitle:multiLanguage(@"BUNDLE")];
  self.view_manageBookingTitle = titleView; //添加标题信息
  //  [self.view_titleBg addSubview:titleView];
  //  titleView.delegate = self;
  
  return self.view_manageBookingTitle;
}

@end
