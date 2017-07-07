//
//  FGMyBadgesView.m
//  CSP
//
//  Created by JasonLu on 16/10/10.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "FGBadgeInfoPopView.h"
#import "FGBadgeCollectionViewCell.h"
#import "FGHomepageTitleView.h"
#import "FGMyBadgesTitleCollectionHeaderView.h"
#import "FGMyBadgesView.h"
#import "XLPlainFlowLayout.h"
#import "FGNewBadgeInfoPopupView.h"
#define cellWith (63 * ratioW)
#define cellHeight (63 * ratioH)
#define CELLSIZE(width, height) CGSizeMake(width, height);

// 注意const的位置
static NSString *const cellId   = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@interface FGMyBadgesView () {
  FGBadgeInfoPopView *view_badgeInfo;
  FGNewBadgeInfoPopupView *view_newBadgeInfo;
  UIView *view_bg;
}
@end

@implementation FGMyBadgesView
@synthesize arr_data;
@synthesize str_id;
@synthesize cv_myBadgesList;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];

  [commond useDefaultRatioToScaleView:self.cv_myBadgesList];
  [self internalInitalMyBadgesListView];
}

- (void)internalInitalMyBadgesListView {
  //创建一个layout布局类
  //  UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
  XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
  //设置布局方向为垂直流布局
  layout.scrollDirection = UICollectionViewScrollDirectionVertical;
  //设置每个item的大小为100*100
  layout.itemSize = CELLSIZE(cellWith, cellWith);
  // 这个属性只能iOS版本大于9.0才能用
  //  layout.sectionHeadersPinToVisibleBounds = YES;
  layout.naviHeight                    = 0;
  cv_myBadgesList.collectionViewLayout = layout;

  cv_myBadgesList.backgroundColor = [UIColor whiteColor];
  cv_myBadgesList.dataSource      = self;
  cv_myBadgesList.delegate        = self;

  // 注册cell、sectionHeader、sectionFooter
  [cv_myBadgesList registerClass:[FGBadgeCollectionViewCell class] forCellWithReuseIdentifier:cellId];
  //  [cv_myBadgesList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
  [cv_myBadgesList registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];

  //注册头部视图
  [cv_myBadgesList registerNib:[UINib nibWithNibName:NSStringFromClass([FGMyBadgesTitleCollectionHeaderView class]) bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerId];
}

- (void)internalInitalProfileSectionTitleView {
}

- (void)dealloc {
  self.arr_data = nil;
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  [self.arr_data removeAllObjects];
  
  NSMutableDictionary *_dic_users = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_GetUserBadges)];
  
  NSArray *_arr_badges = _dic_users[@"Badges"];
  NSArray *_arr_HiddenBadges = _dic_users[@"HiddenBadges"];
  
  /*
   {
   "BadgeId":"3323",
   "Brief":"登录APP",
   "Thumbnail":"http://www.ifweo.com/ifee/ixls.png",
   "Progress":7,
   "Achieve":10,
   "GotTime":12345678901
   }
   */
  
  NSInteger _int_badges = _arr_badges.count;
  NSInteger _int_gotBadges = 0;
  for (NSDictionary *_dic_badgesInfo in _arr_badges) {
    if ([_dic_badgesInfo[@"GotTime"] integerValue] != 0 ) {
      _int_gotBadges++;
    }
  }
  
  NSInteger _int_hiddenBadges = _arr_HiddenBadges.count;
  NSInteger _int_gotHiddenBadges = 0;
  for (NSDictionary *_dic_badgesInfo in _arr_HiddenBadges) {
    if ([_dic_badgesInfo[@"GotTime"] integerValue] != 0 ) {
      _int_gotHiddenBadges++;
    }
  }
  
  if (_int_hiddenBadges > 0) {
    self.arr_data = [NSMutableArray arrayWithArray:@[
                                                     @{ @"title" : multiLanguage(@"Training Badges"),
                                                        @"subtitle" : [NSString stringWithFormat:@"%ld/%ld",_int_gotBadges,_int_badges],
                                                        @"badgeslist" : _arr_badges },
                                                     @{ @"title" : multiLanguage(@"Hidden Badges"),
                                                        @"subtitle" : [NSString stringWithFormat:@"%ld/%ld",_int_gotHiddenBadges,_int_hiddenBadges],
                                                        @"badgeslist" : _arr_HiddenBadges }
                                                     ]];
  } else {
    self.arr_data = [NSMutableArray arrayWithArray:@[
                                                     @{ @"title" : multiLanguage(@"Training Badges"),
                                                        @"subtitle" : [NSString stringWithFormat:@"%ld/%ld",_int_gotBadges,_int_badges],
                                                        @"badgeslist" : _arr_badges }]];
  }

  [self.cv_myBadgesList reloadData];
}

- (void)runRequest_GetUserBadges {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
  [[NetworkManager_Profile sharedManager] postRequest_Profile_GetUserBadgesWithUserId:self.str_id userinfo:_dic_info];
}

#pragma mark - UICollectionViewDataSource
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return self.arr_data.count;
}
//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.arr_data[section][@"badgeslist"] count];
}

//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  FGBadgeCollectionViewCell *cell = (FGBadgeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
  NSDictionary *sectionInfo       = self.arr_data[indexPath.section];
  NSArray *badgesList             = sectionInfo[@"badgeslist"];
//  NSDictionary *badgeInfo         = @{ @"img" : badgesList[indexPath.row] };
  [cell setupBadgeWithInfo:badgesList[indexPath.row]];
  //  cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"indexPath==%@",indexPath);
  
  NSArray *_arr_badges = self.arr_data[indexPath.section][@"badgeslist"];
  NSDictionary *_dic_info = _arr_badges[indexPath.row];
  
  NSString *_str_progress = [NSString stringWithFormat:@"%@",_dic_info[@"Progress"]];
  NSString *_str_achieve = [NSString stringWithFormat:@"%@",_dic_info[@"Achieve"]];
  CGFloat _flt_progress = [_str_progress floatValue] / [_str_achieve floatValue];
  
//  if (_flt_progress >= 1.0) {
//    view_badgeInfo = (FGBadgeCompeleteInfoPopView *)[[[NSBundle mainBundle] loadNibNamed:@"FGBadgeCompeleteInfoPopView" owner:nil options:nil] objectAtIndex:0];
//    
//    [view_badgeInfo setupViewWithInfo:_dic_info];
//    [commond useDefaultRatioToScaleView:view_badgeInfo];
//    view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
//    [appDelegate.window addSubview:view_bg];
//    [appDelegate.window addSubview:view_badgeInfo];
//    
//    
//  } else
  {
    view_newBadgeInfo = (FGNewBadgeInfoPopupView *)[[[NSBundle mainBundle] loadNibNamed:@"FGNewBadgeInfoPopupView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_newBadgeInfo];
    view_newBadgeInfo.center = CGPointMake(W/2, H/2);
    
    [view_newBadgeInfo setupViewWithInfo:_dic_info];
    view_bg = [FGUtils getBlackBgViewWithSize:getScreenSize() withAlpha:0.8f];
    [appDelegate.window addSubview:view_bg];
    [appDelegate.window addSubview:view_newBadgeInfo];
  }
  
  [view_newBadgeInfo.btn_close addTarget:self action:@selector(buttonAction_removeBadgeInfoPopView:) forControlEvents:UIControlEventTouchUpInside];
  [view_newBadgeInfo.btn_seeMyBadges addTarget:self action:@selector(buttonAction_removeBadgeInfoPopView:) forControlEvents:UIControlEventTouchUpInside];
  [view_badgeInfo.btn_cancel addTarget:self action:@selector(buttonAction_removeBadgeInfoPopView:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CELLSIZE(cellWith, cellHeight);
}

////定义每个UICollectionView 的 margin
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//  return UIEdgeInsetsMake(0, 0, 0, 0);
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                      layout:(UICollectionViewLayout *)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
  return .5f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                                 layout:(UICollectionViewLayout *)collectionViewLayout
    minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  return .5f;
}

//定义header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeMake(self.frame.size.width, 45);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  UICollectionReusableView *reusableview = nil;
  if (kind == UICollectionElementKindSectionHeader) {
    FGMyBadgesTitleCollectionHeaderView *headerView = (FGMyBadgesTitleCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
    NSDictionary *info                              = self.arr_data[indexPath.section];
    [headerView setupHeaderInfoWithTitle:info[@"title"] subTitle:info[@"subtitle"]];
    reusableview = headerView;
  }
  return reusableview;
}

#pragma mark - 按钮事件
- (void)buttonAction_removeBadgeInfoPopView:(id)sender {
  SAFE_RemoveSupreView(view_badgeInfo);
  SAFE_RemoveSupreView(view_newBadgeInfo);
  SAFE_RemoveSupreView(view_bg);
  view_bg = nil;
  view_badgeInfo = nil;
}
@end
