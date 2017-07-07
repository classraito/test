
//
//  FGWorkoutLogChartTableViewCell.m
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "CYLineLayout.h"
#import "CYPhotoCell.h"
#import "FGWorkoutLogChartTableViewCell.h"
#import "XZMRefresh.h"
#define TAG_COLLECTIONVIEW 1000
static NSString * const CYPhotoId = @"photo";
@interface FGWorkoutLogChartTableViewCell (){
  CGFloat flt_min;
  CGFloat flt_max;
  CGFloat flt_barWidth;
  CGPoint pt_offset;
}
@end

@implementation FGWorkoutLogChartTableViewCell
@synthesize marr_data_workoutChart;
@synthesize delegate;
@synthesize int_indexSelected;
@synthesize str_cursor;
@synthesize view_line;
#pragma mark - 初始化方法
- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
  
  [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, .5) toScaleView:view_line];
  [self internalInitalCollectionViewWithStyle:Chart_week withIndex:0];
  
  self.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
  UICollectionView *collectionView = (UICollectionView *)[self viewWithTag:TAG_COLLECTIONVIEW];
  collectionView.mj_header = nil;
  self.marr_data_workoutChart = nil;
  self.delegate = nil;
  self.str_cursor = nil;
  SAFE_RemoveSupreView(collectionView);
}
- (void)internalInitalCollectionViewWithStyle:(enum_ChartType)charType withIndex:(NSInteger)_int_idx{
  self.int_indexSelected = _int_idx;
  //clear collectionview
  if ([self viewWithTag:TAG_COLLECTIONVIEW]) {
    flt_barWidth = charType == Chart_week ? 30 : 50;
    [self refreshChart];
    return;
  }
  
  flt_barWidth = charType == Chart_week ? 30 : 50;
  CYLineLayout *layout = [[CYLineLayout alloc] init];
  layout.itemSize = CGSizeMake(64 * ratioW, 200 * ratioH);
  // 创建CollectionView
  CGFloat collectionW = self.frame.size.width;
  CGFloat collectionH = 200;
  CGRect frame = CGRectMake(0, 0, collectionW*ratioW, collectionH*ratioH);
  UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
  collectionView.backgroundColor = [UIColor whiteColor];
  collectionView.dataSource = self;
  collectionView.delegate = self;
  collectionView.tag = TAG_COLLECTIONVIEW;
  [self addSubview:collectionView];

  [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CYPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:CYPhotoId];
  
  str_cursor = @"0";
//  __weak __typeof(self) weakSelf = self;
//  collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//    [weakSelf runRequest_loadMore];
//  }];
  
  [collectionView xzm_addNormalHeaderWithTarget:self action:@selector(loadMoreDataWithHeader:)];
//  [collectionView xzm_addNormalFooterWithTarget:self action:@selector(loadMoreDataWithFooter:)];
  // 自动刷新(一进入程序就下拉刷新)
//  [collectionView.xzm_header beginRefreshing];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return marr_data_workoutChart.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CYPhotoId forIndexPath:indexPath];
  
  NSLog(@"indexRow=%ld,indexSelected==%ld", indexPath.row, self.int_indexSelected);
  [cell updateCellViewWithInfo:@{
                                 @"value":marr_data_workoutChart[indexPath.row][@"timeCount"],
                                 @"date":marr_data_workoutChart[indexPath.row][@"period"],
                                 @"max": [NSNumber numberWithFloat:flt_max],
                                 @"min": [NSNumber numberWithFloat:flt_min],
                                 @"barWidth": [NSNumber numberWithFloat:flt_barWidth],
                                 @"isSelected":[NSNumber numberWithBool:indexPath.row == self.int_indexSelected]
                                 }
   ];
  return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (delegate) {
    [self.delegate didSelectedChartAtIndex:indexPath.item];
   
  }
}

//uicollectionview cell 行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return 0;
}

#pragma mark -
- (void)updateCellViewWithInfo:(id)_dataInfo {
  [self updateCellViewWithInfo:_dataInfo isMove:YES];
}

- (void)updateCellViewWithInfo:(id)_dataInfo isMove:(BOOL)_bool_isMove{
  if (_dataInfo == nil)
    return;
  if (ISNULLObj(_dataInfo[@"chartInfos"]))
    return;
  
  self.backgroundColor = rgb(237, 241, 242);

  
  NSDictionary *_dic_charInfos = _dataInfo[@"chartInfos"];
  NSMutableArray *_marr = [NSMutableArray arrayWithArray:_dic_charInfos[@"infos"]];

  NSInteger _int_oldCnt = self.marr_data_workoutChart.count;
  self.marr_data_workoutChart = [NSMutableArray arrayWithArray:_marr];
  NSInteger _int_newCnt = self.marr_data_workoutChart.count;
  flt_min = [_dic_charInfos[@"min"] floatValue];
  flt_max = [_dic_charInfos[@"max"] floatValue];
  
  CGFloat _flt_newLength = (_int_newCnt - _int_oldCnt) * (64 * ratioW) ;
   UICollectionView *_collectionView = [self getCurrentCollectionView];
  CGFloat _flt_offset = _flt_newLength + _collectionView.contentOffset.x;
  self.int_indexSelected = [_dic_charInfos[@"index"] integerValue];
  
  [self refreshChart];
  if (_bool_isMove)
  {
    NSInteger _int_idx = [_dic_charInfos[@"index"] integerValue];
    [self moveCollectionViewAtIndex:_int_idx];
  } else {
    [_collectionView setContentOffset:CGPointMake(_flt_offset, 0) animated:NO];
  }
  
  [self refreshSepetaorLineView];
}

- (void)refreshCollectionView:(UICollectionView *)collectionView atIndex:(NSInteger)index withAnimation:(BOOL)isAnimation {
  if (delegate) {
    self.int_indexSelected = index;
//    [self.delegate didSelectedChartAtIndex:index];
    [collectionView setContentOffset:CGPointMake((index) * (64 * ratioW), 0) animated:isAnimation];
  }
}

#pragma mark - 加载更多周数据
- (void)bindDataToUIForWeek_loadMore {
  NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_WorkoutReport)];
  NSLog(@"_dic_info==%@",_dic_info);
  
  NSInteger _int_code = [_dic_info[@"Code"] integerValue];
  if (_int_code != 0) {
    return;
  }
  
  NSArray *_arr_workoutReport = _dic_info[@"WorkoutReport"];
//  _arr_workoutReport = [[_arr_workoutReport reverseObjectEnumerator] allObjects];
  
  NSMutableArray *_marr_newWorkoutLog = [NSMutableArray arrayWithArray:_arr_workoutReport];
  [_marr_newWorkoutLog addObjectsFromArray:self.marr_data_workoutChart];
  
  self.marr_data_workoutChart = _marr_newWorkoutLog;
  UICollectionView *collectionView = (UICollectionView *)[self viewWithTag:TAG_COLLECTIONVIEW];
  [collectionView reloadData];
}

- (void)bindDataToUIForMonth_loadMore {
  
}

#pragma mark - 请求更多数据
- (void)runRequest_loadMore {
  [self.delegate didLoadMoreData];
}


- (void)loadMoreDataWithHeader:(XZMRefreshHeader *)header {
  [self runRequest_loadMore];
}

-(void)hideLoadingIfNeeded:(BOOL)isHidden {
  UICollectionView *_vc_chart = [self getCurrentCollectionView];
  if (isHidden)
    [_vc_chart.xzm_header endRefreshing];
}

#pragma mark - 刷新界面
- (void)refreshChart {
  UICollectionView *collectionView = [self getCurrentCollectionView];
//  pt_offset = collectionView.contentOffset;

//  CGPoint offset = collectionView.contentOffset;
//  [collectionView layoutIfNeeded]; // Force layout so things are updated before resetting the contentOffset.
//  [collectionView reloadData];
//  [collectionView setContentOffset:pt_offset];
  [collectionView reloadData];
}

- (void)moveCollectionViewAtIndex:(NSInteger)_int_idx {
  UICollectionView *_collectionView = [self getCurrentCollectionView];
  pt_offset = CGPointMake((_int_idx) * (64 * ratioW), 0);
  [_collectionView setContentOffset:CGPointMake((_int_idx) * (64 * ratioW), 0) animated:NO];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  pt_offset = scrollView.contentOffset;
}

#pragma mark - 其它方法
- (UICollectionView *)getCurrentCollectionView {
  UICollectionView *collectionView = (UICollectionView *)[self viewWithTag:TAG_COLLECTIONVIEW];
  return collectionView;
}

- (NSInteger)reverseIndexWithIndex:(NSInteger)_int_idx {
  NSInteger _int_cnt = self.marr_data_workoutChart.count;
  return _int_cnt - (_int_idx + 1);
}

- (void)refreshSepetaorLineView {
  [self insertSubview:self.view_line aboveSubview:[self getCurrentCollectionView]];
}

- (void)scrollviewToLastest{
  UICollectionView *collectionView = (UICollectionView *)[self viewWithTag:TAG_COLLECTIONVIEW];
  
  [self refreshCollectionView:collectionView atIndex:(self.marr_data_workoutChart.count-1) withAnimation:NO];
}
@end
