//
//  FGTrainerProfileView.m
//  CSP
//
//  Created by JasonLu on 16/10/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "UIImage+BlurEffect.h"
#import "FGAlbumInfoCellView.h"
#import "FGCommentsCommonWithStarsCellView.h"
#import "FGTrainerDescriptionInfoCellView.h"
#import "FGTrainerProfileInfoCellView.h"
#import "FGTrainerProfileView.h"
#import "FGTrainingDetailCommentsTitleSectionView.h"
#import "FGUtils.h"
@interface FGTrainerProfileView () {
  UILabel *lb_tmp;
  NSInteger commentCursor;
  NSInteger totalComment;
}
@end

@implementation FGTrainerProfileView
@synthesize str_trainerId;
@synthesize arr_data;
@synthesize tb_trainerProfile;
@synthesize cv_trainerDescInfo;
@synthesize cv_albumInfo;
@synthesize view_reviewsSectionTitle;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  [self internalInitalData];
  [self internalInitalView];
  [self internalInitalReviewsTitleSectionView];
  [self internalNotification];
}

- (void)internalInitalData {
    self.arr_data                          = [[NSMutableArray alloc] initWithObjects:@[], @[], nil];
//  NSMutableArray *mArr_sectionOneInfo = [NSMutableArray array];
//  NSDictionary *_dic_userAvatarInfo = [FGUtils getUserDefaultAvatarInfo];
//  NSDictionary *profileInfos = @{
//                                 @"isDownloadAvatar": @NO,
//                                 @"img" : _dic_userAvatarInfo[@"img"],
//                                 @"imgbg": _dic_userAvatarInfo[@"imgbg"],
//                                 @"imgUrl": @"",
//                                 @"username" : @"---",
//                                 @"level" :    [NSNumber numberWithInteger:0]
//                                 };
//  [mArr_sectionOneInfo addObject:profileInfos];
//  //解析Mybadges
//  NSArray *detailInfo = [NSArray arrayWithObjects:
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:[NSString stringWithFormat:@"%@ : %@",multiLanguage(@"Introducation"), @"---"] font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:multiLanguage(@"QUALIFICATIONS") font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:@"---" font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:multiLanguage(@"SPECIALTY") font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:@"---" font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:multiLanguage(@"LANGUAGE") font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         
//                         @{ @"content" : @[
//                                [FGUtils createAttributeTextInfo:@"---" font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
//                                ]
//                            },
//                         
//                         nil];
//  [mArr_sectionOneInfo addObject:detailInfo];
//  
//  NSDictionary *imagesInfo = @{ @"images" : @[]
//                                };
//  [mArr_sectionOneInfo addObject:imagesInfo];
//  [self.arr_data replaceObjectAtIndex:0 withObject:mArr_sectionOneInfo];
}

- (void)internalInitalView {
  [commond useDefaultRatioToScaleView:tb_trainerProfile];
  // 删除多余行
  self.tb_trainerProfile.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [self.tb_trainerProfile addPullToRefreshWithActionHandler:nil];
  [self.tb_trainerProfile setShowsPullToRefresh:NO];
  [self.tb_trainerProfile triggerRecoveryAnimationIfNeeded];
  [self.tb_trainerProfile setupLoadingMaskLayerHidden:NO withAlpha:1.0 withSpinnerHidden:NO];
  
  commentCursor = 0;
  __weak __typeof(self) weakSelf = self;
  self.tb_trainerProfile.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_getTrainerProfiler];
  }];
  [tb_trainerProfile addInfiniteScrollingWithActionHandler:^{
    [weakSelf runRequst_getMoreCommentsList];
  }];

  lb_tmp               = [[UILabel alloc] init];
  lb_tmp.numberOfLines = 0;
  lb_tmp.textAlignment = NSTextAlignmentLeft;
}

- (void)internalInitalReviewsTitleSectionView {
  if (view_reviewsSectionTitle)
    return;
  view_reviewsSectionTitle = (FGTrainingDetailCommentsTitleSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingDetailCommentsTitleSectionView" owner:nil options:nil] objectAtIndex:0];
  view_reviewsSectionTitle.hidden = YES;
  [commond useDefaultRatioToScaleView:view_reviewsSectionTitle];
}

- (void)dealloc {
  self.arr_data                 = nil;
  self.tb_trainerProfile        = nil;
  self.view_reviewsSectionTitle = nil;
  self.cv_trainerDescInfo       = nil;
  lb_tmp                        = nil;
  self.cv_albumInfo             = nil;
  [self clearNotification];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0)
      return 140 * ratioH;
    else if (indexPath.row == 1) {
      return [self.cv_trainerDescInfo cellHeight];
    } else if (indexPath.row == 2)
      return 70 * ratioH;
  } else if (indexPath.section == 1) {
    NSString *str_text          = [self.arr_data[indexPath.section] objectAtIndex:indexPath.row][@"Content"];
    CGFloat _originalCellHeight = 94;                        //94是xib中cell原始高度，
    CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21); //这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
                                                             //    CGFloat cellHeight           = [FGUtils calculatorAttributeString:str_text withWidth:_originalLabelBounds.size.width].size.height;
    CGFloat cellHeight = [self calculateCellHeightByText:str_text originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds lineSpace:6 font:font(FONT_TEXT_REGULAR, 16)];
    return cellHeight;
  } //评论内容的高度
  return 90 * ratioH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
  if (section == 0)
    return 0;
  else if (section == 1)
    return view_reviewsSectionTitle.frame.size.height; //只有Comment的section
  else
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
  if (section == 0)
    return nil;
  else if (section == 1)
    return view_reviewsSectionTitle; //只有Comment的section
  else
    return nil;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.arr_data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data[section] count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  if (indexPath.section == 0) {
    if (indexPath.row == 0)
      cell = [self profileInfoViewCell:tableView];
    else if (indexPath.row == 1)
      cell = [self trainerDescInfoViewCell:tableView];
    else if (indexPath.row == 2)
      cell = [self albumInfoViewCell:tableView];
  } else if (indexPath.section == 1) {
    cell = [self giveMeCommentsCellView:tableView];
    [cell updateCellViewWithInfo:[arr_data[indexPath.section] objectAtIndex:indexPath.row]];
  } else if (indexPath.section == 1) {
    cell = [self giveMeCommentsCellView:tableView];
  }
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)]) {
    [cell updateCellViewWithInfo:arr_data[indexPath.section][indexPath.row]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
}

#pragma mark - 自定义cell
- (UITableViewCell *)profileInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGTrainerProfileInfoCellView";
  UITableViewCell *cell           = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGTrainerProfileInfoCellView" owner:self options:nil] lastObject];

  return cell;
}

- (UITableViewCell *)trainerDescInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGTrainerDescriptionInfoCellView";
  self.cv_trainerDescInfo         = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (self.cv_trainerDescInfo == nil) {
    self.cv_trainerDescInfo = [[[NSBundle mainBundle] loadNibNamed:@"FGTrainerDescriptionInfoCellView" owner:self options:nil] lastObject];
  }
  return self.cv_trainerDescInfo;
}

- (UITableViewCell *)albumInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGAlbumInfoCellView";
  self.cv_albumInfo               = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (self.cv_albumInfo == nil) {
    self.cv_albumInfo = [[[NSBundle mainBundle] loadNibNamed:@"FGAlbumInfoCellView" owner:self options:nil] lastObject];
  }
  return self.cv_albumInfo;
}

- (UITableViewCell *)giveMeCommentsCellView:(UITableView *)_tb {
  NSString *CellIdentifier                = @"FGCommentsCommonWithStarsCellView";
  FGCommentsCommonWithStarsCellView *cell = (FGCommentsCommonWithStarsCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    cell         = (FGCommentsCommonWithStarsCellView *)[nib objectAtIndex:0];
  }

  return cell;
}

#pragma mark - 利用scrollView 实现顶部的一个缩放特效
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  if (scrollView.contentOffset.y <= 0) {
//    NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *curCell = [self.tb_trainerProfile cellForRowAtIndexPath:indexPath];
//    if ([curCell isKindOfClass:[FGTrainerProfileInfoCellView class]]) {
//      FGTrainerProfileInfoCellView *cell = (FGTrainerProfileInfoCellView *)curCell;
//      CGFloat scalePercent               = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
//      CGAffineTransform _transform = (scalePercent == 0) ? CGAffineTransformIdentity : CGAffineTransformMakeScale(1 + scalePercent * 3, 1 + scalePercent * 3);
//      cell.iv_bg.transform = _transform;
//      CGRect _frame                      = cell.iv_bg.frame;
//      _frame.origin.y                    = scrollView.contentOffset.y;
//      cell.iv_bg.frame = _frame;
//    }
//  }
}

#pragma mark - 成员方法
- (void)bindDataToUI {
  //从数据中心获取信息，更新arr_data数组数据
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_TrainerDetailPage)];
  NSLog(@"trainer profile=%@",_dic_result);
  ;
  
  NSDictionary * _dic_trainerInfo = _dic_result[@"Responses"][0][@"ResponseContent"];
  float flt_level = [_dic_trainerInfo[@"Rating"] floatValue];
  NSInteger int_level = (NSInteger)floor(flt_level);
  NSMutableArray *mArr_sectionOneInfo = [NSMutableArray array];
  
  NSArray *_arr_sectionOne = self.arr_data[0];
  
  //初始化头像,如果已经有头像数据了就不需要再初始化了
  NSDictionary *_dic_userAvatarInfo;
  if (_arr_sectionOne.count > 0){
    NSDictionary *_dic_profileInfos = _arr_sectionOne[0];
    if (!ISNULLObj(_dic_profileInfos) &&
        !ISNULLObj(_dic_profileInfos[@"isDownloadAvatar"]) &&
        [_dic_profileInfos[@"isDownloadAvatar"] boolValue]) {
      _dic_userAvatarInfo = @{@"img" : _dic_profileInfos[@"img"],
                              @"imgbg": _dic_profileInfos[@"imgbg"],
                              @"isDownloadAvatar": @YES};
    } else {
      _dic_userAvatarInfo = [FGUtils getUserAvatarInfoWithType:NO];
      //下载头像
      [self action_downloadUserAvatarWithUrl:_dic_trainerInfo[@"UserIcon"]];
    }
  } else {
    _dic_userAvatarInfo = [FGUtils getUserAvatarInfoWithType:NO];
    //下载头像
    [self action_downloadUserAvatarWithUrl:_dic_trainerInfo[@"UserIcon"]];
  }
  
  NSDictionary *profileInfos = @{
                                 @"isDownloadAvatar":_dic_userAvatarInfo[@"isDownloadAvatar"],
                                 @"img" : _dic_userAvatarInfo[@"img"],
                                 @"imgbg": _dic_userAvatarInfo[@"imgbg"],
                                 @"imgUrl": _dic_trainerInfo[@"UserIcon"],
                                 @"username" : _dic_trainerInfo[@"UserName"],
                                 @"level" :    [NSNumber numberWithInteger:int_level]
                                 };
  [mArr_sectionOneInfo addObject:profileInfos];
  //解析Mybadges
  NSArray *detailInfo = [NSArray arrayWithObjects:
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:[NSString stringWithFormat:@"%@ : %@",multiLanguage(@"Introducation"), _dic_trainerInfo[@"Introducation"]] font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:multiLanguage(@"QUALIFICATIONS") font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:_dic_trainerInfo[@"Qualifications"] font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:multiLanguage(@"SPECIALTY") font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:_dic_trainerInfo[@"Specialty"] font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:20 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:multiLanguage(@"LANGUAGE") font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_lightGray paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },
                        
                                     @{ @"content" : @[
                                       [FGUtils createAttributeTextInfo:_dic_trainerInfo[@"Language"] font:font(FONT_TEXT_REGULAR, 14) color:color_homepage_black paragraphSpacing:0 lineSpacing:6 textAlignment:NSTextAlignmentLeft sepeatorByString:@"\n"]
                                     ]
                                     },

                                     nil];
  [mArr_sectionOneInfo addObject:detailInfo];

  NSDictionary *imagesInfo = @{ @"images" : _dic_trainerInfo[@"PhotoThumbnails"]
                                };
  [mArr_sectionOneInfo addObject:imagesInfo];

  [self.arr_data replaceObjectAtIndex:0 withObject:mArr_sectionOneInfo];

  
  NSDictionary * _dic_trainerCommentsInfo = _dic_result[@"Responses"][1][@"ResponseContent"];
  NSInteger _int_trainerComments = [_dic_trainerCommentsInfo[@"TotalCount"] integerValue];
  
  commentCursor = [_dic_trainerCommentsInfo[@"Cursor"] intValue];
  totalComment = [_dic_trainerCommentsInfo[@"TotalCount"] intValue];
  
  if (_int_trainerComments <= 0) {
    if (self.arr_data.count == 2)
      [self.arr_data removeObjectAtIndex:1];
  }
  else {
    NSArray *_arr = _dic_trainerCommentsInfo[@"TrainerComments"];
    NSMutableArray *mArr_reviews = [NSMutableArray array];
    
    for (int i = 0; i < _arr.count; i++) {
      NSDictionary *_dic_tmp = _arr[i];
      NSInteger _int_level = [_dic_tmp[@"Rating"] integerValue];
//      NSString * _str_commandTime = [FGUtils intervalNowBeginWith1970SecondStr:[NSString stringWithFormat:@"%@", _dic_tmp[@"CommentTime"]]];
      NSDictionary *dataInfo = @{ @"Content" : _dic_tmp[@"Comment"],
                                  @"UserIcon" : _dic_tmp[@"UserIcon"],
                                  @"UserName" : _dic_tmp[@"UserName"],
                                  @"CommandTime" : _dic_tmp[@"CommentTime"],
                                  @"level" : [NSNumber numberWithInteger:_int_level] };
      [mArr_reviews addObject:dataInfo];
    }
    if (self.arr_data.count == 2)
      [self.arr_data replaceObjectAtIndex:1 withObject:mArr_reviews];
    else {
      if (self.arr_data.count < 2) {
        [self.arr_data addObject:mArr_reviews];
      }
    }
    NSString *str_reviewsTitle                          = [NSString stringWithFormat:@"%@%@%i%@", multiLanguage(@"Reviews"), @"(", _int_trainerComments, @")"];
    self.view_reviewsSectionTitle.lb_commentsCount.text = str_reviewsTitle;
    self.view_reviewsSectionTitle.hidden = NO;
  }

  [self refreshUI];
//  [self performSelector:@selector(refreshUI) withObject:nil afterDelay:0.5f];
}

- (void)refreshUI {
  [self.tb_trainerProfile reloadData];
  [self.tb_trainerProfile setupLoadingMaskLayerHidden:YES];
  [self hideFooterLoadingIfNeeded];
  [self.tb_trainerProfile.mj_header endRefreshing];
}

- (void)loadMoreComments {
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_TrainerComments)];
  NSDictionary * _dic_post = _dic_result;
  NSArray *_arr_post = _dic_post[@"TrainerComments"];
  
  commentCursor = [_dic_post[@"Cursor"] intValue];
  totalComment = [_dic_post[@"TotalCount"] intValue];
  
  NSMutableArray *_mArr_moreReviews = [NSMutableArray array];
  NSMutableArray *_mArr_oldReviews = self.arr_data[1];
  
  for (int i = 0; i < _arr_post.count; i++) {
    NSDictionary *_dic_tmp = _arr_post[i];
    NSInteger _int_level = [_dic_tmp[@"Rating"] integerValue];
    NSString * _str_commandTime = [FGUtils intervalNowBeginWith1970SecondStr:[NSString stringWithFormat:@"%@", _dic_tmp[@"CommentTime"]]];
    NSDictionary *dataInfo = @{ @"Content" : _dic_tmp[@"Comment"],
                                @"UserIcon" : _dic_tmp[@"UserIcon"],
                                @"UserName" : _dic_tmp[@"UserName"],
                                @"CommandTime" : _str_commandTime,
                                @"level" : [NSNumber numberWithInteger:_int_level] };
    [_mArr_moreReviews addObject:dataInfo];
  }
  
  [_mArr_oldReviews addObjectsFromArray:_mArr_moreReviews];
  NSMutableArray *_marr_newReviews = [NSMutableArray arrayWithArray:_mArr_oldReviews];
  [self.arr_data replaceObjectAtIndex:1 withObject:_marr_newReviews];

  [self.tb_trainerProfile reloadData];
  [self hideFooterLoadingIfNeeded];
}

- (void)runRequest_getTrainerProfiler {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
  [[NetworkManager_Profile sharedManager] postRequest_Profile_TrainerDetailPage:str_trainerId userinfo:_dic_info];
}

-(void)runRequst_getMoreCommentsList {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:@"GetTrainerComments_loadMore" forKey:@"GetTrainerComments_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
  [[NetworkManager_Profile sharedManager] postRequest_Profile_TrainerComments:str_trainerId isFirstPage:NO count:10 cursor:commentCursor userinfo:_dic_info];
}

-(void)hideFooterLoadingIfNeeded {
  
  [self.tb_trainerProfile.refreshFooter endRefreshing];
  if (commentCursor == -1 || totalComment == 0)
    [self.tb_trainerProfile allowedShowActivityAtFooter:NO];
  else
    [self.tb_trainerProfile allowedShowActivityAtFooter:YES];
}

- (void)beginRefresh {
  self.view_reviewsSectionTitle.hidden = YES;
  [self.tb_trainerProfile.mj_header beginRefreshing];
}

#pragma mark - notification
- (void)notification_updateTrianerUserIconWithInfo:(id)obj {
  NSDictionary *_dic_info = [obj object];
  if(self.hash != [_dic_info[KEY_NOTIFY_IDENTIFIER] longValue])
    return;
  
  NSMutableArray *mArr_sectionOneInfo = [NSMutableArray arrayWithArray:self.arr_data[0]];
  UIImage *_img_icon = _dic_info[@"img"];
  UIImage *_img_blur = _dic_info[@"imgBlur"];
  
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:mArr_sectionOneInfo[0]];
  [_mdic setValue:_img_blur forKey:@"imgbg"];
  [_mdic setValue:_img_icon forKey:@"img"];
  [_mdic setValue:_dic_info[@"isDownloadAvatar"] forKey:@"isDownloadAvatar"];

  [mArr_sectionOneInfo replaceObjectAtIndex:0 withObject:_mdic];

  
  [self.arr_data replaceObjectAtIndex:0 withObject:mArr_sectionOneInfo];
  [FGUtils reloadCellWithTableView:self.tb_trainerProfile atSection:0 atIndex:0];
}

- (void)internalNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_updateTrianerUserIconWithInfo:) name:NOTIFICATION_UPDATETRAINERAVATAR object:nil];
}

- (void)clearNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATETRAINERAVATAR object:nil];
}

#pragma mark - 异步下载头像
- (void)action_downloadUserAvatarWithUrl:(NSString *)_str_url {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    UIImage *_img;
    __block UIImage *blurImage;
    if ([_str_url hasPrefix:@"http"]) {
      _img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_str_url]]];
      if (_img == nil) {
        _img = IMG_USERDEFAULTICON;
      }
      blurImage = [_img blurEffectUseGPUImageWithBlurLevel:0.15];
    }
#ifdef USELOCALDEFAULTBGIMAGE
    dispatch_sync(dispatch_get_main_queue(), ^{
      NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":[FGUtils getTrainerBgImage], @"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self]};
      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATETRAINERAVATAR object:_dic_info];
    });
#else
    dispatch_sync(dispatch_get_main_queue(), ^{
      if (blurImage != nil){
        NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":blurImage, @"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATETRAINERAVATAR object:_dic_info];
      }
    });
#endif
  });
}

#pragma mark - 其它方法
- (CGFloat)calculateCellHeightByText:(NSString *)_str_text originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame lineSpace:(CGFloat)_lineSpace font:(UIFont *)_font {
  lb_tmp.text  = _str_text;
  lb_tmp.frame = _originalLabelFrame;
  lb_tmp.font  = _font;
  [commond useDefaultRatioToScaleView:lb_tmp];
  [lb_tmp setLineSpace:_lineSpace alignment:NSTextAlignmentLeft];
  [lb_tmp sizeToFit];

  CGFloat labelHeight = lb_tmp.frame.size.height;

  CGFloat cellHeight = (_originalCellHeight - _originalLabelFrame.size.height) * ratioH + labelHeight;

  return cellHeight;
}
@end
