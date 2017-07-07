//
//  FGWorkingLogView.m
//  CSP
//
//  Created by JasonLu on 16/12/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGWorkingLogView.h"
//#import "CYLineLayout.h"
//#import "CYPhotoCell.h"
#import "FGProfileInfoCellView.h"
#import "FGWorkoutLogChartTableViewCell.h"
#import "FGWorkoutLogDetailCellView.h"
#import "FGWorkoutLogTitleCellView.h"
#import "FGWorkoutLogTitleSecondCellView.h"

#define TAG_FGWorkoutLogSectionView 1000

@interface FGWorkingLogView () <FGWorkingLogSectionViewDelegate, FGWorkoutLogChartTableViewCellDelegate> {
  enum_ChartType charType_currentSelected;
  //  NSInteger int_cursor;
  //  NSInteger int_totalComment;
}
@end

@implementation FGWorkingLogView
@synthesize view_section;
@synthesize marr_data_oneWorkoutLog;
@synthesize marr_data_workoutLogsTotal;
@synthesize dic_oneWorkoutLog;
@synthesize tb_workoutWeekDetail;
@synthesize tb_workoutMonthDetail;
@synthesize tb_workoutTotalDetail;
@synthesize int_cursor;
#pragma mark - 生命周期
-(void)awakeFromNib
{
  self.marr_data_workoutLogsTotal = [NSMutableArray array];
  self.marr_data_oneWorkoutLog    = [NSMutableArray array];
  
  _marr_data_originWorkoutLogsForWeek  = [NSMutableArray array];
  _marr_data_originWorkoutLogsForMonth = [NSMutableArray array];
  
  charType_currentSelected = Chart_week;
  
  [super awakeFromNib];
  [self internalInitalSectionView];
  [self internalInitalWorkoutWeekDetailView];
}

-(void)dealloc
{
  self.view_section = nil;
  self.dic_oneWorkoutLog = nil;
  
  self.marr_data_workoutLogsTotal  = nil;
  self.marr_data_oneWorkoutLog    = nil;
  
  _marr_data_originWorkoutLogsForWeek  = nil;
  _marr_data_originWorkoutLogsForMonth = nil;  
  
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 初始化方法
-(void)internalInitalSectionView
{
  if(view_section)
    return;
  view_section = (FGWorkingLogSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGWorkingLogSectionView" owner:nil options:nil] objectAtIndex:0];
  self.view_section.frame = CGRectMake(0, 0, view_section.bounds.size.width, view_section.bounds.size.height);
  [self.view_section buttonAction_featured:nil];
  [self addSubview:view_section];
  view_section.delegate_workinglog = self;
  [commond useDefaultRatioToScaleView:view_section];
}

- (void)internalInitalWorkoutWeekDetailView {
  self.tb_workoutWeekDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
  self.tb_workoutWeekDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tb_workoutWeekDetail.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tb_workoutWeekDetail.delegate = self;
  self.tb_workoutWeekDetail.dataSource = self;
  [commond useDefaultRatioToScaleView:self.tb_workoutWeekDetail];
  [self addSubview:self.tb_workoutWeekDetail];
  
  NSMutableArray *_marr_details = [NSMutableArray array];
  NSMutableArray *_marr_list = [NSMutableArray array];
  [_marr_list addObject:@{@"details":_marr_details}];
  
  self.marr_data_oneWorkoutLog = [NSMutableArray arrayWithArray:@[@"",@""]];
  
  //  int_cursor = 0;
  __weak __typeof(self) weakSelf = self;
  self.tb_workoutWeekDetail.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_refreshData];
  }];
}

- (void)internalInitalWorkoutMonthDetailView {
  self.marr_data_oneWorkoutLog = [NSMutableArray arrayWithArray:@[@"",@""]];
  
  self.tb_workoutMonthDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
  self.tb_workoutMonthDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tb_workoutMonthDetail.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tb_workoutMonthDetail.delegate = self;
  self.tb_workoutMonthDetail.dataSource = self;
  [commond useDefaultRatioToScaleView:self.tb_workoutMonthDetail];
  [self addSubview:self.tb_workoutMonthDetail];
  
  NSMutableArray *_marr_details = [NSMutableArray array];
  NSMutableArray *_marr_list = [NSMutableArray array];
  [_marr_list addObject:@{@"details":_marr_details}];
  
  //  int_cursor = 0;
  __weak __typeof(self) weakSelf = self;
  self.tb_workoutMonthDetail.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_refreshData];
  }];
}

- (void)internalInitalWorkoutTotalDetailView {
  self.marr_data_oneWorkoutLog = [NSMutableArray arrayWithArray:@[@""]];
  
  self.tb_workoutTotalDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, 320, 460)];
  self.tb_workoutTotalDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tb_workoutTotalDetail.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.tb_workoutTotalDetail.delegate = self;
  self.tb_workoutTotalDetail.dataSource = self;
  [commond useDefaultRatioToScaleView:self.tb_workoutTotalDetail];
  [self addSubview:self.tb_workoutTotalDetail];
  
  NSMutableArray *_marr_details = [NSMutableArray array];
  NSMutableArray *_marr_list = [NSMutableArray array];
  [_marr_list addObject:@{@"details":_marr_details}];
  
  //  int_cursor = 0;
  __weak __typeof(self) weakSelf = self;
  self.tb_workoutTotalDetail.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_refreshData];
  }];
  
  [self.tb_workoutTotalDetail addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_workoutForTotal];
  }];
}
#pragma mark - 数据源
- (NSMutableArray *)currentOriginData {
  if (charType_currentSelected == Chart_week) {
    return self.marr_data_originWorkoutLogsForWeek;
  } else if (charType_currentSelected == Chart_month) {
    return self.marr_data_originWorkoutLogsForMonth;
  }
  return nil;
}

- (void)updateCurrentOriginDataWithArr:(NSArray *)_arr {
  if (charType_currentSelected == Chart_week) {
    _marr_data_originWorkoutLogsForWeek = [NSMutableArray arrayWithArray:[_arr mutableCopy]];
  } else if (charType_currentSelected == Chart_month) {
    _marr_data_originWorkoutLogsForMonth = [NSMutableArray arrayWithArray:[_arr mutableCopy]];
  }
}

#pragma mark - workout log界面切换方法
- (UITableView *)currentTableView {
  if (charType_currentSelected == Chart_week) {
    return self.tb_workoutWeekDetail;
  } else if (charType_currentSelected == Chart_month) {
    return self.tb_workoutMonthDetail;
  } else {
    return self.tb_workoutTotalDetail;
  }
  return nil;
}

- (void)updateVisiableWorkoutDetail {
  if (charType_currentSelected == Chart_week) {
    [self internalInitalWorkoutWeekDetailView];
    if(self.tb_workoutMonthDetail) {
      [self.tb_workoutMonthDetail setRefreshFooter:nil];
      self.tb_workoutMonthDetail.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_workoutMonthDetail);
      self.tb_workoutMonthDetail = nil;
    }
    if(self.tb_workoutTotalDetail) {
      [self.tb_workoutTotalDetail setRefreshFooter:nil];
      self.tb_workoutTotalDetail.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_workoutTotalDetail);
      self.tb_workoutTotalDetail = nil;
    }
  } else if (charType_currentSelected == Chart_month){
    [self internalInitalWorkoutMonthDetailView];
    if(self.tb_workoutWeekDetail) {
      [self.tb_workoutWeekDetail setRefreshFooter:nil];
      self.tb_workoutWeekDetail.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_workoutWeekDetail);
      self.tb_workoutWeekDetail = nil;
    }
    
    if(self.tb_workoutTotalDetail) {
      [self.tb_workoutTotalDetail setRefreshFooter:nil];
      self.tb_workoutTotalDetail.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_workoutTotalDetail);
      self.tb_workoutTotalDetail = nil;
    }
  } else {
    [self internalInitalWorkoutTotalDetailView];
    if(self.tb_workoutWeekDetail) {
      [self.tb_workoutWeekDetail setRefreshFooter:nil];
      self.tb_workoutWeekDetail.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_workoutWeekDetail);
      self.tb_workoutWeekDetail = nil;
    }
    
    if(self.tb_workoutMonthDetail) {
      [self.tb_workoutMonthDetail setRefreshFooter:nil];
      self.tb_workoutMonthDetail.mj_header = nil;
      SAFE_RemoveSupreView(self.tb_workoutMonthDetail);
      self.tb_workoutMonthDetail = nil;
    }
  }
}

#pragma mark - FGWorkingLogSectionViewDelegate
-(void)didSelectedSection:(TraingHomePage_SectionType )_currentSectionType{
  NSLog(@"_currentSectionType==%d", _currentSectionType);
  NSLog(@"getWorkoutLogChartViewCell==%@", [self getWorkoutLogChartViewCell]);
  
  [[self currentTableView] resetNoResultView];
  charType_currentSelected = (enum_ChartType)_currentSectionType;
  [self updateVisiableWorkoutDetail];
  [self beginToRefresh];
}

#pragma mark - FGWorkingLogSectionViewDelegate
-(void)didSelectedChartAtIndex:(NSInteger)index {
  self.bool_reloadSections = YES;
  [self bindDataToUIForWeekWithArr:self.marr_data_workoutLogsTotal AtIndex:index];
}

- (void)didLoadMoreData {
  if (charType_currentSelected == Chart_week) {
    [self runRequest_workoutForWeekWithFirstPage:NO];
  } else if (charType_currentSelected == Chart_month) {
    [self runRequest_workoutForMonthWithFirstPage:NO];
  }
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (charType_currentSelected == Chart_total) {
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        return 74 * ratioH;
      }
    }
    return 50 * ratioH;
  }
  
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return 70 * ratioH;
    }
  }
  else if (indexPath.section == 1) {
    if (indexPath.row == 0) {
      return 204 * ratioH;
    }
  }
  return 50 * ratioH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  if (charType_currentSelected == Chart_total) {
    if (section == 0)
      return 0;
    return 40 * ratioH;
  }
  
  if (section == 0 ||
      section == 1)
    return 0;
  
  return 40 * ratioH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
  if (charType_currentSelected == Chart_total) {
    if (section == 0)
      return nil;
    
    return [self getHeaderFooterViewWithTableView:tableView withSection:section];
  }
  
  if(section == 0 ||
     section == 1)
    return nil;
  
  return [self getHeaderFooterViewWithTableView:tableView withSection:section];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.marr_data_oneWorkoutLog.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (charType_currentSelected == Chart_total) {
    if (section == 0) {
      return 1;
    }
  } else {
    if (section == 0 ||
        section == 1) {
      return 1;
    }
  }
  
  if (self.marr_data_oneWorkoutLog.count <= 0 ||
      ISNULLObj(self.marr_data_oneWorkoutLog[section]) ||
      ISNULLObj(self.marr_data_oneWorkoutLog[section][@"details"]))
    return 0;
  
  return [self.marr_data_oneWorkoutLog[section][@"details"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  
  if (charType_currentSelected == Chart_total) {
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        cell = [self workourLogTitleSecondViewCell:tableView];
      }
    }
    else {
      cell = [self workourLogDetailViewCell:tableView];
    }
  } else {
    if (indexPath.section == 0) {
      if (indexPath.row == 0) {
        cell = [self workourLogTitleViewCell:tableView];
      }
    }
    else if (indexPath.section == 1) {
      if (indexPath.row == 0) {
        cell = [self workoutLogChartInfoViewCell:tableView];
      }
    }
    else {
      cell = [self workourLogDetailViewCell:tableView];
    }
  }
  
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    NSDictionary *_dic_tmp = nil;
    if (charType_currentSelected == Chart_total) {
      if (indexPath.section == 0) {
        //section:0
        _dic_tmp = self.marr_data_oneWorkoutLog[indexPath.section];
      } else {
        _dic_tmp = self.marr_data_oneWorkoutLog[indexPath.section];
        _dic_tmp = _dic_tmp[@"details"][indexPath.row];
      }
      if ([_dic_tmp isKindOfClass:[NSDictionary class]])
        [cell updateCellViewWithInfo:_dic_tmp];
    }
    else {
      if (indexPath.section > 1) {
        _dic_tmp = self.marr_data_oneWorkoutLog[indexPath.section];
        _dic_tmp = _dic_tmp[@"details"][indexPath.row];
      } else {
        //section:0, 1
        _dic_tmp = self.marr_data_oneWorkoutLog[indexPath.section];
        ;
      }
      if ([_dic_tmp isKindOfClass:[NSDictionary class]])
        [cell updateCellViewWithInfo:_dic_tmp];
    }
    
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

#pragma mark - 自定义cell
- (UITableViewCell *)workoutLogChartInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGWorkoutLogChartTableViewCell";
  FGWorkoutLogChartTableViewCell *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGWorkoutLogChartTableViewCell" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}


- (UITableViewCell *)workourLogTitleViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGWorkoutLogTitleCellView";
  FGWorkoutLogTitleCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGWorkoutLogTitleCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (UITableViewCell *)workourLogTitleSecondViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGWorkoutLogTitleSecondCellView";
  FGWorkoutLogTitleSecondCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGWorkoutLogTitleSecondCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}



- (UITableViewCell *)workourLogDetailViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGWorkoutLogDetailCellView";
  FGWorkoutLogDetailCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGWorkoutLogDetailCellView" owner:self options:nil] lastObject];
  }
  return cell;
}


#pragma mark - UITableView相关方法
- (FGWorkoutLogSectionView *)getWorkoutLogSectionView {
  FGWorkoutLogSectionView *titleView = (FGWorkoutLogSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGWorkoutLogSectionView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  return titleView;
}

- (FGWorkoutLogChartTableViewCell *)getWorkoutLogChartViewCell {
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:0 inSection:1];
  return (FGWorkoutLogChartTableViewCell *)[[self currentTableView] cellForRowAtIndexPath:tmpIndexPath];
}

- (UITableViewHeaderFooterView *)getHeaderFooterViewWithTableView:(UITableView *)tableView withSection:(NSInteger)section {
  static NSString *headerViewId = @"headerViewId";
  UITableViewHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
  if (!headerView) {
    headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:headerViewId];
    FGWorkoutLogSectionView *_view_section = [self getWorkoutLogSectionView];
    [headerView addSubview:_view_section];
    _view_section.tag = TAG_FGWorkoutLogSectionView;
  }
  
  NSDictionary *_dic_section = self.marr_data_oneWorkoutLog[section][@"section"];
  FGWorkoutLogSectionView *_view_section = [headerView viewWithTag:TAG_FGWorkoutLogSectionView];
  [_view_section updateSectionViewWithInfo:_dic_section];
  return headerView;
}

#pragma mark - 点击柱状条加载下面表格数据
- (void)bindDataToUIForWeekWithArr:(NSArray *)_arr_reports AtIndex:(NSInteger)index {
  // 获取对应chart信息的表格数据
  NSMutableArray *_marr_tempOneWorkoutLog = [self getDataSourceWithWorkoutReports:_arr_reports atIndex:index];
  [self updateWorkoutLogDataSrouceWithArr:_marr_tempOneWorkoutLog];
//  NSLog(@"marr_data_oneWorkoutLog=%@",self.marr_data_oneWorkoutLog);
  //更新对应chart日期的信息
  [self refreshWorkoutLogsDetailInfo];
  //更新chart数据源
  //更新chart信息
  [self refreshWorkoutLogChartInfo];
  //更新顶部汇总信息
  [self refreshWorkoutLogTotalSummyInfo];
  
}

- (void)bindDataToUIWithIndex:(NSInteger)_int_idx {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_WorkoutReport)];
  NSLog(@"_dic_info==%@",_dic_info);
  
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    [self endHeaderRefreshing];
    [self refreshTableView];
    return;
  }
  
  NSString *_str_cursor = [NSString stringWithFormat:@"%@", _dic_info[@"Cursor"]];
  FGWorkoutLogChartTableViewCell *_vc = [self getWorkoutLogChartViewCell];
  _vc.str_cursor = _str_cursor;
  
  NSArray *_arr_workoutReports = _dic_info[@"WorkoutReport"];
  if (_arr_workoutReports.count <= 0) {
    [self endHeaderRefreshing];
    [self refreshTableView];
    [[self currentTableView] showNoResultWithText:multiLanguage(@"No workout logs yet!")];
    return;
  }
  
  [self updateCurrentOriginDataWithArr:_arr_workoutReports];
  [self bindDataToUIForWeekWithArr:[self reverseDataSource] AtIndex:[self reverseIndexWithIndex:_int_idx]];
  [self refreshTableView];
  [self endHeaderRefreshing];
}

#pragma mark - 加载workout log周数据
- (void)bindDataToUIForWeekAtIndex:(NSInteger)index {
  if (charType_currentSelected != Chart_week)
    return;
  
  [self bindDataToUIWithIndex:index];
}

- (void)loadMoreWorkoutLogsForWeek {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_WorkoutReport)];
  NSLog(@"_dic_info==%@",_dic_info);
  
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
    [vc_workoutLogChart hideLoadingIfNeeded:YES];
    return;
  }
  
  NSString *_str_cursor = [NSString stringWithFormat:@"%@", _dic_info[@"Cursor"]];
  FGWorkoutLogChartTableViewCell *_vc = [self getWorkoutLogChartViewCell];
  _vc.str_cursor = _str_cursor;
  
  NSArray *_arr_workoutReports = _dic_info[@"WorkoutReport"];
  if (_arr_workoutReports.count <= 0) {
    FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
    [vc_workoutLogChart hideLoadingIfNeeded:YES];
    return;
  }
  
  
  NSMutableArray *_marr_newWorkoutReports = [NSMutableArray array];
  NSArray *_arr_oldWorkoutLogs = [self currentOriginData];//self.marr_data_workoutLogsTotal;
  [_marr_newWorkoutReports addObjectsFromArray:_arr_oldWorkoutLogs];
  [_marr_newWorkoutReports addObjectsFromArray:_arr_workoutReports];
  
  
  [self updateCurrentOriginDataWithArr:_marr_newWorkoutReports];
//  [self bindDataToUIForWeekWithArr:[self reverseDataSource] AtIndex:[self reverseIndexWithIndex:_arr_oldWorkoutLogs.count-1]];
  
  // 获取对应chart信息的表格数据
  NSMutableArray *_marr_tempOneWorkoutLog = [self getDataSourceWithWorkoutReports:[self reverseDataSource] atIndex:[self reverseIndexWithIndex:_arr_oldWorkoutLogs.count-1]];
  [self updateWorkoutLogDataSrouceWithArr:_marr_tempOneWorkoutLog];
//  //更新chart信息
//  [self refreshWorkoutLogChartInfo];
  FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
  [vc_workoutLogChart updateCellViewWithInfo:self.marr_data_oneWorkoutLog[1] isMove:NO];
//  [[vc_workoutLogChart getCurrentCollectionView] reloadData];
//  NSMutableArray *_marr_tempOneWorkoutLog = [self getDataSourceWithWorkoutReports:_marr_newWorkoutReports atIndex:0];
//  self.marr_data_oneWorkoutLog = _marr_tempOneWorkoutLog;
//  [[self currentTableView] reloadData];
  
//  FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
  [vc_workoutLogChart hideLoadingIfNeeded:YES];
}

#pragma mark - 加载workout log月数据
- (void)bindDataToUIForMonthAtIndex:(NSInteger)index {
  if (charType_currentSelected != Chart_month)
    return;
  
  [self bindDataToUIWithIndex:index];
}

- (void)loadMoreWorkoutLogsForMonth {
  FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
  [vc_workoutLogChart bindDataToUIForMonth_loadMore];
}

#pragma mark - 加载全部workout log数据
- (void)bindDataToUIForTotal {
  if (charType_currentSelected != Chart_total)
    return;
  
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_WorkoutDailyReport)];
  NSLog(@"_dic_info==%@",_dic_info);
  ;
  
  NSArray *_arr_workoutReport = _dic_info[@"DailyReport"];
  [self.marr_data_workoutLogsTotal removeAllObjects];
  
  if (_arr_workoutReport.count <= 0) {
    [self endHeaderRefreshing];
    [self refreshTableView];
    [self hideFooterLoadingIfNeeded];
    [[self currentTableView] showNoResultWithText:multiLanguage(@"No workout logs yet!")];
    return;
  }
  
  NSMutableArray *_marr_tempOneWorkoutLog = [NSMutableArray array];
  
  self.marr_data_workoutLogsTotal = [NSMutableArray arrayWithArray:_arr_workoutReport];
  self.dic_oneWorkoutLog = @{
                             @"TimeCount":[NSString stringWithFormat:@"%@",_dic_info[@"TotalMinute"]],
                             @"WorkoutCount":[NSString stringWithFormat:@"%@",_dic_info[@"TotalCount"]],
                             @"CaloriaCount":[NSString stringWithFormat:@"%@",_dic_info[@"TotalCalorie"]]};
  
  NSString *_str_timeCount          = self.dic_oneWorkoutLog[@"TimeCount"];
  NSString *_str_workoutCount       = self.dic_oneWorkoutLog[@"WorkoutCount"];
  NSString *_str_caloriaCount       = self.dic_oneWorkoutLog[@"CaloriaCount"];
  
  ;
  [_marr_tempOneWorkoutLog addObject:@{
                                       @"workout":_str_workoutCount,
                                       @"minute":_str_timeCount,
                                       @"caloria":_str_caloriaCount}];
  
  NSArray *_arr_dailyReports = _arr_workoutReport;//self.dic_oneWorkoutLog[@"DailyReport"];
  NSMutableArray *_marr_list = [NSMutableArray array];
  for (NSDictionary *_dic_tmp_daily in _arr_dailyReports) {
    
    NSString *_str_date = [NSString stringWithFormat:@"%@", _dic_tmp_daily[@"Date"]];
    NSString *_str_duration = [NSString stringWithFormat:@"%@", _dic_tmp_daily[@"Duration"]];
    NSString *_str_total = [NSString stringWithFormat:@"%@", _dic_tmp_daily[@"Total"]];
    
    NSArray *_arr_workoutRecords = _dic_tmp_daily[@"WorkoutRecords"];
    NSMutableArray *_marr_details = [NSMutableArray array];
    int i = 0;
    for (NSDictionary *_dic_tmp_daily_workoutRecord in _arr_workoutRecords) {
      NSString *_str_workoutName = [NSString stringWithFormat:@"%@", _dic_tmp_daily_workoutRecord[@"WorkoutName"]];
      NSString *_str_duration = [NSString stringWithFormat:@"%@", _dic_tmp_daily_workoutRecord[@"Duration"]];
      NSString *_str_calorias = [NSString stringWithFormat:@"%@", _dic_tmp_daily_workoutRecord[@"Consume"]];
      
      NSDictionary *_dic2 = @{@"title":_str_workoutName,
                              @"time":_str_duration,
                              @"caloria":[NSString stringWithFormat:@"%@ %@", _str_calorias, multiLanguage(@"Calorias")],
                              @"hiddenSeparator":[NSNumber numberWithBool:i==_arr_workoutRecords.count-1]};
      [_marr_details addObject:_dic2];
      i++;
    }
    
    NSDictionary *_dic = @{@"date":_str_date, @"time":_str_duration, @"caloria":_str_total};
    [_marr_list addObject:@{@"section":_dic,@"details":_marr_details}];
  }
  [_marr_tempOneWorkoutLog addObjectsFromArray:_marr_list];
  
  if (self.bool_reloadSections) {
    NSInteger int_sections = [[self currentTableView] numberOfSections];
    NSInteger int_workoutlogs = _marr_tempOneWorkoutLog.count;
    if (int_workoutlogs > int_sections) {
      //添加sections
      NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(int_sections, int_workoutlogs-int_sections)];
      NSMutableArray *_marr_tmp = [NSMutableArray array];
      for (int i = 0; i < indexSet.count; i++) {
        NSDictionary *_dic = @{@"date":@"-", @"time":@"-", @"caloria":@"-"};
        [_marr_tmp addObject:@{@"section":_dic,@"details":@[]}];
      }
      [self.marr_data_oneWorkoutLog insertObjects:_marr_tmp atIndexes:indexSet];
      [[self currentTableView] insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
      
    } else if (int_workoutlogs < int_sections) {
      //删除sections
      NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(int_workoutlogs, int_sections-int_workoutlogs)];
      
      [self.marr_data_oneWorkoutLog removeObjectsAtIndexes:indexSet];
      [[self currentTableView] deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }
    
    self.marr_data_oneWorkoutLog = _marr_tempOneWorkoutLog;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, marr_data_oneWorkoutLog.count-2)];
    [[self currentTableView] reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    
    //刷新第一个cell
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [[self currentTableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
  } else {
    self.marr_data_oneWorkoutLog = _marr_tempOneWorkoutLog;
    [self refreshTableView];
  }
  
  [self endHeaderRefreshing];
}

- (void)loadMoreWorkoutLogsForTotal {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_WorkoutDailyReport)];
  
  //if ([self isErrorFromResponseInfo:_dic_info])
  //  return;
  
  NSArray *_arr_moreWorkoutReport = [NSMutableArray arrayWithArray:self.marr_data_workoutLogsTotal];//_dic_info[@"DailyReport"];
  
  if (_arr_moreWorkoutReport && _arr_moreWorkoutReport.count > 0) {
    [self.marr_data_workoutLogsTotal addObjectsFromArray:_arr_moreWorkoutReport];
  }
  
  [[self currentTableView] reloadData];
  [[self currentTableView].refreshFooter endRefreshing];
  
  int cursor                    = [[_dic_info objectForKey:@"Cursor"] intValue];
  [self refreshTableViewFooterWithActivityStatus:cursor==-1?NO:YES];
}

#pragma mark - 请求刷新
- (void)runRequest_refreshData {
  if (charType_currentSelected != Chart_total) {
    FGWorkoutLogChartTableViewCell *_vc = [self getWorkoutLogChartViewCell];
    _vc.str_cursor = @"0";
  }
  
  self.bool_reloadSections = NO;
  if (charType_currentSelected == Chart_week) {
    [self runRequest_workoutForWeekWithFirstPage:YES];
  } else if (charType_currentSelected == Chart_month) {
    [self runRequest_workoutForMonthWithFirstPage:YES];
  } else {
    [self runRequest_workoutForTotal];
  }
}

#pragma mark - 请求workoutlog周数据，是否从第一页开始
- (void)runRequest_workoutForWeekWithFirstPage:(BOOL)_bool_isFirstPage {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:_bool_isFirstPage?2:3];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [_dic_info setObject:@"week" forKey:@"reportType"];
  
  if (!_bool_isFirstPage) {
    [_dic_info setObject:@"loadMore" forKey:@"loadMore"];
  }
  BOOL _bool_isLastPage = [[NetworkManager_Profile sharedManager] postRequest_Profile_WorkoutReport:1 isFirstPage:_bool_isFirstPage count:10 userinfo:_dic_info];
  if (_bool_isLastPage) {
    FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
    [vc_workoutLogChart hideLoadingIfNeeded:_bool_isLastPage];
  }
}

#pragma mark - 请求workoutlog月数据，是否从第一页开始
- (void)runRequest_workoutForMonthWithFirstPage:(BOOL)_bool_isFirstPage {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:_bool_isFirstPage?2:3];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [_dic_info setObject:@"month" forKey:@"reportType"];
  
  if (!_bool_isFirstPage) {
    [_dic_info setObject:@"loadMore" forKey:@"loadMore"];
  }
  
  BOOL _bool_isLastPage = [[NetworkManager_Profile sharedManager] postRequest_Profile_WorkoutReport:2 isFirstPage:_bool_isFirstPage count:10 userinfo:_dic_info];
  if (_bool_isLastPage) {
    FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
    [vc_workoutLogChart hideLoadingIfNeeded:_bool_isLastPage];
  }
}

#pragma mark - 请求workoutlog全部数据
- (void)runRequest_workoutForTotal {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Profile sharedManager] postRequest_Profile_WorkoutDailyReport:0 isFirstPage:YES count:10 userinfo:_dic_info];
}

- (void)loadMore_workoutForTotal {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:2];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [_dic_info setObject:@"loadMore" forKey:@"loadMore"];
  
  [[NetworkManager_Profile sharedManager] postRequest_Profile_WorkoutDailyReport:0 isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - 刷新相关方法
- (void)refreshTableView {
  [[self currentTableView] reloadData];
}

- (void)endHeaderRefreshing {
  if ([[self currentTableView].mj_header isRefreshing])
    [[self currentTableView].mj_header endRefreshing];
  self.bool_reloadSections = NO;
}

- (void)refreshWorkoutLogTotalSummyInfo {
  //刷新第一个cell
  [FGUtils reloadCellWithTableView:[self currentTableView] atSection:0 atIndex:0];
}

- (void)refreshWorkoutLogChartInfo {
  //刷新chart图形
  [FGUtils reloadCellWithTableView:[self currentTableView] atSection:1 atIndex:0];
}

- (void)refreshWorkoutLogsDetailInfo {
  NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, self.marr_data_oneWorkoutLog.count-2)];
  [[self currentTableView] reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (void)updateWorkoutLogDataSrouceWithArr:(NSMutableArray *)_marr_tempOneWorkoutLog {
  NSInteger int_sections = [[self currentTableView] numberOfSections];
  NSInteger int_workoutlogs = _marr_tempOneWorkoutLog.count;
  
  if (int_workoutlogs > int_sections) {
    //添加sections
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(int_sections, int_workoutlogs-int_sections)];
    NSMutableArray *_marr_tmp = [NSMutableArray array];
    for (int i = 0; i < indexSet.count; i++) {
      NSDictionary *_dic = @{@"date":@"-", @"time":@"-", @"caloria":@"-"};
      [_marr_tmp addObject:@{@"section":_dic,@"details":@[]}];
    }
    [self.marr_data_oneWorkoutLog insertObjects:_marr_tmp atIndexes:indexSet];
    [[self currentTableView] insertSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
  } else if (int_workoutlogs < int_sections) {
    //删除sections
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(int_workoutlogs, int_sections-int_workoutlogs)];
    [self.marr_data_oneWorkoutLog removeObjectsAtIndexes:indexSet];
    [[self currentTableView] deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
  }
  self.marr_data_oneWorkoutLog = _marr_tempOneWorkoutLog;
}

- (void)updateChartInfoSelectedAtIndex:(NSInteger)int_idx {
  
}

-(void)hideFooterLoadingIfNeeded
{
  [[self currentTableView].refreshFooter endRefreshing];
  //FGWorkoutLogChartTableViewCell *_vc = [self getWorkoutLogChartViewCell];
  //_vc.str_cursor = @"0";
  if (self.int_cursor == -1)
    [[self currentTableView] allowedShowActivityAtFooter:NO];
  else
    [[self currentTableView] allowedShowActivityAtFooter:YES];
}

- (void)beginToRefresh {
  [[self currentTableView].mj_header beginRefreshing];
}

- (NSMutableArray *)getDataSourceWithWorkoutReports:(NSArray *)_arr_workoutReport atIndex:(NSInteger)_index {
  NSMutableArray *_marr_tempOneWorkoutLog = [NSMutableArray array];
  self.marr_data_workoutLogsTotal = [NSMutableArray arrayWithArray:_arr_workoutReport];
  self.dic_oneWorkoutLog = self.marr_data_workoutLogsTotal[_index];
  
  NSString *_str_timeCount          = self.dic_oneWorkoutLog[@"TimeCount"];
  NSString *_str_workoutCount       = self.dic_oneWorkoutLog[@"WorkoutCount"];
  NSString *_str_caloriaCount       = self.dic_oneWorkoutLog[@"CaloriaCount"];
  
  NSMutableArray *_marr_timeCount = [NSMutableArray array];
  NSMutableArray *_marr_periods = [NSMutableArray array];
  int i = 0;
  for (NSDictionary *_dic_tmp in _arr_workoutReport) {
    NSString *_str_period             = _dic_tmp[@"Period"];
    NSString *_str_timeCount          = _dic_tmp[@"TimeCount"];
    [_marr_timeCount addObject:_str_timeCount];
    [_marr_periods addObject:@{@"period": _str_period,@"timeCount": _str_timeCount, @"isSelected": [NSNumber numberWithBool:i == _index]}];
  }
  CGFloat flt_min = 0;
  CGFloat flt_max = 0;
  [FGUtils sortedGetMaxMinWithArray:_marr_timeCount max:&flt_max min:&flt_min];
  NSLog(@"flt_min=%f,flt_max=%f",flt_min, flt_max);
  
  ;
  [_marr_tempOneWorkoutLog addObject:@{
                                       @"workout":_str_workoutCount,
                                       @"minute":_str_timeCount,
                                       @"caloria":_str_caloriaCount
                                       }];
  
  [_marr_tempOneWorkoutLog addObject:@{
                                       @"chartInfos":@{
                                           @"max":[NSNumber numberWithFloat:flt_max],
                                           @"min":[NSNumber numberWithFloat:flt_min],
                                           @"index": [NSNumber numberWithInteger:_index],
                                           @"infos":_marr_periods}}];
  
  NSArray *_arr_dailyReports = self.dic_oneWorkoutLog[@"DailyReport"];
  NSMutableArray *_marr_list = [NSMutableArray array];
  for (NSDictionary *_dic_tmp_daily in _arr_dailyReports) {
    
    NSString *_str_date = [NSString stringWithFormat:@"%@", _dic_tmp_daily[@"Date"]];
    NSString *_str_duration = [NSString stringWithFormat:@"%@", _dic_tmp_daily[@"Duration"]];
    NSString *_str_total = [NSString stringWithFormat:@"%@", _dic_tmp_daily[@"Total"]];
    
    NSArray *_arr_workoutRecords = _dic_tmp_daily[@"WorkoutRecords"];
    NSMutableArray *_marr_details = [NSMutableArray array];
    int i = 0;
    for (NSDictionary *_dic_tmp_daily_workoutRecord in _arr_workoutRecords) {
      NSString *_str_workoutName = [NSString stringWithFormat:@"%@", _dic_tmp_daily_workoutRecord[@"WorkoutName"]];
      NSString *_str_duration = [NSString stringWithFormat:@"%@", _dic_tmp_daily_workoutRecord[@"Duration"]];
      NSString *_str_calorias = [NSString stringWithFormat:@"%@", _dic_tmp_daily_workoutRecord[@"Consume"]];
      
      NSDictionary *_dic2 = @{@"title":_str_workoutName,
                              @"time":_str_duration,
                              @"caloria":[NSString stringWithFormat:@"%@ %@", _str_calorias, multiLanguage(@"Calorias")],
                              @"hiddenSeparator":[NSNumber numberWithBool:i==_arr_workoutRecords.count-1]};
      [_marr_details addObject:_dic2];
      i++;
    }
    
    NSDictionary *_dic = @{@"date":_str_date, @"time":_str_duration, @"caloria":_str_total};
    [_marr_list addObject:@{@"section":_dic,@"details":_marr_details}];
  }
  [_marr_tempOneWorkoutLog addObjectsFromArray:_marr_list];
  
  return _marr_tempOneWorkoutLog;
}

- (void)reloadChartCellViewWithArr:(NSMutableArray *)_marr_tempOneWorkoutLog isLoadLastest:(BOOL)_bool_loadLastest {
  self.marr_data_oneWorkoutLog = _marr_tempOneWorkoutLog;
  [self refreshTableView];
  
  //  if (_bool_loadLastest)
  //    [[self getWorkoutLogChartViewCell] scrollviewToLastest];
  
  //  [self hideFooterLoadingIfNeeded];
  
  //  FGWorkoutLogChartTableViewCell *vc_workoutLogChart = [self getWorkoutLogChartViewCell];
  //  [vc_workoutLogChart loadCollectionViewWithStyle:(enum_ChartType)charType_currentSelected];
  //  self.bool_reloadSections = NO;
}

#pragma mark - 其它方法
- (NSArray *)reverseDataSource {
  NSMutableArray *_marr_tmp = [self currentOriginData];
  NSArray *_arr_reverse = [[_marr_tmp reverseObjectEnumerator] allObjects];
  return _arr_reverse;
}

- (NSInteger)reverseIndexWithIndex:(NSInteger)_int_idx {
  NSInteger _int_cnt = [self currentOriginData].count;
  return _int_cnt - (_int_idx + 1);
}



- (BOOL)isErrorFromResponseInfo:(NSDictionary *)_dic_info {
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  self.int_cursor                    = [[_dic_info objectForKey:@"Cursor"] intValue];
//  [(x) lowercaseString] rangeOfString:multiLanguage(@"want to lose weight")].location != NSNotFound ? Goal_loseWeight : ([(x) lowercaseString] rangeOfString:multiLanguage(@"want to get toned")].location != NSNotFound ? Goal_stressRelease : ([(x) lowercaseString] rangeOfString:multiLanguage(@"want to learn how to box")].location != NSNotFound ? Goal_howtobox : Goal_undefined))
//
//  ([[(x)lowercaseString] rangeOfString:multiLanguage(@"want to lose weight")].location != NSNotFound ? Goal_loseWeight : ([[@"" lowercaseString] rangeOfString:multiLanguage(@"want to get toned")].location != NSNotFound ? Goal_stressRelease : [[(x)lowercaseString] rangeOfString:multiLanguage(@"want to learn how to box")].location != NSNotFound ? Goal_howtobox : Goal_undefined))
  
  if (_int_code != 0) {
    [self refreshTableView];
    [self endHeaderRefreshing];
    return YES;
  }
  NSArray *_arr_workoutReport = _dic_info[@"DailyReport"];
  if (_arr_workoutReport.count <= 0) {
    [self refreshTableView];
    [self endHeaderRefreshing];
    [self hideFooterLoadingIfNeeded];
    return YES;
  }
  return NO;
}

- (void)refreshTableViewFooterWithActivityStatus:(BOOL)_bool_activity {
  [[self currentTableView] allowedShowActivityAtFooter:_bool_activity];
}
@end
