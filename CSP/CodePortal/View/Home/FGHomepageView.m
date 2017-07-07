//
//  FGHomepageView.m
//  CSP
//
//  Created by JasonLu on 16/9/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGHomepageFeaturedUserCellView.h"
#import "FGHomepageNewsInfoCellView.h"
#import "FGHomepageTitleView.h"
#import "FGHomepageTopScrollCellView.h"
#import "FGHomepageTrendingWorkoutCellView.h"
#import "FGHomepageView.h"
#import "UIScrollView+FGRereshFooter.h"
#import "UIScrollView+FGRereshHeader.h"
#import "UITableViewCell+BindDataToUI.h"
#import <objc/runtime.h>


@interface FGHomepageView () {
  CGAffineTransform transfrom_topCell;
  NSInteger int_cursor;
}

@end

@implementation FGHomepageView
@synthesize arr_data;
@synthesize tb_homepage;
@synthesize delegate;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:tb_homepage];
  [self internalInitalTitleSectionView];
  [self internalInitalView];
}

- (void)internalInitalTitleSectionView {
  if (self.view_newsTitle)
    return;

  FGHomepageTitleView *titleView = (FGHomepageTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTitleView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:titleView];
  [titleView updateLeftTitleHidden:NO withTitle:multiLanguage(@"") color:color_homepage_black andRightTitleHidden:YES withTitle:multiLanguage(@"") color:color_homepage_lightGray];
  titleView.frame     = CGRectMake(0, 0, titleView.bounds.size.width, titleView.bounds.size.height);
  self.view_newsTitle = titleView; //添加标题信息
  self.view_newsTitle.hidden = YES;
}

- (void)internalData {
  self.arr_data = [[NSMutableArray alloc] initWithObjects:@[], @[], nil];
  NSMutableArray *firstSectionDatas = [NSMutableArray array];
  //解析轮播图
  NSMutableArray *topScrollInfos = [NSMutableArray array];
  [topScrollInfos addObject:IMG_PLACEHOLDER1];
  [firstSectionDatas addObject:topScrollInfos];
    
    
  
#ifdef REMOVEFAETUREUSER
  ;
#else
  //解析featured users
  NSArray *featuredUsesInfos = @[];
  [firstSectionDatas addObject:featuredUsesInfos];
#endif
  
  
#ifdef REMOVEWORKOUTS
  ;
#else
  //解析Trending workouts
  NSArray *trendingWorkoutsInfos = @[];
  [firstSectionDatas addObject:trendingWorkoutsInfos];
#endif
  [self.arr_data replaceObjectAtIndex:0 withObject:firstSectionDatas];
  [self.tb_homepage reloadData];
}

- (void)internalInitalView {
  self.tb_homepage.delegate = self;
  self.tb_homepage.dataSource = self;

  [self.tb_homepage addPullToRefreshWithActionHandler:nil];
  [self.tb_homepage setShowsPullToRefresh:NO];
  [self.tb_homepage triggerRecoveryAnimationIfNeeded];
  [self.tb_homepage triggerRecoveryAnimationIfNeeded];

  __weak FGHomepageView *weakSelf = self;
  [self.tb_homepage addInfiniteScrollingWithActionHandler:^{
    [weakSelf loadMore_news];
  }];
  
  self.tb_homepage.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf postRequst_getHomepage];
  }];
  
  
  [self internalData];
  
  
}

- (void)dealloc {
  //  [self.tb_homepage setRefreshFooter:nil];
  self.arr_data       = nil;
  self.tb_homepage    = nil;
  self.view_newsTitle = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 请求homepage
- (void)postRequst_getHomepage {
  [[NetworkManager_Home sharedManager] postRequest_Home_getHomePage:nil];
}

- (void)loadMore_news {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionary];
  [_dic_info setObject:@"homepage_loadMoreNews" forKey:@"homepage_loadMoreNews"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Home sharedManager] postRequest_Home_newsFeed:@"" isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
#ifdef REMOVEFAETUREUSER
  #ifdef REMOVEWORKOUTS
    if (indexPath.section == 0) {
      if (indexPath.row == 0)
        return 177 * ratioH;
    }
    return 102 * ratioH;
    
  #else
    if (indexPath.section == 0) {
      if (indexPath.row == 0)
        return 177 * ratioH;
      else if (indexPath.row == 1)
        return 202 * ratioH;
    }
    return 102 * ratioH;
  #endif
#else
  if (indexPath.section == 0) {
    if (indexPath.row == 0)
      return 177 * ratioH;
    else if (indexPath.row == 1)
      return 112 * ratioH;
    else if (indexPath.row == 2)
      return 202 * ratioH;
  }
  return 102 * ratioH;
#endif
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
  if (section == 0)
    return 0;
  else
    return self.view_newsTitle.frame.size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 0)
    return nil;
  return self.view_newsTitle;
}


#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data[section] count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  if (indexPath.section == 0) {
#ifdef REMOVEFAETUREUSER
  #ifdef REMOVEWORKOUTS
      if (indexPath.row == 0) {
        cell = [self topInfoScrollViewCell:tableView];
      }
  #else
      if (indexPath.row == 0) {
        cell = [self topInfoScrollViewCell:tableView];
        ;
      } else if (indexPath.row == 1) {
        cell = [self trendingWorkoutViewCell:tableView];
      }
  #endif
#else
    if (indexPath.row == 0) {
      cell = [self topInfoScrollViewCell:tableView];
      ;
    } else if (indexPath.row == 1) {
      cell = [self featuredUserViewCell:tableView];
    } else if (indexPath.row == 2) {
      cell = [self trendingWorkoutViewCell:tableView];
    }
#endif
    
  } else {
    cell = [self newsInfoViewCell:tableView];
  }
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:arr_data[indexPath.section][indexPath.row]];
  }
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath==%@", indexPath);
}

#pragma mark - FGHomepageTopScrollCellViewDelegate
- (void)action_didSelectTopScrollAtIndex:(NSInteger)_int_idx {
  
  //如果没有登录需要登录
  if(![appDelegate isLoggedIn])
  {
    [commond showAskForLogin];
    return;
  }
  
  enum_banner _bannerIndex = (enum_banner)_int_idx;
  FGProfileViewController *_vc_profile = (FGProfileViewController *)[self viewController];
  if (_bannerIndex == banner_findagroup) {
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationFindAGroupViewController *_vc = [[FGLocationFindAGroupViewController alloc] initWithNibName:@"FGLocationFindAGroupViewController" bundle:nil];
    [manager pushController:_vc navigationController:nav_current];
  } else if (_bannerIndex == banner_booknow) {
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationFindATrainerViewController *_vc = [[FGLocationFindATrainerViewController alloc] initWithNibName:@"FGLocationFindATrainerViewController" bundle:nil];
    [manager pushController:_vc navigationController:nav_current];
  } else if (_bannerIndex == banner_userprofile) {
    [_vc_profile buttonAction_profile:nil];
  } else if (_bannerIndex == banner_workout) {
    [_vc_profile buttonAction_traning:nil];
  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)topInfoScrollViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier   = @"FGHomepageTopScrollCellView";
  FGHomepageTopScrollCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTopScrollCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)featuredUserViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier      = @"FGHomepageFeaturedUserCellView";
  FGHomepageFeaturedUserCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGHomepageFeaturedUserCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)trendingWorkoutViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier         = @"FGHomepageTrendingWorkoutCellView";
  FGHomepageTrendingWorkoutCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGHomepageTrendingWorkoutCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (UITableViewCell *)newsInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier  = @"FGHomepageNewsInfoCellView";
  FGHomepageNewsInfoCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGHomepageNewsInfoCellView" owner:self options:nil] lastObject];
  }
  cell.delegate = self;
  return cell;
}

- (FGHomepageTopScrollCellView *)getFGHomepageTopScrollCellView {
  NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
  UITableViewCell *curCell = [self.tb_homepage cellForRowAtIndexPath:indexPath];
  if ([curCell isKindOfClass:[FGHomepageTopScrollCellView class]]) {
    FGHomepageTopScrollCellView *cell = (FGHomepageTopScrollCellView *)curCell;
    return cell;
  }
  return nil;
}

#pragma mark - 利用scrollView 实现顶部的一个缩放特效
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  if (scrollView.contentOffset.y < 0) {
//    NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *curCell = [self.tb_homepage cellForRowAtIndexPath:indexPath];
//    if ([curCell isKindOfClass:[FGHomepageTopScrollCellView class]]) {
//      FGHomepageTopScrollCellView *cell = (FGHomepageTopScrollCellView *)curCell;
//      CGFloat scalePercent              = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
//      cell.transform                    = CGAffineTransformMakeScale(1 + scalePercent * 3, 1 + scalePercent * 3);
//      CGRect _frame                     = cell.frame;
//      _frame.origin.y                   = scrollView.contentOffset.y;
//      cell.frame                        = _frame;
//      
//      if (cell.view_topInfoScroll.autoScroll) {
//        cell.view_topInfoScroll.autoScroll = NO;
//      }
//    }
//  }
//  else {
//    [self recoverTopInfoCellPosition];
//  }
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  //从数据中心获取信息，更新arr_data数组数据
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_HOME_HomePage)];
  NSLog(@"user profile=%@",_dic_result);
  
  NSDictionary *_dic_tmp = _dic_result;
  NSMutableArray *firstSectionDatas = [NSMutableArray array];
  NSDictionary *_dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"TitleImages"];
  ;
  NSArray *_arr_tmp = _dic_ret[@"ResponseContent"][@"Images"];
  //解析轮播图
  __block NSMutableArray *topScrollInfos = [NSMutableArray array];
  [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    [topScrollInfos addObject:obj];
  }];
  [firstSectionDatas addObject:topScrollInfos];
  
  
  _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"GetUserList"];
  _arr_tmp = _dic_ret[@"ResponseContent"][@"Users"];
  __block NSMutableArray *_marr_tmp = [NSMutableArray array];
  [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_ = (NSDictionary *)obj;
    [_marr_tmp addObject:@{@"img":_dic_[@"UserIcon"],@"id":_dic_[@"UserId"],@"username":_dic_[@"UserName"]}];
    
    if (idx >= 4) {
      *stop = YES;
    }
  }];
  
#ifdef REMOVEFAETUREUSER
  ;
#else
  //解析featured users
  NSArray *featuredUsesInfos = nil;
  featuredUsesInfos          = _marr_tmp;
  if (featuredUsesInfos.count > 6) {
    featuredUsesInfos = [_marr_tmp subarrayWithRange:NSMakeRange(0, 5)];
  }
  [firstSectionDatas addObject:featuredUsesInfos];
#endif
  
#ifdef REMOVEWORKOUTS
  ;
#else
  //解析Trending workouts
  _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"GetFeaturedList"];
  _arr_tmp = _dic_ret[@"ResponseContent"][@"Trains"];
  _marr_tmp = [NSMutableArray array];
  [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
    NSDictionary *_dic_ = (NSDictionary *)obj;
    [_marr_tmp addObject:@{@"img":_dic_[@"Thumbnail"],@"trainingId":_dic_[@"TrainingId"],@"username":_dic_[@"ScreenName"]}];
  }];
  NSArray *trendingWorkoutsInfos = nil;
  trendingWorkoutsInfos          = _marr_tmp;
  [firstSectionDatas addObject:trendingWorkoutsInfos];
#endif
  
  [self.arr_data replaceObjectAtIndex:0 withObject:firstSectionDatas];
  
  //解析NewsFeeds
  _dic_ret = [FGUtils infoFromArray:_dic_tmp[@"Responses"] withKey:@"NewsFeeds"];
  _arr_tmp = _dic_ret[@"ResponseContent"][@"News"];
  _marr_tmp = [NSMutableArray array];
  [_arr_tmp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    NSDictionary *_dic_ = (NSDictionary *)obj;
    [_marr_tmp addObject:@{@"img":_dic_[@"NewsThumbnail"],@"newsid":_dic_[@"NewsId"],@"newsTitle":_dic_[@"NewsTitle"],@"link":_dic_[@"Link"]}];
  }];
  //解析news
  NSArray *newsInfo = nil;
  newsInfo          = _marr_tmp;
  [self.arr_data replaceObjectAtIndex:1 withObject:newsInfo];
  self.view_newsTitle.hidden = NO;
  [self.view_newsTitle updateLeftTitleWith:multiLanguage(@"NEWS") rightTitleWith:nil];
  [self.tb_homepage.mj_header endRefreshing];
  [self.tb_homepage reloadData];
  [self scrollViewDidScroll:tb_homepage];
  
  
  [self recoverTopInfoCellPosition];
}

- (void)reloadRowAtIndex:(NSInteger)index {
  NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:index];
  [self.tb_homepage reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)recoverTopInfoCellPosition {
  FGHomepageTopScrollCellView *cv_top = [self getFGHomepageTopScrollCellView];
  if (cv_top) {
    cv_top.view_topInfoScroll.autoScroll = YES;
    
    cv_top.transform                    = CGAffineTransformMakeScale(1, 1);
    CGRect _frame                     = cv_top.frame;
    _frame.origin.y                   = self.tb_homepage.contentOffset.y;
    cv_top.frame                        = CGRectMake(0, 0, _frame.size.width, _frame.size.height);
  }
}

#pragma mark - 加载更多新闻
- (void)loadMoreNews{
  
  NSMutableArray *arr = [NSMutableArray arrayWithArray:self.arr_data[1]];
  NSArray *newsInfo   = nil;
  
  NSMutableDictionary *_dic_newsResult  = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_HOME_NewsFeeds)];
  NSArray *_arr_tmp = _dic_newsResult[@"News"];
  newsInfo            = _arr_tmp;
  [arr addObjectsFromArray:newsInfo];
  [self.arr_data replaceObjectAtIndex:1 withObject:arr];
  [self.tb_homepage reloadData];
  [self.tb_homepage.refreshFooter endRefreshing];
  
  int cursor                    = [[_dic_newsResult objectForKey:@"Cursor"] intValue];
  [self refreshTableViewFooterWithActivityStatus:cursor==-1?NO:YES];
}

- (void)didClickButton:(UIButton *)sender {
  NSLog(@"sender.superview.superview==%@", sender.superview.superview);
  UITableViewCell *cell = (UITableViewCell *)sender.superview.superview;
  if ([cell isKindOfClass:[FGHomepageFeaturedUserCellView class]]) {
    [self.delegate didClickWithViewControllerName:@"FGHomepageFeaturedUserListViewController" withInfo:nil];
  }
  else if ([cell isKindOfClass:[FGHomepageTrendingWorkoutCellView class]]) {
    [self.delegate didClickWithViewControllerName:@"FGHomeWorkoutsListViewController" withInfo:nil];
  }
  else if ([cell isKindOfClass:[FGHomepageNewsInfoCellView class]]) {
    ;
    NSIndexPath *_indexPath_ = [self.tb_homepage indexPathForCell:cell];
    NSLog(@"indexPath==%@", _indexPath_);
    [self.delegate didClickWithViewControllerName:@"FGNewsInfoViewController" withInfo:self.arr_data[_indexPath_.section][_indexPath_.row]];
  }
//  NSIndexPath *indexPath = [self.tb_homepage indexPathForCell:cell];
}

//-(void)didClickInfoButton:(NSInteger)_idx{
-(void)didClickInfoButtonWithType:(NSString *)type objAtIndex:(NSInteger)_idx {
#ifdef REMOVEFAETUREUSER
  if ([type isEqualToString:@"trendingWorkout"]) {
    // 进入trending workout
    NSDictionary *_dic_train = self.arr_data[0][1][_idx];
    NSString * _str_workoutId = _dic_train[@"trainingId"];
    
    [self.delegate didClickWithViewControllerName:@"FGTrainingDetailViewController" withInfo:_str_workoutId];
  }
#else
  if ([type isEqualToString:@"featuredUser"]) {
    NSDictionary *_dic_friend = self.arr_data[0][1][_idx];
    NSLog(@"_dic_friend = %@",_dic_friend);
    [self.delegate didClickWithViewControllerName:@"FGFriendProfileViewController" withInfo:_dic_friend];
    
  }
  else if ([type isEqualToString:@"trendingWorkout"]) {
    // 进入trending workout
    NSDictionary *_dic_train = self.arr_data[0][2][_idx];
    NSString * _str_workoutId = _dic_train[@"trainingId"];
    
    [self.delegate didClickWithViewControllerName:@"FGTrainingDetailViewController" withInfo:_str_workoutId];
  }
#endif
  
}

#pragma mark - 其它
- (void)refreshTableViewFooterWithActivityStatus:(BOOL)_bool_activity {
  [self.tb_homepage allowedShowActivityAtFooter:_bool_activity];
}
@end
