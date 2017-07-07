//
//  FGManageBookingView.h
//  CSP
//
//  Created by JasonLu on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGManagingBookTitleView.h"
#import "FGBookingCancelCoursePopView.h"
@interface FGManageBookingView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tb_bookingForPending;
@property (strong, nonatomic) UITableView *tb_bookingForAccepted;
@property (strong, nonatomic) UITableView *tb_bookingForHistory;

@property (nonatomic, strong) NSMutableArray *marr_dataForPending;
@property (nonatomic, strong) NSMutableArray *marr_dataForAccepted;
@property (nonatomic, strong) NSMutableArray *marr_dataForHistory;
@property (nonatomic, strong) NSMutableArray *marr_data;

@property (nonatomic, strong) FGBookingCancelCoursePopView * view_bookingCancelPopup;
@property (nonatomic, strong) FGManagingBookTitleView * view_manageBookingTitle;
@property (nonatomic, assign) enum_section section_currentSelected;

@property (nonatomic, copy) NSString *str_orderId;
@property (nonatomic, copy) NSString *str_id;
@property (nonatomic, assign) NSInteger int_cursor;
@property (nonatomic, assign) NSInteger int_cancelOrderIndex;

#pragma mark - 初始化方法
- (BOOL) internalInitalViewForPending;
- (BOOL) internalInitalViewForAccepted;
- (BOOL) internalInitalViewForHistory;
#pragma mark - 数据源
- (UITableView *)currentTableView;
- (NSMutableArray *)currentBookingDataSource;
- (void)updateCurrentBookingDataSourceWithArr:(NSMutableArray *)_marr;
- (void)updateVisiableBookingDetailWithSection:(enum_section)_status;
#pragma mark - 请求pending数据
- (void)runRequest_trainerBookingForPending;
- (void)loadMore_trainerPending;
#pragma mark - 请求accpeted数据
- (void)runRequest_trainerBookingForAccepted;
- (void)loadMore_trainerAccepted;
#pragma mark - 请求history数据
- (void)runRequest_trainerBookingForHistory;
- (void)loadMore_trainerHistory;
#pragma mark - 刷新pending界面
- (void)bindDataToUIForPending;
- (void)loadMoreBookingForPending;
#pragma mark - 刷新accpeted界面
- (void)bindDataToUIForAccepted;
- (void)loadMoreBookingForAccepted;
#pragma mark - 刷新history界面
- (void)bindDataToUIForHistory;
- (void)loadMoreBookingForHistory;
- (void)refreshUIWithInfo:(NSDictionary *)_dic_info;
- (void)refreshLoadMoreUIWithInfo:(NSDictionary *)_dic_info;
- (void)beginRefreshFromPushWithInfo:_dic_info;
#pragma mark - 刷新界面从取消订单请求
- (void)loadUIFromCancelOrder;
#pragma mark - 删除取消界面
- (void)clearBookingCancelCourseView;
#pragma mark - 取消订单请求
- (void)runRequest_cancelOrderWithOrderId:(NSString *)_str_orderId;
#pragma mark - FGManageBookingPendingCellViewDelegate
- (void)handleDidSelectedAcceptedWithButtonView:(UIView *)_view;
- (void)handleDidSelectedContactWithButtonView:(UIView *)_view;
- (void)handleDidSelectedCancelWithButtonView:(UIView *)_view;
- (void)handleDidSelectedUserIconWithButtonView:(UIView *)_view;

#pragma mark - 其它方法
- (FGManagingBookTitleView *)manageBookingTitleView;
- (void)setupManageBookingStatus:(enum_section)status;
- (BOOL)isErrorFromResponseInfo:(NSDictionary *)_dic_info;
- (NSMutableArray *)dataInfoFromReuqestWithInfo:(NSDictionary *)_dic_info;
- (void)hideFooterLoadingIfNeeded;
- (void)refreshTableViewFooterWithActivityStatus:(BOOL)_bool_activity;
- (void)action_handleSection:(enum_section)section;
- (NSDictionary *)getCellInfoFromView:(UIView *)_view atIndex:(NSInteger *)_int_idx;

@end
