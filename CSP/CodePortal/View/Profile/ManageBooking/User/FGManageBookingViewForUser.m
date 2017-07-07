//
//  FGManageBookingViewForUser.m
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGManageBookingViewForUser.h"
#import "FGManagingBookTitleView.h"
#import "FGMyBookingPendingCellView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "FGMyBookingHistoryCellView.h"
#import "FGMyBookingPendingFirstCellView.h"
#import "FGMyBookingPendingCellView.h"
#import "FGMyBookingHistoryFirstCellView.h"
#import "FGMyBookingBundleListCellView.h"
#import "FGMyBookingBundleForCouponCellView.h"
#import "FGMyBookingBundleForCouponFirstCellView.h"
#import "FGMyBookingBundleNoTitleForCouponCellView.h"

@interface FGManageBookingViewForUser () <FGManagingBookTitleViewDelegate, FGManageBookingPendingCellViewDelegate, FGMyBookingBundleForCouponCellViewDelegate>{
  UILabel *lb_tmp;
  BOOL bool_hasBundles;
  BOOL bool_hasInviteCoupon;
  BOOL bool_has_coupons;
  NSInteger int_InvitationCouponIndex;
}
@end

@implementation FGManageBookingViewForUser
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self internalInitalTitleSectionView];
  [self internalInitalView];
}

- (void)dealloc {
  self.marr_data       = nil;
  self.view_manageBookingTitle.delegate = nil;
  self.view_manageBookingTitle = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 初始化方法
- (void)internalInitalTitleSectionView {
  FGManagingBookTitleView *titleView = [self manageBookingTitleView];
  [titleView setupSectionStatus:SECTION_PENDING];
  [titleView setupSectionFirstButtonTitle:multiLanguage(@"PENDING") secondButtonTitle:multiLanguage(@"HISTORY") thirdButtonTitle:multiLanguage(@"BUNDLE")];
  [self.view_titleBg addSubview:titleView];
  titleView.delegate = self;
}

- (void)internalInitalView {
  [self.view_manageBookingTitle setupSectionStatus:SECTION_PENDING];
}

- (BOOL) internalInitalViewForPending {
  if (![super internalInitalViewForPending])
    return NO;
  
  __weak __typeof(self) weakSelf = self;
  self.tb_bookingForPending.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_userBookingForPending];
  }];
  
  [self.tb_bookingForPending addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_userPending];
  }];
  
  [self.tb_bookingForPending.mj_header beginRefreshing];
  return YES;
}

- (BOOL) internalInitalViewForHistory {
  if (![super internalInitalViewForHistory])
    return NO;
  
  self.marr_dataForHistory = [NSMutableArray arrayWithObjects:@{@"hidden":[NSNumber numberWithBool:YES]},@{@"hidden":[NSNumber numberWithBool:YES]},@{@"hidden":[NSNumber numberWithBool:YES]}, nil];
  
  __weak __typeof(self) weakSelf = self;
  self.tb_bookingForHistory.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_userBookingForBundle];
  }];
  
//  [self.tb_bookingForHistory addInfiniteScrollingWithActionHandler:^{
//    [weakSelf loadMore_userBundle];
//  }];
  [self.tb_bookingForHistory.mj_header beginRefreshing];
  return YES;
}

- (BOOL) internalInitalViewForAccepted {
  if (![super internalInitalViewForAccepted])
    return NO;
  
  //用户历史订单列表
  __weak __typeof(self) weakSelf = self;
  self.tb_bookingForAccepted.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_userBookingForHistory];
  }];
  
  [self.tb_bookingForAccepted addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_userHistory];
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

#pragma mark - FGMyBookingBundleForCouponCellViewDelegate 
- (void)action_didClickToUseCoupon:(id)sender {
  [self.delegate didGoToFindTrainerMapView];
}

#pragma mark - FGManageBookingPendingCellViewDelegate
- (void)didSelectedContactWithButtonView:(UIView *)_view {
  if (self.section_currentSelected == SECTION_PENDING)
    [super handleDidSelectedContactWithButtonView:_view];
  else {
      
      FGControllerManager *manager = [FGControllerManager sharedManager];
      [commond alertWithButtons:@[multiLanguage(@"One session"),multiLanguage(@"multi session")] title:multiLanguage(@"Rebook a trainer") message:multiLanguage(@"Do you want to rebook one session for this trainer or rebook a multi session?") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
          if(buttonIndex == 0)
          {
              //rebook;
              //进入教练日历界面
              if (self.delegate) {
                  NSDictionary * _dic_bookingInfo;
                  NSInteger _int_idx;
                  _dic_bookingInfo = [self getCellInfoFromView:_view atIndex:&_int_idx];
                  NSString *_str_trainerId = _dic_bookingInfo[@"user"][@"UserId"];
                  [self.delegate didRebookCourseWithTrainerId:_str_trainerId];
              }
          }//跳转到 预订单个课程
          else if(buttonIndex == 1)
          {
              NSDictionary * _dic_bookingInfo;
              NSInteger _int_idx;
              _dic_bookingInfo = [self getCellInfoFromView:_view atIndex:&_int_idx];
              
              
              NSString *_str_trainerId = [[_dic_bookingInfo objectForKey:@"user"] objectForKey:@"UserId"];
              if(_str_trainerId && ![_str_trainerId isEmptyStr])
              {
                  FGLocationFindATrainerViewController *_vc_findTrainer = [[FGLocationFindATrainerViewController alloc] initWithNibName:@"FGLocationFindATrainerViewController" bundle:nil trainingID:_str_trainerId dateStr:nil timeStr:nil isMultiClass:YES];
                  [manager pushController:_vc_findTrainer navigationController:nav_current];
                  NSLog(@"_str_trainerId = %@",_str_trainerId);
              }
          }//跳转到 预订多个课程
      }];
    
  }
}

- (void)didSelectedCancelWithButtonView:(UIView *)_view {
  if (self.section_currentSelected == SECTION_PENDING)
    [super handleDidSelectedCancelWithButtonView:_view];
  else {
    //feedback;
    if (self.delegate) {
      NSDictionary * _dic_bookingInfo;
      NSInteger _int_idx;
      _dic_bookingInfo = [self getCellInfoFromView:_view atIndex:&_int_idx];
      [self.delegate didFeedbackWithTrainerInfo:_dic_bookingInfo];
    }
  }
}

- (void)didSelectedUserIconWithButtonView:(UIView *)_view {
  if (self.section_currentSelected == SECTION_ACCEPTED){
    //feedback;
    if (self.delegate) {
      NSDictionary * _dic_bookingInfo;
      NSInteger _int_idx;
      _dic_bookingInfo = [self getCellInfoFromView:_view atIndex:&_int_idx];
      NSString *_str_trainerId = _dic_bookingInfo[@"user"][@"UserId"];
      [self.delegate didGotoTrainerInfoWithTrainerId:_str_trainerId];
    }
  }
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.section_currentSelected == SECTION_HISTORY){
    if (bool_hasBundles) {
      if (indexPath.row == 0) {
        return 144 * ratioH;
      }
      else{
        if (bool_has_coupons && bool_hasInviteCoupon && indexPath.row == 2) {
          return 180 * ratioH;
        }
        return 218 * ratioH;
      }
    } else {
      if (indexPath.row == 0) {
        return 212 * ratioH;
      }else {
        if (bool_has_coupons && bool_hasInviteCoupon && indexPath.row == 2) {
            return 180 * ratioH;
        }
        return 218 * ratioH;
      }
    }
  }
  return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"count==%d", [[self currentBookingDataSource] count]);
  return [[self currentBookingDataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  NSMutableDictionary *_mdic_bookingInfo = [NSMutableDictionary dictionaryWithDictionary: [self currentBookingDataSource][indexPath.row]];
  [_mdic_bookingInfo setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"currentIndex"];
  
  
  if (self.section_currentSelected == SECTION_PENDING) {
    if (indexPath.row == 0) {
      cell = [self myBookingPendingFirstViewCell:tableView];
    } else {
      cell = [self myBookingPendingViewCell:tableView];
    }
  }
  else if (self.section_currentSelected == SECTION_ACCEPTED) {
    if (indexPath.row == 0) {
      cell = [self myBookingHistoryFirstViewCell:tableView];
    } else {
      cell = [self myBookingHistoryViewCell:tableView];
    }
  }
  else {
    if (bool_hasBundles) {
      if (indexPath.row == 0) {
        cell = [self myBookingBundleForBunldeListCell:tableView];
      } else {
        if (bool_has_coupons && bool_hasInviteCoupon && indexPath.row == 2) {
          cell = [self myBookingBundleNoTitleForCouponCell:tableView];
        }
        else
          cell = [self myBookingBundleForCouponCell:tableView];
      }
    }
    else {
      if (bool_has_coupons && bool_hasInviteCoupon && indexPath.row == 2) {
        cell = [self myBookingBundleNoTitleForCouponCell:tableView];
      }
      else {
        cell = [self myBookingBundleForCouponFirstCell:tableView];
      }
    }
  }

  
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)] && _mdic_bookingInfo) {
    [cell updateCellViewWithInfo:_mdic_bookingInfo];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if ([commond isUser]) {
    if (self.section_currentSelected == SECTION_HISTORY) {
      return;
    }
  }
  
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - 自定义cell
- (UITableViewCell *)myBookingPendingFirstViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingPendingFirstCellView";
  FGMyBookingPendingFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingPendingFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}
- (UITableViewCell *)myBookingPendingViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingPendingCellView";
  FGMyBookingPendingCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingPendingCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)myBookingHistoryFirstViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingHistoryFirstCellView";
  FGMyBookingHistoryFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingHistoryFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)myBookingHistoryViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingHistoryCellView";
  FGMyBookingHistoryCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingHistoryCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)myBookingBundleForBunldeListCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingBundleListCellView";
  FGMyBookingBundleListCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingBundleListCellView" owner:self options:nil] lastObject];
  }
  return cell;
}

- (UITableViewCell *)myBookingBundleForCouponCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingBundleForCouponCellView";
  FGMyBookingBundleForCouponCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingBundleForCouponCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)myBookingBundleNoTitleForCouponCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingBundleNoTitleForCouponCellView";
  FGMyBookingBundleNoTitleForCouponCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingBundleNoTitleForCouponCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)myBookingBundleForCouponFirstCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGMyBookingBundleForCouponFirstCellView";
  FGMyBookingBundleForCouponFirstCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGMyBookingBundleForCouponFirstCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}


#pragma mark - 刷新
- (void)beginRefreshFromPushWithInfo:_dic_info {
  NSString *_str_sectionFromPush = _dic_info[@"section"];
  enum_section sectionFromPush;
  if ([_str_sectionFromPush isEqualToString:@"accepted"]) {
    sectionFromPush = SECTION_ACCEPTED;
  } else if ([_str_sectionFromPush isEqualToString:@"pending"]) {
    sectionFromPush = SECTION_PENDING;
  }
  [self.view_manageBookingTitle setupSectionStatus:sectionFromPush];
  [self setupManageBookingStatus:sectionFromPush];
}

- (void)refreshUI {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderList)];
  [self refreshUIWithInfo:_dic_info];
    
}

- (void)refreshUIForLoadMore {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_OrderList)];
  [self refreshLoadMoreUIWithInfo:_dic_info];
}

#pragma mark - 刷新pending界面
- (void)bindDataToUIForPending {
  if (self.section_currentSelected != SECTION_PENDING)
    return;
  
  [self refreshUI];
    
    [NetworkEventTrack track:KEY_TRACK_EVENTID_PTSESSION attrs:nil]; //追踪 ptSession
}

- (void)loadMoreBookingForPending {
  [self refreshUIForLoadMore];
}

#pragma mark - 刷新history界面
- (void)bindDataToUIForHistory {
  if (self.section_currentSelected != SECTION_ACCEPTED)
    return;
  
  [self refreshUI];
    
    [NetworkEventTrack track:KEY_TRACK_EVENTID_PTSESSION attrs:nil]; //追踪 ptSession
}

- (void)loadMoreBookingForHistory {
  [self refreshUIForLoadMore];
}

#pragma mark - 刷新bundle界面
- (void)bindDataToUIForBundleWithIndex:(NSInteger)_int_idx {
  if (self.section_currentSelected != SECTION_HISTORY)
    return;
  
  if (_int_idx == 0) {
    NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_BundleList)];
    NSLog(@"bundle list=%@", _dic_info);
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.marr_dataForHistory[0]];
    NSArray *_arr_boundles = _dic_info[@"Bundles"];
    if (_arr_boundles.count <= 0) {
      bool_hasBundles = NO;
    }
    else {
      bool_hasBundles = YES;
      
      [_mdic setObjectSafty:_dic_info[@"BundleLessons"] forKey:@"BundleLessons"];
      [_mdic setObjectSafty:_dic_info[@"Bundles"] forKey:@"Bundles"];
      
      [_mdic setObject:[NSNumber numberWithBool:NO] forKey:@"hidden"];
      [self.marr_dataForHistory replaceObjectAtIndex:0 withObject:_mdic];
      [FGUtils reloadCellWithTableView:[self currentTableView] atIndex:0];
    }
    
    [self runRequest_userBookingForCoupons];
  } else {
    NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_CouponList)];
    NSLog(@"coupon list=%@", _dic_info);
    
    if (bool_hasBundles) {
      [self updateCouponsWithInfo:_dic_info atIndex:1];
    }
    else {
      [self updateCouponsWithInfo:_dic_info atIndex:0];
    }
  }

  if ([[self currentTableView].mj_header isRefreshing])
    [[self currentTableView].mj_header endRefreshing];
}

- (void)loadMoreBookingForBundle {
//  [self refreshUIForLoadMore];
}

#pragma mark - 请求pending数据
- (void)runRequest_userBookingForPending {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"userBookingForPending" forKey:@"userBookingForPending"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_orderList:1 isFirstPage:YES count:10 userinfo:_dic_info];
}

- (void)loadMore_userPending {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"userBookingForPending" forKey:@"userBookingForPending"];
  [_dic_info setObject:@"userBookingForPending_loadMore" forKey:@"userBookingForPending_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  [[NetworkManager_Location sharedManager] postRequest_Locations_orderList:1 isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - 请求history数据
- (void)runRequest_userBookingForHistory {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"userBookingForHistory" forKey:@"userBookingForHistory"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_orderList:2 isFirstPage:YES count:10 userinfo:_dic_info];

}

- (void)loadMore_userHistory {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"userBookingForHistory" forKey:@"userBookingForHistory"];
  [_dic_info setObject:@"userBookingForHistory_loadMore" forKey:@"userBookingForHistory_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_orderList:2 isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - 请求Bundle数据
- (void)runRequest_userBookingForBundle {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  //请求bundle数据
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Location sharedManager] postRequest_Locations_bundleList:_dic_info];
  
}

- (void)runRequest_userBookingForCoupons {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];

    //请求coupon数据
    _dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
    [[NetworkManager_Location sharedManager] postRequest_Locations_couponList:_dic_info];
}

- (void)loadMore_userBundle {
}

#pragma mark - 其它方法
- (void)action_handleSection:(enum_section)section {
  [super action_handleSection:section];
}

- (void) updateCouponsWithInfo:(NSDictionary *)_dic_info atIndex:(NSInteger)_int_dix {
  NSArray *_arr_coupons = _dic_info[@"Coupons"];
  bool_has_coupons = NO;
  if (!ISNULLObj(_arr_coupons) && _arr_coupons.count > 0) {
    bool_has_coupons = YES;
    __block NSInteger totalCouponValue = 0;
    [_arr_coupons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic = (NSDictionary *)obj;
      NSInteger _int_value = [_dic[@"CouponValue"] integerValue];
      totalCouponValue += _int_value;
    }];
    
    NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.marr_dataForHistory[_int_dix]];
    
    [_mdic setObjectSafty:[NSNumber numberWithInteger:totalCouponValue] forKey:@"couponValue"];
    [_mdic setObjectSafty:multiLanguage(@"You can use this to book a trainer.") forKey:@"content"];
    [_mdic setObject:[NSNumber numberWithBool:NO] forKey:@"hidden"];
    [self.marr_dataForHistory replaceObjectAtIndex:_int_dix withObject:_mdic];
    [FGUtils reloadCellWithTableView:[self currentTableView] atIndex:_int_dix];
  }
  
  bool_hasInviteCoupon = NO;
  NSDictionary *_dic_inviteCoupon = _dic_info[@"InviteCoupon"];
  if (!ISNULLObj(_dic_inviteCoupon)) {
    bool_hasInviteCoupon = YES;
  }
  
  if (bool_hasInviteCoupon == NO &&
      bool_has_coupons == NO) {
    if (_int_dix == 0) {
      //没有数据
      [[self currentTableView] showNoResultWithText:multiLanguage(@"No results")];
      return;
    }
  }
  
  if (bool_hasInviteCoupon == NO)
    return;
  
  NSInteger _int_newIndex;
  _int_newIndex = bool_has_coupons ? 2 : 1;
  
  if (bool_hasBundles == NO) {
    _int_newIndex = 0;
  }
  
  int_InvitationCouponIndex = _int_newIndex;
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.marr_dataForHistory[_int_newIndex]];
  NSInteger _int_value = [_dic_inviteCoupon[@"CouponValue"] integerValue];
  
  [_mdic setObjectSafty:[NSNumber numberWithInteger:_int_value] forKey:@"couponValue"];
  [_mdic setObjectSafty:multiLanguage(@"Invitation code discount") forKey:@"content"];
  [_mdic setObject:[NSNumber numberWithInteger:int_InvitationCouponIndex] forKey:@"InvitationCouponIndex"];
  [_mdic setObject:@YES forKey:@"hasInvitationCoupon"];
  [_mdic setObject:[NSNumber numberWithBool:NO] forKey:@"hidden"];
  [self.marr_dataForHistory replaceObjectAtIndex:_int_newIndex withObject:_mdic];
  [FGUtils reloadCellWithTableView:[self currentTableView] atIndex:_int_newIndex];
}
@end
