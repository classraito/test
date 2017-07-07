//
//  FGProfileHomeView.m
//  CSP
//
//  Created by JasonLu on 16/10/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//


#import "UIImage+BlurEffect.h"
#import "FGMyBadgesViewController.h"
#import "FGProfileHomeView.h"
#import "FGProfileInfoCellView.h"
#import "FGProfileMyBadgesCellView.h"
#import "FGProfileSettingCellView.h"
#import "UIScrollView+FGRereshHeader.h"
#import "FGPostsFollowingCellView.h"
#import "FGProfileViewController.h"


@interface FGProfileHomeView ()  {
  OHAttributedLabel *ml_tmp;
  NSInteger commentCursor;
  NSInteger totalComment;
  
  NSInteger totalFollow;
  NSInteger totalFollower;
  NSInteger totalPost;
    NSString *str_mybooking;
}
@end

@implementation FGProfileHomeView
@synthesize arr_data;
@synthesize tb_profileHome;
@synthesize view_commentMorePopup;
@synthesize str_currentReportPostId;
@synthesize str_currentReportUserID;
@synthesize currentSelectedRow;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  ml_tmp      = [[OHAttributedLabel alloc] init];
  ml_tmp.font = font(FONT_TEXT_REGULAR, 16);
  
    if(![commond isUser])
        str_mybooking = [multiLanguage(@"Manage booking") mutableCopy];
    else
        str_mybooking = [multiLanguage(@"My booking") mutableCopy];
    
  [self internalInitalTitleProfileHomeView];
  [self internalNotification];
    
   
}

- (void)internalInitalTitleProfileHomeView {
  [commond useDefaultRatioToScaleView:tb_profileHome];
  [self internalData];
  
  
  [self.tb_profileHome triggerRecoveryAnimationIfNeeded];
  __weak __typeof(self) weakSelf = self;
  commentCursor = 0;
  [tb_profileHome addInfiniteScrollingWithActionHandler:^{
    
    [weakSelf runRequst_getMorePostList];
  }];
  
  self.tb_profileHome.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_getUserProfile];
  }];
}

- (void)internalData {
  self.arr_data = [[NSMutableArray alloc] init];
  
  NSDictionary *_dic_userAvatarInfo = [FGUtils getUserAvatarInfo];
  
  
  NSDictionary *profileInfos = @{
                                 @"otherInfo":@{@"status":@0},
                                 @"isDownloadAvatar": @NO,
                                 @"img" : _dic_userAvatarInfo[@"img"],
                                 @"imgbg": _dic_userAvatarInfo[@"imgbg"],
                                 @"imgUrl" : @"",
                                 @"username" : @"-------",
                                 @"post": @"--",
                                 @"follow": @"--",
                                 @"follower": @"--",
                                 @"invitationCode":@"-------",
                                 @"percent": [NSNumber numberWithFloat:0]
                                 };
  [self.arr_data addObject:profileInfos];
  
  //解析Mybadges
  NSArray *myBadges     = @[
  @{@"Thumbnail":@"dot"},
  @{@"Thumbnail":@"dot"},
  @{@"Thumbnail":@"dot"},
  @{@"Thumbnail":@"dot"},
  @{@"Thumbnail":@"dot"},
  @{@"Thumbnail":@"more_dot"}];
  NSDictionary *myBadgesInfos = @{
                                  @"title" : multiLanguage(@"My badges"),
                                  @"badgesCnt" : @"--",
                                  @"badgesList" : myBadges
                                  };
  
  [self.arr_data addObject:myBadgesInfos];
  
  NSDictionary *otherInfos = @{
                               str_mybooking : @{
                                   @"img" : @"booking.png",
                                   @"title" : str_mybooking,
                                   @"number": [NSNumber numberWithInteger:[commond getBookingCnt]]
                                   },
                               multiLanguage(@"Working log") : @{
                                   @"img" : @"log.png",
                                   @"title" : multiLanguage(@"Working log")
                                   },
                               multiLanguage(@"Saved workouts") : @{
                                   @"img" : @"saved.png",
                                   @"title" : multiLanguage(@"Saved workouts")
                                   },
                               multiLanguage(@"My Group") : @{
                                   @"img" : @"mygroup.png",
                                   @"title" : multiLanguage(@"My Group")
                                   },
                               multiLanguage(@"Fitness level test") : @{
                                   @"img" : @"test.png",
                                   @"title" : multiLanguage(@"Fitness level test")
                                   },
                               multiLanguage(@"Setting") : @{
                                   @"img" : @"psetting.png",
                                   @"title" : multiLanguage(@"Setting")
                                   },
                               };
  [self.arr_data addObject:otherInfos];
  [self.tb_profileHome reloadData];
}

- (void)dealloc {
  self.arr_data       = nil;
  self.tb_profileHome = nil;
    str_mybooking = nil;
  self.str_currentReportUserID = nil;
  ml_tmp = nil;
  str_currentReportPostId = nil;
  [self clearNotification];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}


#pragma mark - 更新notifcation
- (void)internalNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_updateUserProfileInfo:) name:NOTIFICATION_REFRESHPROFILE object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_updateUserIconWithInfo:) name:NOTIFICATION_UPDATEUSERAVATAR object:nil];
}

- (void)clearNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REFRESHPROFILE object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATEUSERAVATAR object:nil];
}

- (void)notification_updateUserIconWithInfo:(id)obj {
  NSDictionary *_dic_info = [obj object];
  if(self.hash != [_dic_info[KEY_NOTIFY_IDENTIFIER] longValue])
    return;
  
  UIImage *_img_icon = _dic_info[@"img"];
  UIImage *_img_blur = _dic_info[@"imgBlur"];

  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.arr_data[0]];
  [_mdic setValue:_img_blur forKey:@"imgbg"];
  [_mdic setValue:_img_icon forKey:@"img"];
  [_mdic setValue:_dic_info[@"isDownloadAvatar"] forKey:@"isDownloadAvatar"];
  [_mdic setValue:_dic_info[@"otherInfo"] forKey:@"otherInfo"];
  
  [self.arr_data replaceObjectAtIndex:0 withObject:_mdic];
  [FGUtils reloadCellWithTableView:self.tb_profileHome atSection:0 atIndex:0];
  FGProfileViewController *vc_home = (FGProfileViewController *)[self viewController];
  [vc_home setupProfileHomeViewAction];
}

- (void)internalDownloadAvatar {
  if (self.arr_data.count > 0) {
    if ([self.arr_data[0] isKindOfClass:[NSDictionary class]]) {
      NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.arr_data[0]];
      [_mdic setValue:@YES forKey:@"isDownloadAvatar"];
      [_mdic setValue:@{@"status":@2} forKey:@"otherInfo"];

      
      [self.arr_data replaceObjectAtIndex:0 withObject:_mdic];
      [FGUtils reloadCellWithTableView:self.tb_profileHome atSection:0 atIndex:0];
    }
  }
}

- (void)beginReresh {
  [self internalDownloadAvatar];
  [self.tb_profileHome.mj_header beginRefreshing];
}

- (void)notification_updateUserProfileInfo:(id)sender {
  [self.tb_profileHome.mj_header beginRefreshing];
}

#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 160 * ratioH;
  else if (indexPath.row == 1)
    return 90 * ratioH;
  else if (indexPath.row == 2) {
#ifdef NOVIDEOSECTION
    return 108 * ratioH;
#else
    return 206 * ratioH;
#endif
    
  }
  
  NSString *str_text = [[arr_data  objectAtIndex:indexPath.row] objectForKey:@"Content"];
  CGFloat _originalCellHeight = 123;//123是xib中cell原始高度，
  CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21);//这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
  CGRect _originalCollectionBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中CollectionView的原始高度 171是原始宽度
  CGRect _originalVideoContainerBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中videoContainer的原始高度 171是原始宽度
  NSInteger imageCount = [[[arr_data objectAtIndex:indexPath.row] objectForKey:@"Images"] count];
  NSString *_str_videoUrl = [[arr_data objectAtIndex:indexPath.row] objectForKey:@"Video"];
  if(![_str_videoUrl isEmptyStr] && imageCount <= 0)
  {
    [ml_tmp sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW fontsize:16 lineSpacing:1];
    CGFloat cellHeight = [FGUtils calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalVideoContainerFrame:_originalVideoContainerBounds];
    return cellHeight;
  }
  else
  {
    [ml_tmp sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW fontsize:16 lineSpacing:1];
    CGFloat cellHeight = [FGUtils calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalCollectionFrame:_originalCollectionBounds collectionImagesCount:imageCount];
    return cellHeight;
  }
  return 0;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.arr_data count]; //[arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = nil;
  if (indexPath.row == 0) {
    cell = [self profileInfoViewCell:tableView];
    ;
  } else if (indexPath.row == 1) {
    cell = [self profileMyBadgesViewCell:tableView];
  } else if (indexPath.row == 2) {
#ifdef NOVIDEOSECTION
    cell = [self profileSettingViewCellV1:tableView];

#else
    cell = [self profileSettingViewCell:tableView];
#endif
  } else {
    cell = [self giveMePostFollowingCellView:tableView];
    ((FGPostsFollowingCellView *)cell).indexPathInTable = indexPath;
    ((FGPostsFollowingCellView *)cell).btn_comments.tag = indexPath.row + 1;
    ((FGPostsFollowingCellView *)cell).btn_more.tag = indexPath.row + 1;
  }
  
  if ([cell respondsToSelector:@selector(updateCellViewWithInfo:)] &&
      [arr_data[indexPath.row] isKindOfClass:[NSDictionary class]]) {
    [cell updateCellViewWithInfo:arr_data[indexPath.row]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
  if (indexPath.row == 1) {
    //go to badges
    NSString *_str_id = [NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGMyBadgesViewController *vc_badges = [[FGMyBadgesViewController alloc] initWithNibName:@"FGMyBadgesViewController" bundle:nil withId:_str_id];
    [manager pushController:vc_badges navigationController:nav_current];
  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)profileInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGProfileInfoCellView";
  FGProfileInfoCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGProfileInfoCellView" owner:self options:nil] lastObject];
  }
  return cell;
}

- (UITableViewCell *)profileMyBadgesViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGProfileMyBadgesCellView";
  FGProfileMyBadgesCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGProfileMyBadgesCellView" owner:self options:nil] lastObject];
  }
  return cell;
}

- (UITableViewCell *)profileSettingViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGProfileSettingCellView";
  FGProfileSettingCellView *cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGProfileSettingCellView" owner:self options:nil] lastObject];
  }
  return cell;
}

- (UITableViewCell *)profileSettingViewCellV1:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGProfileSettingCellView_v1";
  FGProfileSettingCellView_v1 *cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGProfileSettingCellView_v1" owner:self options:nil] lastObject];
  }
  return cell;
}

-(UITableViewCell *)giveMePostFollowingCellView:(UITableView *)_tb
{
  NSString *CellIdentifier = @"FGPostsFollowingCellView";
  FGPostsFollowingCellView *cell = (FGPostsFollowingCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    cell = (FGPostsFollowingCellView *)[nib objectAtIndex:0];
  }
  
  [cell.btn_comments addTarget:self action:@selector(buttonAction_comment:) forControlEvents:UIControlEventTouchUpInside];
  [cell.btn_more addTarget:self action:@selector(buttonAction_more:) forControlEvents:UIControlEventTouchUpInside];
  
  
  return cell;
}

- (FGProfileSettingCellView *)getProfileSettingViewCell {
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:2 inSection:0];
  return (FGProfileSettingCellView *)[self.tb_profileHome cellForRowAtIndexPath:tmpIndexPath];
}

- (FGProfileInfoCellView *)getProfileInfoViewCell {
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  return (FGProfileInfoCellView *)[self.tb_profileHome cellForRowAtIndexPath:tmpIndexPath];
}

- (FGProfileMyBadgesCellView *)getProfileMyBadgesViewCell {
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
  return (FGProfileMyBadgesCellView *)[self.tb_profileHome cellForRowAtIndexPath:tmpIndexPath];
}

#pragma mark - 利用scrollView 实现顶部的一个缩放特效
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //  if (scrollView.contentOffset.y < 0) {
  //    NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
  //    UITableViewCell *curCell = [self.tb_profileHome cellForRowAtIndexPath:indexPath];
  //    if ([curCell isKindOfClass:[FGProfileInfoCellView class]]) {
  //      FGProfileInfoCellView *cell = (FGProfileInfoCellView *)curCell;
  //      CGFloat scalePercent        = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
  //      cell.transform              = CGAffineTransformMakeScale(1 + scalePercent * 3, 1 + scalePercent * 3);
  //      CGRect _frame               = cell.frame;
  //      _frame.origin.y             = scrollView.contentOffset.y;
  //      cell.frame                  = _frame;
  //    }
  //  }
  //  else {
  //    [self recoverTopInfoCellPosition];
  //  }
}

#pragma mark - buttonAction
-(void)buttonAction_comment:(UIButton *)_btn
{
  NSInteger _index = _btn.tag - 1;
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGPostCommentDetailViewController *vc_commentDetail = [[FGPostCommentDetailViewController alloc] initWithNibName:@"FGPostCommentDetailViewController" bundle:nil postInfo:[arr_data objectAtIndex:_index]];
  [manager pushController:vc_commentDetail navigationController:nav_current];
}

-(void)buttonAction_more:(UIButton *)_btn
{
  NSInteger _index = _btn.tag - 1;
  currentSelectedRow = (int)_index;
  str_currentReportPostId = [[arr_data objectAtIndex:_index] objectForKey:@"PostId"];
  str_currentReportUserID = [[arr_data objectAtIndex:_index] objectForKey:@"UserId"];
  [self internalInitalPostMoreView];
}

-(void)buttonAction_commentMore_report:(UIButton *)_sender
{
  SAFE_RemoveSupreView(view_commentMorePopup);
  view_commentMorePopup = nil;
  [commond showReportActionSheet:self showInView:self];
}

-(void)buttonAction_commentMore_cancel:(id)_sender
{
  SAFE_RemoveSupreView(view_commentMorePopup);
  view_commentMorePopup = nil;
}

-(void)buttonAction_commentMore_delete:(id)_sender
{
  SAFE_RemoveSupreView(view_commentMorePopup);
  view_commentMorePopup = nil;
  
  [arr_data removeObjectAtIndex:currentSelectedRow];
  [tb_profileHome beginUpdates];
  [tb_profileHome deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:currentSelectedRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
  [tb_profileHome endUpdates];
  [tb_profileHome reloadData];
  
  NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
  [[NetworkManager_Post sharedManager] postRequest_deletePost:str_currentReportPostId userinfo:_dic_info];
  
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if(buttonIndex > [arr_reportContents count] - 1)
    return;
  
  [[NetworkManager_Post sharedManager] postRequest_accusePost:str_currentReportPostId content:[arr_reportContents objectAtIndex:buttonIndex] userinfo:nil];
}

-(void)internalInitalPostMoreView
{
  if(view_commentMorePopup)
    return;
  view_commentMorePopup = (FGPostCommentMorePopupView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostCommentMorePopupView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_commentMorePopup];
  [appDelegate.window addSubview:view_commentMorePopup];
    [appDelegate.window bringSubviewToFront:view_commentMorePopup];
    [commond dismissKeyboard:appDelegate.window];
  [view_commentMorePopup.cb_repoert.button addTarget:self action:@selector(buttonAction_commentMore_report:) forControlEvents:UIControlEventTouchUpInside];
  [view_commentMorePopup.cb_cancel.button addTarget:self action:@selector(buttonAction_commentMore_cancel:) forControlEvents:UIControlEventTouchUpInside];
  
  
  NSString *_str_userid = (NSString *)[commond getUserDefaults:KEY_API_USER_USERID];
  view_commentMorePopup.cb_deletePost.hidden = YES;
  if(_str_userid && ![_str_userid isEmptyStr])
  {
    if([_str_userid isEqualToString:str_currentReportUserID])
    {
      view_commentMorePopup.cb_deletePost.hidden = NO;
      [view_commentMorePopup.cb_deletePost.button addTarget:self action:@selector(buttonAction_commentMore_delete:) forControlEvents:UIControlEventTouchUpInside];
    }
  }
}

-(void)runRequst_getMorePostList
{
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:@"@" forKey:@"Filter"];
  [_dic_info setObject:@"GetPost_loadMore" forKey:@"GetPost_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
  NSString *_str_userID = (NSString *)[commond getUserDefaults:KEY_API_USER_USERID];
  [[NetworkManager_Post sharedManager] postRequest_getPostList:_str_userID keyword:@"" cursor:commentCursor count:10 userinfo:_dic_info];
}

- (void)loadMorePosts {
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetPostList)];
  
  NSDictionary * _dic_post = _dic_result;
  NSArray *_arr_post = _dic_post[@"Posts"];
  
  commentCursor = [_dic_post[@"Cursor"] intValue];
  totalComment = [_dic_post[@"TotalCount"] intValue];
  
  NSArray *arr_tmp = _arr_post;
  [self.arr_data addObjectsFromArray:arr_tmp];
  [self.tb_profileHome reloadData];
  [self hideFooterLoadingIfNeeded];
  
}

- (void)runRequest_getUserProfile {
  NSString * _str_friendId = (NSString *)[commond getUserDefaults:KEY_API_USER_USERID];
  [[NetworkManager_Profile sharedManager] postRequest_Profile_ProfilePage:_str_friendId userinfo:[NSMutableDictionary dictionaryWithDictionary:@{@"userId":[NSString stringWithFormat:@"%@",[commond getUserDefaults:KEY_API_USER_USERID]]}]];
}

-(void)afterDeletePost
{
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_DeletePost)];
  int Code = [[_dic_result objectForKey:@"Code"] intValue];
  if(Code == 0)
  {
    
  }
}
#pragma mark - 成员方法
- (BOOL)hasNoFollowList {
  if (totalFollow > 0)
    return NO;
  return YES;
}

- (BOOL)hasNoFollowerList {
  if (totalFollower > 0)
    return NO;
  return YES;
}

- (BOOL)hasNoPostList {
  if (totalPost > 0)
    return NO;
  return YES;
}

- (void)reload {
  [self.tb_profileHome reloadData];
}

- (void)bindDataToUI {
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_ProfilePage)];
  ;
    NSLog(@"_dic_result = %@",_dic_result);
  NSArray *_arr = _dic_result[@"Responses"];
  NSDictionary *_dic_tmp = _arr[0][@"ResponseContent"];
  NSString *_str_name =   [_dic_tmp[@"UserName"] isEmptyStr] ? multiLanguage(@"---") : _dic_tmp[@"UserName"];
  
  
  NSDictionary *_dic_post = _arr[2][@"ResponseContent"];
  commentCursor = [_dic_post[@"Cursor"] intValue];
  totalComment = [_dic_post[@"TotalCount"] intValue];
  
  totalFollow = [_dic_tmp[@"TotalFollow"] integerValue];
  totalFollower = [_dic_tmp[@"TotalFollower"] integerValue];
  totalPost = [_dic_tmp[@"TotalPost"] integerValue];
  
  NSArray *_arr_post = [NSArray arrayWithArray:_dic_post[@"Posts"]];
  //计算资料完成度
  CGFloat _float_percent = [self userProfileCompletePercentWithProfile:_dic_tmp];
  
  NSDictionary *_dic_userAvatarInfo = [FGUtils getUserAvatarInfo];
  
  
  NSDictionary *_dic_profileInfos = self.arr_data[0];
  if (!ISNULLObj(_dic_profileInfos[@"isDownloadAvatar"]) &&
      [_dic_profileInfos[@"isDownloadAvatar"] boolValue]) {
    _dic_userAvatarInfo = @{@"img" : _dic_profileInfos[@"img"],
                            @"imgbg": _dic_profileInfos[@"imgbg"],
                            @"isDownloadAvatar":@YES};
    NSInteger _int_status = [_dic_profileInfos[@"otherInfo"][@"status"] integerValue];
    if (_int_status == 2) {
      // 需要重新更新头像
      [self action_downloadUserAvatarWithUrl:_dic_tmp[@"UserIcon"]];
    }
  }
  else {
    _dic_userAvatarInfo = [FGUtils getUserDefaultAvatarInfo];
    //下载头像
    [self action_downloadUserAvatarWithUrl:_dic_tmp[@"UserIcon"]];
  }
  
  
  
  [self.arr_data removeAllObjects];
  NSDictionary *profileInfos = @{
                                 @"otherInfo":@{},
                                 @"isDownloadAvatar": _dic_userAvatarInfo[@"isDownloadAvatar"],
                                 @"img" : _dic_userAvatarInfo[@"img"],
                                 @"imgbg": _dic_userAvatarInfo[@"imgbg"],
                                 @"imgUrl" : _dic_tmp[@"UserIcon"],
                                 @"username" : _str_name ? _str_name : @"",
                                 @"post": [NSNumber numberWithInteger:[_dic_tmp[@"TotalPost"] integerValue]],
                                 @"follow": [NSNumber numberWithInteger:[_dic_tmp[@"TotalFollow"] integerValue]],
                                 @"follower": [NSNumber numberWithInteger:[_dic_tmp[@"TotalFollower"] integerValue]],
                                 @"invitationCode":_dic_tmp[@"InvitationCode"],
                                 @"percent": [NSNumber numberWithFloat:_float_percent]
                                 };
  [self.arr_data addObject:profileInfos];
  
  //解析Mybadges
  NSDictionary *_dic_badges = _arr[1][@"ResponseContent"];
  NSArray *myBadges     = [NSArray arrayWithArray:_dic_badges[@"Badges"]];
  
  NSInteger _int_gotBadges = 0;
  for (NSDictionary *_dic_badgesInfo in myBadges) {
    if ([_dic_badgesInfo[@"GotTime"] integerValue] != 0 ) {
      _int_gotBadges++;
    }
  }
  NSArray *_arr_hiddenBadges     = [NSArray arrayWithArray:_dic_badges[@"HiddenBadges"]];
  NSInteger _int_gotHiddenBadges = 0;
  for (NSDictionary *_dic_badgesInfo in _arr_hiddenBadges) {
    if ([_dic_badgesInfo[@"GotTime"] integerValue] != 0 ) {
      _int_gotHiddenBadges++;
    }
  }
  
  NSDictionary *myBadgesInfos = @{
                                  @"title" : multiLanguage(@"My badges"),
                                  @"badgesCnt" : [NSNumber numberWithInteger:(_int_gotHiddenBadges + _int_gotBadges)],//[NSNumber numberWithInteger:myBadges.count],
                                  @"badgesTotal": _dic_badges[@"TotalCount"],
                                  @"badgesGet":   _dic_badges[@"TotalGet"],
                                  @"badgesList" : myBadges
                                  };
  
  [self.arr_data addObject:myBadgesInfos];
  
  
  //获取booking数量
//  [commond saveBookingCntWithCnt:arc4random()%200];
  
  NSDictionary *otherInfos = @{
                               str_mybooking : @{
                                   @"img" : @"booking.png",
                                   @"title" : str_mybooking,
                                   @"number": [NSNumber numberWithInteger:[commond getBookingCnt]]
                                   },
                               multiLanguage(@"Working log") : @{
                                   @"img" : @"log.png",
                                   @"title" : multiLanguage(@"Working log")
                                   },
                               multiLanguage(@"Saved workouts") : @{
                                   @"img" : @"saved.png",
                                   @"title" : multiLanguage(@"Saved workouts")
                                   },
                               multiLanguage(@"My Group") : @{
                                   @"img" : @"mygroup.png",
                                   @"title" : multiLanguage(@"My Group")
                                   },
                               multiLanguage(@"Fitness level test") : @{
                                   @"img" : @"test.png",
                                   @"title" : multiLanguage(@"Fitness level test")
                                   },
                               multiLanguage(@"Setting") : @{
                                   @"img" : @"psetting.png",
                                   @"title" : multiLanguage(@"Setting")
                                   },
                               };
  [self.arr_data addObject:otherInfos];
  
  [self.arr_data addObjectsFromArray:_arr_post];
  [self.tb_profileHome.mj_header endRefreshing];
  [self.tb_profileHome reloadData];
  [self hideFooterLoadingIfNeeded];
  [self scrollViewDidScroll:tb_profileHome];
  
  [self recoverTopInfoCellPosition];
}

- (void)refreshBookingBadgeNumber {
  NSInteger _int_badgeNumber = [commond getBookingCnt];
  NSMutableDictionary *_mdic_otherInfos = [NSMutableDictionary dictionaryWithDictionary:self.arr_data[2]];
  NSMutableDictionary *_mdic_bookingInfo = [NSMutableDictionary dictionaryWithDictionary:_mdic_otherInfos[str_mybooking]];
  [_mdic_bookingInfo setValue:[NSNumber numberWithInteger:_int_badgeNumber] forKey:@"number"];

  [_mdic_otherInfos setValue:_mdic_bookingInfo forKey:str_mybooking];
  [self.arr_data replaceObjectAtIndex:2 withObject:_mdic_otherInfos];
  [FGUtils reloadCellWithTableView:self.tb_profileHome atIndex:2];
}

- (void)gotoProfilePost {
  CGFloat flt_displayHeight = (568-62-50) * ratioH;
  CGFloat flt_topHeight = (160 + 90 + 206) * ratioH;
  CGFloat flt_tb_contentHeight = self.tb_profileHome.contentSize.height;
  
  if (flt_tb_contentHeight - flt_topHeight > flt_displayHeight) {
    [self.tb_profileHome setContentOffset:CGPointMake(0, flt_topHeight) animated:YES];
  } else {
    [self.tb_profileHome setContentOffset:CGPointMake(0, flt_tb_contentHeight-flt_displayHeight) animated:YES];
  }
}

- (void)recoverTopInfoCellPosition {
  FGProfileInfoCellView *cv_top = [self getProfileInfoViewCell];
  if (cv_top) {
    cv_top.transform                    = CGAffineTransformMakeScale(1, 1);
    CGRect _frame                     = cv_top.frame;
    _frame.origin.y                   = self.tb_profileHome.contentOffset.y;
    cv_top.frame                        = CGRectMake(0, 0, _frame.size.width, _frame.size.height);
  }
}

-(void)hideFooterLoadingIfNeeded {
  
  [self.tb_profileHome.refreshFooter endRefreshing];
  if (commentCursor == -1 || totalComment == 0)
    [self.tb_profileHome allowedShowActivityAtFooter:NO];
  else
    [self.tb_profileHome allowedShowActivityAtFooter:YES];
}

-(void)updateLikeStatusByPostId:(NSString *)_postId isLike:(BOOL)_isLike likes:(int)_likes
{
    [[FGPostLikesCommentsSyncModel sharedModel] setLikes:_likes byPostId:_postId];//POSTSYNC:
    [[FGPostLikesCommentsSyncModel sharedModel] setIsLike:_isLike byPostId:_postId];//POSTSYNC:
  int index = 0;
  for(NSMutableDictionary *_dic_info in arr_data)
  {
    NSString *_str_postId = [_dic_info objectForKey:@"PostId"];
    if([_str_postId isEqualToString:_postId])
    {
      [[arr_data objectAtIndex:index] setObject:@(_isLike) forKey:@"IsLike"];
      [[arr_data objectAtIndex:index] setObject:@(_likes) forKey:@"Like"];
      break;
    }
    index ++;
  }
}

- (CGFloat)userProfileCompletePercentWithProfile:(NSDictionary *)_dic_userInfo {
  __block NSInteger _int_cnt = 0;
  __block NSInteger _int_totalCnt = 0;
  [_dic_userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    if ([key isEqualToString:@"Msg"] ||
        [key isEqualToString:@"InvitationCode"] ||
        [key isEqualToString:@"Code"] ||
        [key isEqualToString:@"NewUser"] ||
        [key isEqualToString:@"Role"] ||
        [key isEqualToString:@"TotalFollow"] ||
        [key isEqualToString:@"TotalFollower"] ||
        [key isEqualToString:@"TotalPost"] ||
        [key isEqualToString:@"IsFollowed"] ||
        [key isEqualToString:@"UserId"] ||
        [key isEqualToString:@"accessToken"]) {
      ;
    }
    else {
      if ([obj isKindOfClass:[NSString class]]){
        NSString * _str_tmp = (NSString *)obj;
        if (![_str_tmp isEmptyStr]) {
          _int_cnt++;
        }
      } else if ([obj isKindOfClass:[NSNumber class]]){
        if ([key isEqualToString:@"Gender"]) {
          _int_cnt++;
        } else {
          int _int_tmp = [obj intValue];
          if (_int_tmp > 0) {
            _int_cnt++;
          }
        }
      }
      _int_totalCnt++;
    }
  }];
  
  return _int_cnt * 1.0 / _int_totalCnt;
}

- (void)action_downloadUserAvatarWithUrl:(NSString *)_str_url {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    __block UIImage *_img;
    __block UIImage *_blurImage;
    if ([_str_url hasPrefix:@"http"]) {
      _img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_str_url]]];
      if (_img == nil) {
        _img = IMG_USERDEFAULTICON;
      }
      _blurImage = [_img blurEffectUseGPUImageWithBlurLevel:0.15];
    }
#ifdef USELOCALDEFAULTBGIMAGE
    dispatch_sync(dispatch_get_main_queue(), ^{
      NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":[FGUtils getUserBgImageUseType], @"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self]};
      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATEUSERAVATAR object:_dic_info];
    });
#else
    dispatch_sync(dispatch_get_main_queue(), ^{
      if (_blurImage != nil){
        //        NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":blurImage, @"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self]};
        //        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATETRAINERAVATAR object:_dic_info];
        //保存本地
        [FGUtils saveDocumentsFilePNGWithName:USERAVATARBLURBG fileData:[FGUtils getDataWithImage:_blurImage]];
        [FGUtils saveDocumentsFilePNGWithName:USERAVATAR fileData:[FGUtils getDataWithImage:_img]];
        
        NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":_blurImage,@"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self],@"otherInfo":@{@"status":@1}};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATEUSERAVATAR object:_dic_info];
      }
    });
#endif
  });
}
@end
