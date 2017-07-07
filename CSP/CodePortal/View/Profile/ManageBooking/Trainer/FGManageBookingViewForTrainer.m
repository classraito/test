//
//  FGManageBookingViewForTrainer.m
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGManageBookingViewForTrainer.h"
#import "FGManagingBookTitleView.h"
#import "FGManageBookingPendingCellView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "FGMyBookingPendingCellView.h"
#import "FGManageBookingPendingFirstCellView.h"
#import "FGManageBookingPendingForPayCellView.h"
#import "FGManageBookingPendingForPayFristCellView.h"
#import "FGMyBookingPendingFirstCellView.h"
#import "FGMyBookingHistoryCellView.h"
#import "FGMyBookingHistoryFirstCellView.h"
@interface FGManageBookingViewForTrainer () <FGManagingBookTitleViewDelegate, FGManageBookingPendingCellViewDelegate> {
  UILabel *lb_tmp;
  NSInteger int_orderIdx;
  FGBookingAcceptCourseBetweenTwoPopView *view_bookingAcceptCourseBetweenTwo;
  UIView *view_bg;
}
@end

@implementation FGManageBookingViewForTrainer
@synthesize timer_payCount;
@synthesize delegate;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self internalInitalTitleSectionView];
  [self internalInitalView];
  // 添加notification
  [self internalNotification];
}

- (void)dealloc {
  self.marr_data       = nil;
  self.tb_bookingForPending = nil;
  self.tb_bookingForHistory = nil;
  self.tb_bookingForAccepted = nil;
  [self clearPayCountTimer];
  [self clearNotification];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 初始化方法
- (void)internalInitalTitleSectionView {
  FGManagingBookTitleView *titleView = [self manageBookingTitleView];
  [titleView setupSectionStatus:SECTION_PENDING];
  [titleView setupSectionFirstButtonTitle:multiLanguage(@"PENDING") secondButtonTitle:multiLanguage(@"ACCEPTED") thirdButtonTitle:multiLanguage(@"HISTORY")];
  [self.view_titleBg addSubview:titleView];
  titleView.delegate = self;
}

- (void)internalInitalView {
  [self.view_manageBookingTitle setupSectionStatus:SECTION_PENDING];
}

- (void)internalNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_refreshAfterAcceptCourseWithInfo:) name:NOTIFICATION_ACCEPTCOURSESUCCESS object:nil];
}

- (void)clearNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ACCEPTCOURSESUCCESS object:nil];
}

- (BOOL) internalInitalViewForPending {
  if (![super internalInitalViewForPending]) {
    return NO;
  }
  
  __weak __typeof(self) weakSelf = self;
  self.tb_bookingForPending.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_trainerBookingForPending];
  }];
  
  [self.tb_bookingForPending addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_trainerPending];
  }];
  
  [self.tb_bookingForPending.mj_header beginRefreshing];
  return YES;
}

- (BOOL) internalInitalViewForHistory {
  if (![super internalInitalViewForHistory])
    return NO;
  
  __weak __typeof(self) weakSelf = self;
  self.tb_bookingForHistory.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_trainerBookingForHistory];
  }];
  
  [self.tb_bookingForHistory addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_trainerHistory];
  }];
  
  [self.tb_bookingForHistory.mj_header beginRefreshing];
  return YES;
}

- (BOOL) internalInitalViewForAccepted {
  if (![super internalInitalViewForAccepted])
    return NO;
  
  __weak __typeof(self) weakSelf = self;
  self.tb_bookingForAccepted.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_trainerBookingForAccepted];
  }];
  
  [self.tb_bookingForAccepted addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_trainerAccepted];
  }];
  
  [self.tb_bookingForAccepted.mj_header beginRefreshing];
  return YES;
}

#pragma mark - Booking界面切换方法
- (void)setupManageBookingStatus:(enum_section)_status {
  [self updateVisiableBookingDetailWithSection:_status];
}

- (void)updateVisiableBookingDetailWithSection:(enum_section)_status {
  [super updateVisiableBookingDetailWithSection:_status];
}

#pragma mark - FGManageBookingPendingCellViewDelegate
- (void)didSelectedAcceptedWithButtonView:(UIView *)_view {
  FGManageBookingPendingCellView *cell  = (FGManageBookingPendingCellView *)[[_view superview] superview];
  NSIndexPath *_indexPath = [[self currentTableView] indexPathForCell:cell];
  NSDictionary * _dic_bookingInfo = [self currentBookingDataSource][_indexPath.row];
  
  int_orderIdx = _indexPath.row;
  NSString *_str_orderId = _dic_bookingInfo[@"orderId"];
  self.str_orderId = _str_orderId;
  [self runRequest_trainerAcceptOrderWithOrderId:_str_orderId];
}

- (void)didSelectedUserIconWithButtonView:(UIView *)_view {
  FGManageBookingPendingCellView *cell  = (FGManageBookingPendingCellView *)[[_view superview] superview];
  NSIndexPath *_indexPath = [[self currentTableView] indexPathForCell:cell];
  NSDictionary * _dic_bookingInfo = [self currentBookingDataSource][_indexPath.row];
  [self.delegate didGotoUserInfoWithUserId:_dic_bookingInfo[@"user"][@"UserId"]];
}

- (void)didSelectedContactWithButtonView:(UIView *)_view {
  [super handleDidSelectedContactWithButtonView:_view];
}

- (void)didSelectedCancelWithButtonView:(UIView *)_view {
  [super handleDidSelectedCancelWithButtonView:_view];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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
  
  NSDictionary *_dic_bookingInfo = [self currentBookingDataSource][indexPath.row];
  if (self.section_currentSelected == SECTION_PENDING) {
    NSInteger _int_status = [_dic_bookingInfo[@"status"] integerValue];
    if (indexPath.row == 0) {
      if (_int_status == 2) {
        cell = [self manageBookingPendingForPayFristViewCell:tableView];
      } else if (_int_status == 1) {
        cell = [self manageBookingPendingFirstViewCell:tableView];
      }
    }
    else {
      if (_int_status == 2) {
        cell = [self manageBookingPendingForPayViewCell:tableView];
      }else if (_int_status == 1) {
        cell = [self manageBookingPendingViewCell:tableView];
      }
    }
  }
  else if (self.section_currentSelected == SECTION_ACCEPTED)
    if (indexPath.row == 0) {
        cell = [self manageBookingAcceptedFirstViewCell:tableView];
    }
    else {
        cell = [self manageBookingAcceptedViewCell:tableView];
    }
  else {
    if (indexPath.row == 0) {
      cell = [self manageBookingHistoryFirstViewCell:tableView];
    }
    else {
      cell = [self manageBookingHistoryViewCell:tableView];
    }
  }
  
  if ([cell isKindOfClass:[FGManageBookingPendingForPayFristCellView class]] ||
      [cell isKindOfClass:[FGManageBookingPendingForPayCellView class]]) {
    NSDictionary *_mdic_bookingInfo = [NSMutableDictionary dictionaryWithDictionary:_dic_bookingInfo];
    [_mdic_bookingInfo setValue:[NSNumber numberWithInteger:indexPath.row] forKey:@"index"];
    [cell updateCellViewWithInfo:_mdic_bookingInfo];
  }
  else
  {
    if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
      [cell updateCellViewWithInfo:_dic_bookingInfo];
    }
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 自定义cell
- (UITableViewCell *)manageBookingPendingForPayFristViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGManageBookingPendingForPayFristCellView";
  FGManageBookingPendingForPayFristCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGManageBookingPendingForPayFristCellView" owner:self options:nil] lastObject];
  }
  return cell;
}

- (UITableViewCell *)manageBookingPendingForPayViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGManageBookingPendingForPayCellView";
  FGManageBookingPendingForPayCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGManageBookingPendingForPayCellView" owner:self options:nil] lastObject];
  }
  return cell;
}

- (UITableViewCell *)manageBookingPendingFirstViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGManageBookingPendingFirstCellView";
  FGManageBookingPendingFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGManageBookingPendingFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)manageBookingPendingViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGManageBookingPendingCellView";
  FGManageBookingPendingCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGManageBookingPendingCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)manageBookingAcceptedFirstViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingPendingFirstCellView";
  FGMyBookingPendingFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingPendingFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)manageBookingAcceptedViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingPendingCellView";
  FGMyBookingPendingCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingPendingCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}
- (UITableViewCell *)manageBookingHistoryFirstViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingHistoryFirstCellView";
  FGMyBookingHistoryFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingHistoryFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}
- (UITableViewCell *)manageBookingHistoryViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingHistoryCellView";
  FGMyBookingHistoryCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingHistoryCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

#pragma mark - 刷新
- (void)beginRefreshFromPushWithInfo:_dic_info {
  NSString *_str_sectionFromPush = _dic_info[@"section"];
  enum_section sectionFromPush;
  if ([_str_sectionFromPush isEqualToString:@"pending"]) {
    sectionFromPush = SECTION_PENDING;
  } else if ([_str_sectionFromPush isEqualToString:@"accepted"]) {
    sectionFromPush = SECTION_ACCEPTED;
  }
  [self.view_manageBookingTitle setupSectionStatus:sectionFromPush];
  [self setupManageBookingStatus:sectionFromPush];
  
}


- (void)refreshUI {
  [[self currentTableView] resetNoResultView];
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_TrainOrderList)];
  [self refreshUIWithInfo:_dic_info];
}

- (void)refreshUIForLoadMore {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_TrainOrderList)];
  [self refreshLoadMoreUIWithInfo:_dic_info];
}

- (void)clearBookingAcceptCourseBetweenTwoView {
  SAFE_RemoveSupreView(view_bookingAcceptCourseBetweenTwo);
  SAFE_RemoveSupreView(view_bg);
  view_bg = nil;
  view_bookingAcceptCourseBetweenTwo = nil;
}

#pragma mark - 刷新pending界面
- (void)bindDataToUIForPending {
  if (self.section_currentSelected != SECTION_PENDING)
    return;
  
  [self refreshUI];
  [self clearPayCountTimer];

  if ([self currentBookingDataSource].count > 0)
    [self internalInitPayCountTimer];
}

- (void)loadMoreBookingForPending {
  [self refreshUIForLoadMore];
}

#pragma mark - 刷新accpeted界面
- (void)bindDataToUIForAccepted {
  if (self.section_currentSelected != SECTION_ACCEPTED)
    return;
  
  [self clearPayCountTimer];
  [self refreshUI];
}

- (void)loadMoreBookingForAccepted {
  [self refreshUIForLoadMore];
}

#pragma mark - 刷新history界面
- (void)bindDataToUIForHistory {
  if (self.section_currentSelected != SECTION_HISTORY)
    return;
  
  [self clearPayCountTimer];
  [self refreshUI];
}

- (void)loadMoreBookingForHistory {
  [self refreshUIForLoadMore];
}

#pragma mark - 刷新界面从pending到等待付款界面
- (void)loadUIFromPendingToPay {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_Update_OrderAccept)];
  
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    [[self currentTableView] reloadData];
    [[self currentTableView].mj_header endRefreshing];
    return;
  }
  
  NSArray *_arr_orders = _dic_info[@"Orders"];
  //直接跳入accepted界面, 进行刷新
  if (ISNULLObj(_arr_orders) || _arr_orders.count <= 0) {
    [self updatePayStatusInfoWithInfo:_dic_info atIndex:int_orderIdx];
    [FGUtils reloadCellWithTableView:[self currentTableView] atIndex:int_orderIdx];
    return;
  }
  
  view_bookingAcceptCourseBetweenTwo = (FGBookingAcceptCourseBetweenTwoPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBookingAcceptCourseBetweenTwoPopView" owner:nil options:nil] objectAtIndex:0];
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:_dic_info];
    [_mdic setValue:self.str_orderId forKey:@"orderId"];
  [view_bookingAcceptCourseBetweenTwo setupViewWithInfo:_mdic];
  [commond useDefaultRatioToScaleView:view_bookingAcceptCourseBetweenTwo];
  view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
  [appDelegate.window addSubview:view_bg];
  [appDelegate.window addSubview:view_bookingAcceptCourseBetweenTwo];
  
  [view_bookingAcceptCourseBetweenTwo.btn_cancel addTarget:self action:@selector(buttonAction_backToBookingPendingList:) forControlEvents:UIControlEventTouchUpInside];
  [view_bookingAcceptCourseBetweenTwo.btn_done addTarget:self action:@selector(buttonAction_bookingAcceptCourse:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)notification_refreshAfterAcceptCourseWithInfo:(id)sender {
  [self clearBookingAcceptCourseBetweenTwoView];
  NSDictionary *_dic_info = (NSDictionary *)[sender object];
  [self updatePayStatusInfoWithInfo:_dic_info atIndex:int_orderIdx];
  [FGUtils reloadCellWithTableView:[self currentTableView] atIndex:int_orderIdx];
}

#pragma mark - 请求pending数据
- (void)runRequest_trainerBookingForPending {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerBookingForPending" forKey:@"trainerBookingForPending"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:1 isFirstPage:YES count:10 userinfo:_dic_info];
}

- (void)loadMore_trainerPending {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerBookingForPending" forKey:@"trainerBookingForPending"];
    [_dic_info setObject:@"trainerBookingForPending_loadMore" forKey:@"trainerBookingForPending_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:1 isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - 请求accpeted数据
- (void)runRequest_trainerBookingForAccepted {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerBookingForAccepted" forKey:@"trainerBookingForAccepted"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:2 isFirstPage:YES count:10 userinfo:_dic_info];
}

- (void)loadMore_trainerAccepted {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerBookingForAccepted" forKey:@"trainerBookingForAccepted"];
  [_dic_info setObject:@"trainerBookingForAccepted_loadMore" forKey:@"trainerBookingForAccepted_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:2 isFirstPage:NO count:10 userinfo:_dic_info];
}

- (void)postRequest_trainerAcceptOrderWithOrderId:(NSString *)_str_orderId {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerAcceptOrderBetweenTwoCourses" forKey:@"trainerAcceptOrderBetweenTwoCourses"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_update_OrderAccept:_str_orderId absoulte:YES userinfo:_dic_info];
}

#pragma mark - 请求history数据
- (void)runRequest_trainerBookingForHistory {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerBookingForHistory" forKey:@"trainerBookingForHistory"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:3 isFirstPage:YES count:10 userinfo:_dic_info];
}

- (void)loadMore_trainerHistory {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerBookingForHistory" forKey:@"trainerBookingForHistory"];
  [_dic_info setObject:@"trainerBookingForHistory_loadMore" forKey:@"trainerBookingForHistory_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_trainOrderListWithTrainerId:self.str_id orderFilter:3 isFirstPage:NO count:10 userinfo:_dic_info];
}

- (void)runRequest_trainerAcceptOrderWithOrderId:(NSString *)_str_orderId {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"trainerAcceptOrder" forKey:@"trainerAcceptOrder"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_update_OrderAccept:_str_orderId absoulte:NO userinfo:_dic_info];
}

#pragma mark - 按钮事件
- (void)buttonAction_bookingAcceptCourse:(id)_sender {
  [self postRequest_trainerAcceptOrderWithOrderId:self.str_orderId];
}

- (void)buttonAction_backToBookingPendingList:(id)_sender {
  [self clearBookingAcceptCourseBetweenTwoView];
}

#pragma mark - 倒计时付款时间方法
- (void)internalInitPayCountTimer {
  [self clearPayCountTimer];
  self.timer_payCount = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCellForPayCount) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:self.timer_payCount forMode:NSRunLoopCommonModes];
}

- (void)clearPayCountTimer {
  if (self.timer_payCount) {
    [self.timer_payCount invalidate];
    self.timer_payCount = nil;
  }
}

- (void)updatePayStatusInfoWithInfo:(NSDictionary *)_dic atIndex:(NSInteger)_int_idx {
  NSMutableArray *_marr_tmp = [NSMutableArray arrayWithArray:self.marr_dataForPending];
  NSDictionary *_dic_info = (NSDictionary *)_marr_tmp[_int_idx];
  
  NSTimeInterval _time_left = [_dic[@"TimeLeft"] doubleValue];
  NSMutableDictionary *_mdic_tmp = [NSMutableDictionary dictionaryWithDictionary:_dic_info];
  [_mdic_tmp setValue:[NSNumber numberWithDouble:_time_left] forKey:@"timeLeft"];
  [_mdic_tmp setValue:@2 forKey:@"status"];
  [_marr_tmp replaceObjectAtIndex:_int_idx withObject:_mdic_tmp];
  
  [self updateCurrentBookingDataSourceWithArr:_marr_tmp];
}

- (void)updateCellForPayCount {
  NSMutableArray *_marr_delete = [NSMutableArray array];
  NSMutableArray *_marr_tmp = [NSMutableArray arrayWithArray:self.marr_dataForPending];
  [_marr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_info = (NSDictionary *)obj;
    NSInteger int_status = [_dic_info[@"status"] integerValue];
    if (int_status == 2) {
      //等待用户付款
      NSTimeInterval _time_left = [_dic_info[@"timeLeft"] doubleValue];
      _time_left--;
      //更新订单时间
      if (_time_left < 0) {
        //移除订单
        [_marr_tmp removeObjectAtIndex:idx];
        NSIndexPath *_indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
        [_marr_delete addObject:_indexPath];
      }
      else {
        NSMutableDictionary *_mdic_tmp = [NSMutableDictionary dictionaryWithDictionary:_dic_info];
        [_mdic_tmp setValue:[NSNumber numberWithDouble:_time_left] forKey:@"timeLeft"];
        [_marr_tmp replaceObjectAtIndex:idx withObject:_mdic_tmp];
        
        NSDictionary *_dic_ = @{@"time":[NSNumber numberWithDouble:_time_left],
                                @"index":[NSNumber numberWithInteger:idx]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CELL_TIME object:_dic_];
      }
    }
  }];
  [self updateCurrentBookingDataSourceWithArr:_marr_tmp];
  
  if (_marr_delete.count > 0) {
    //刷新界面
    [[self currentTableView] deleteRowsAtIndexPaths:_marr_delete withRowAnimation:UITableViewRowAnimationAutomatic];
  }
}
@end
