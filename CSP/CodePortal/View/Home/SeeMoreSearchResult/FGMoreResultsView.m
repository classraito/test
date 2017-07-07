//
//  FGMoreResultsView.m
//  CSP
//
//  Created by JasonLu on 17/1/24.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//
#import "FGHomepageSearchResultView.h"
#import "FGCommonSimpleCellView.h"
#import "FGHomepageSearchWorkoutInfoCellView.h"
#import "FGMoreResultsView.h"
@interface FGMoreResultsView () {
}
@property (nonatomic, strong) NSDictionary *dic_info;
@property (nonatomic, strong) NSMutableArray *marr_data;
@property (nonatomic, assign) NSInteger int_cursor;
@end

@implementation FGMoreResultsView
@synthesize marr_data;
@synthesize int_cursor;
@synthesize dic_info;
@synthesize delegate;

#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self internalInitData];
  [self internalInitalView];}

- (void)dealloc {
  self.marr_data       = nil;
  self.tb_results = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 初始化方法
- (void)setupWithInfo:(NSDictionary *)_dic {
  self.dic_info = _dic;
}

- (void)internalInitData {
  self.marr_data = [NSMutableArray array];
}

- (void)internalInitalView {
  [commond useDefaultRatioToScaleView:[self currentTableView]];
  
  [self currentTableView].delegate = self;
  [self currentTableView].dataSource = self;
  [self currentTableView].tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  __weak __typeof(self) weakSelf = self;
  [self currentTableView].mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_results];
  }];
  
  [[self currentTableView] addInfiniteScrollingWithActionHandler:^{
    [weakSelf runRequest_loadMore];
  }];
}

- (void)beginRefresh {
  [[self currentTableView].mj_header beginRefreshing];
}

- (UITableView *)currentTableView {
  return self.tb_results;
}

- (CGFloat)currentHeightForRow {
  NSString *_str_title = self.dic_info[@"title"];
  if ([_str_title isEqualToString:TITLE_WORKOUTS]) {
    return 100 * ratioH;
  }
  return 50 * ratioH;
}

- (NSInteger)currentNumberOfSection {
  return 1;
}

- (NSMutableArray *)currentDataSource {
  return self.marr_data;
}

- (UITableViewCell *)currentTableViewCell {
  NSString *_str_title = self.dic_info[@"title"];
  if ([_str_title isEqualToString:TITLE_WORKOUTS]) {
    return [self workoutInfoViewCell:[self currentTableView]];
  }
  
  return [self commonSimpleInfoViewCell:[self currentTableView]];
}

- (NSDictionary *)dataForRowAtIndex:(NSInteger)_int_idx {
  return self.marr_data[_int_idx];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return [self currentHeightForRow];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self currentNumberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[self currentDataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [self currentTableViewCell];
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:[self dataForRowAtIndex:indexPath.row]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSDictionary *info = self.marr_data[indexPath.row];
  [self.delegate selectSearchResultWithInfo:info];
}

#pragma mark - 自定义cell
- (UITableViewCell *)workoutInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier           = @"FGHomepageSearchWorkoutInfoCellView";
  FGHomepageSearchWorkoutInfoCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGHomepageSearchWorkoutInfoCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  return cell;
}

- (UITableViewCell *)commonSimpleInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGCommonSimpleCellView";
  FGCommonSimpleCellView *cell    = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGCommonSimpleCellView" owner:self options:nil] lastObject];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleDefault;
  return cell;
}

#pragma mark - 请求数据
- (void)runRequest_results {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"searchResult" forKey:@"searchResult"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  
  [[NetworkManager_Home sharedManager] postRequest_Home_searchSeeMore:self.dic_info[@"keyword"] isFirstPage:YES count:10 userinfo:_dic_info];
}

- (void)runRequest_loadMore {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"searchResultMore" forKey:@"searchResultMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Home sharedManager] postRequest_Home_searchSeeMore:self.dic_info[@"keyword"] isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - 刷新界面
- (void)refreshUIWithInfo:(NSDictionary *)_dic_info {
  self.int_cursor = [_dic_info[@"Cursor"] integerValue];
  
  if ([FGUtils isErrorFromResponseInfo:_dic_info withTableView:[self currentTableView]])
    return;
  
  NSMutableArray *_marr_ret = [self dataInfoFromReuqestWithInfo:_dic_info];
  if (!ISNULLObj(_marr_ret)) {
    [self updateDataSourceWithArr:_marr_ret];
  }
  
  [FGUtils refreshheaderWithTableView:[self currentTableView]];
  if (_marr_ret.count <= 0) {
    [[self currentTableView] showNoResultWithText:multiLanguage(@"No results!")];
  } else {
    [[self currentTableView] reloadData];
  }
}

- (void)refreshLoadMoreUIWithInfo:(NSDictionary *)_dic_info{
  
  if ([FGUtils isErrorFromResponseInfo:_dic_info withTableView:[self currentTableView]])
    return;
  
  NSMutableArray *_marr_more = [self dataInfoFromReuqestWithInfo:_dic_info];
  if (_marr_more && _marr_more.count > 0) {
    NSMutableArray *_marr_current = [self currentDataSource];
    [_marr_current addObjectsFromArray:_marr_more];
    [self updateDataSourceWithArr:_marr_current];
  }
  
  [[self currentTableView] reloadData];
  int cursor                    = [[_dic_info objectForKey:@"Cursor"] intValue];
  [FGUtils refreshWithTableView:[self currentTableView] footerWithActivityStatus:cursor==-1?NO:YES];
}


#pragma mark - 绑定数据
- (void)bindDataToUI {
  [[self currentTableView] resetNoResultView];
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_HOME_SearcSeeMore)];
  [self refreshUIWithInfo:_dic_info];
}

- (void)bindMoreResultsDataToUI {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_HOME_SearcSeeMore)];
  [self refreshLoadMoreUIWithInfo:_dic_info];
}

- (NSMutableArray *)dataInfoFromReuqestWithInfo:(NSDictionary *)_dic_info {
  self.int_cursor = [_dic_info[@"Cursor"] integerValue];
  
  if ([FGUtils isErrorFromResponseInfo:_dic_info withTableView:[self currentTableView]])
    return nil;
  
  NSMutableArray *_marr_tmp = [NSMutableArray array];
  NSArray *_arr_tmp = nil;
  
  NSString *_str_title = [self titleFromInfo];
  if ([_str_title isEqualToString:TITLE_WORKOUTS]) {
    _arr_tmp = _dic_info[@"Trains"];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"Thumbnail"],@"trainingId":_dic_[@"TrainingId"],@"title":@"workouts",@"workoutTitle":_dic_[@"ScreenName"], @"content":_dic_[@"Discreption"]}];
    }];
  }
  else if ([_str_title isEqualToString:TITLE_TRAINERS]){
    _arr_tmp = _dic_info[@"Trainers"];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"UserIcon"],@"id":_dic_[@"UserId"],@"name":_dic_[@"UserName"], @"title":@"trainer"}];
    }];
  }
  else if ([_str_title isEqualToString:TITLE_USERS]){
    _arr_tmp = _dic_info[@"Users"];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"UserIcon"],@"id":_dic_[@"UserId"],@"name":_dic_[@"UserName"], @"title":@"user"}];
    }];
  }
  else if ([_str_title isEqualToString:TITLE_NEWSFEED]){
    _arr_tmp = _dic_info[@"News"];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"NewsThumbnail"],@"id":_dic_[@"NewsId"],@"content":_dic_[@"NewsTitle"], @"title":@"newsfeed", @"link":_dic_[@"Link"]}];
    }];
  }
  else if ([_str_title isEqualToString:TITLE_TOPICS]){
    _arr_tmp = _dic_info[@"Topics"];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"id":_dic_[@"id"],@"content":_dic_[@"topical"], @"title":@"topic"}];
    }];
  }
  
  return _marr_tmp;
}

- (void)updateDataSourceWithArr:(NSMutableArray *)_marr {
  self.marr_data = _marr;
}

- (NSString *)titleFromInfo {
  NSString *_str_title = self.dic_info[@"title"];
  return _str_title;
}
@end
