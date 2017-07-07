//
//  FGHomepageSearchResultView.m
//  CSP
//
//  Created by JasonLu on 16/10/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//



#import "FGCommonSimpleCellView.h"
#import "FGHomepageSearchResultView.h"
#import "FGHomepageSearchWorkoutInfoCellView.h"
#import "FGHomepageTitleView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "UITableView+ShowNoResult.h"

#define IsEqual(str1, str2) [(str1) isEqualToString:(str2)]

@interface FGHomepageSearchResultView () <FGHomepageTitleViewDelegate>
@end

@implementation FGHomepageSearchResultView
@synthesize arr_data;
@synthesize tb_searchResult;
@synthesize view_title;
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [self internalInitalSearchResultView];
}

- (void)internalInitalSearchResultView {
  [commond useDefaultRatioToScaleView:tb_searchResult];
  view_title = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_title];
  
  //删除多余行
  self.tb_searchResult.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tb_searchResult addPullToRefreshWithActionHandler:nil];
  [self.tb_searchResult setShowsPullToRefresh:NO];
  self.arr_data = [NSMutableArray array];
  
  //界面加载
  [self.tb_searchResult setupLoadingMaskLayerHidden:NO withAlpha:1.0 withSpinnerHidden:NO];
}

- (FGHomepageTitleView *)getHomepageTitleView {
  FGHomepageTitleView *titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  [titleView setupWithBgColor:color_bgGray leftTitleFont:font(FONT_TEXT_REGULAR, 16) rightTitleFont:font(FONT_TEXT_REGULAR, 16)];
  return titleView;
}

- (void)dealloc {
  self.arr_data        = nil;
  self.tb_searchResult = nil;
  self.view_title      = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0 &&
      (!ISNULLObj(self.arr_data[indexPath.section][@"title"]) && IsEqual(self.arr_data[indexPath.section][@"title"], TITLE_WORKOUTS))) {
    return 100 * ratioH;
  }
  return 50 * ratioH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
  return self.view_title.frame.size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  NSDictionary *info = self.arr_data[section];
  FGHomepageTitleView *view_tmpTitleView = [self getHomepageTitleView];
#ifdef NOSEEMORE_FEATURE
  [view_tmpTitleView updateLeftTitleHidden:NO withTitle:info[@"title"] color:color_homepage_black andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
#else
  [view_tmpTitleView updateLeftTitleHidden:NO withTitle:info[@"title"] color:color_homepage_black andRightTitleHidden:NO withTitle:multiLanguage(@"See more >") color:color_homepage_lightGray rightButtonHidden:NO tag:section];
  view_tmpTitleView.delegate = self;
#endif

  return view_tmpTitleView;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.arr_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (self.arr_data.count > 0 &&
      self.arr_data[section][@"content"] != nil)
    return [self.arr_data[section][@"content"] count];
  
  return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;

  NSDictionary *info = self.arr_data[indexPath.section];
  if (IsEqual(info[@"title"], TITLE_WORKOUTS)) {
    cell = [self workoutInfoViewCell:tableView];
  } else {
    cell = [self commonSimpleInfoViewCell:tableView];
  }

  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:info[@"content"][indexPath.row]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  NSDictionary *info = self.arr_data[indexPath.section][@"content"][indexPath.row];
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

#pragma mark - 成员方法
- (void)bindDataToUI {
  [self.arr_data removeAllObjects];
  // TODO: 从数据中心获取信息，更新arr_data数组数据
  
  NSMutableDictionary *_dic_homeSearch  = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_HOME_HomeSearch)];
  
  NSDictionary *_dic_tmp = _dic_homeSearch;
  //请求网络数据
  dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 0/*2*NSEC_PER_SEC*/);
  dispatch_after(time, dispatch_get_main_queue(), ^{
//    [self bindDataToUI];
    
    NSArray *_arr_tmp = nil;
//    NSMutableArray *firstSectionDatas = [NSMutableArray array];
    NSDictionary *_dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"SearchWorkouts"];
    _arr_tmp = _dic_ret[@"ResponseContent"][@"Trains"];
    __block NSMutableArray *_marr_tmp = [NSMutableArray array];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"Thumbnail"],@"trainingId":_dic_[@"TrainingId"],@"title":@"workouts",@"workoutTitle":_dic_[@"ScreenName"], @"content":_dic_[@"Discreption"]}];
      if (idx == 2) {
        *stop = YES;
      }
    }];
    
    NSArray *workouts = _marr_tmp;

    _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"SearchTrainer"];
    _arr_tmp = _dic_ret[@"ResponseContent"][@"Trainers"];
    _marr_tmp = [NSMutableArray array];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"UserIcon"],@"id":_dic_[@"UserId"],@"name":_dic_[@"UserName"], @"title":@"trainer"}];
    }];
    NSArray *trainers = _marr_tmp;
    
    _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"GetUserList"];
    _arr_tmp = _dic_ret[@"ResponseContent"][@"Users"];
    _marr_tmp = [NSMutableArray array];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"UserIcon"],@"id":_dic_[@"UserId"],@"name":_dic_[@"UserName"], @"title":@"user"}];
    }];
    NSArray *users = _marr_tmp;
    
    _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"NewsFeeds"];
    _arr_tmp = _dic_ret[@"ResponseContent"][@"News"];
    _marr_tmp = [NSMutableArray array];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"url":_dic_[@"NewsThumbnail"],@"id":_dic_[@"NewsId"],@"content":_dic_[@"NewsTitle"], @"title":@"newsfeed", @"link":_dic_[@"Link"]}];
    }];
    NSArray *newsFeeds = _marr_tmp;
    
    _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"GetTopicList"];
    _arr_tmp = _dic_ret[@"ResponseContent"][@"Topics"];
    _marr_tmp = [NSMutableArray array];
    [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSDictionary *_dic_ = (NSDictionary *)obj;
      [_marr_tmp addObject:@{@"id":_dic_[@"id"],@"content":_dic_[@"topical"], @"title":@"topic"}];
    }];
    NSArray *topicsList = _marr_tmp;
    
    NSInteger _int_resultTotal = 0;
    NSMutableArray *_marr_ret = [NSMutableArray array];
    if (workouts.count > 0) {
      [_marr_ret addObject:@{@"title":TITLE_WORKOUTS,@"content":workouts}];
      _int_resultTotal += workouts.count;
    }
    if (trainers.count > 0) {
      [_marr_ret addObject:@{@"title":TITLE_TRAINERS,@"content":trainers}];
      _int_resultTotal += trainers.count;
    }
    if (users.count > 0) {
      [_marr_ret addObject:@{@"title":TITLE_USERS,@"content":users}];
      _int_resultTotal += users.count;
    }
    if (newsFeeds.count > 0) {
      [_marr_ret addObject:@{@"title":TITLE_NEWSFEED,@"content":newsFeeds}];
      _int_resultTotal += newsFeeds.count;
    }
    if (topicsList.count > 0) {
      [_marr_ret addObject:@{@"title":TITLE_TOPICS,@"content":topicsList}];
      _int_resultTotal += topicsList.count;
    }
    
    self.arr_data =  _marr_ret;
    [self.tb_searchResult setupLoadingMaskLayerHidden:YES];
    [self.tb_searchResult reloadData];
    
    if (_int_resultTotal <= 0) {
      [self.tb_searchResult showNoResultWithText:multiLanguage(@"No results!")];
    }
    
  });

}

#pragma mark - FGHomepageTitleViewDelegate
- (void)action_didSelectTitle:(id)sender {
//  NSLog(@"sender==%@",sender);
  NSString *_str_title = [NSString stringWithFormat:@"%@", sender];
  [self.delegate action_gotoSeeMoreInfoWithSection:_str_title];
}
@end
