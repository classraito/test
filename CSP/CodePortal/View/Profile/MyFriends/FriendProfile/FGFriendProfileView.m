//
//  FGFriendProfileView.m
//  CSP
//
//  Created by JasonLu on 16/10/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//
#import "UIImage+BlurEffect.h"
#import "FGFriendProfileView.h"
#import "FGPostsFollowingCellView.h"
@interface FGFriendProfileView ()  {
  OHAttributedLabel *ml_tmp;
  NSInteger commentCursor;
  NSInteger totalComment;
  
  NSInteger totalFollow;
  NSInteger totalFollower;
  NSInteger totalPost;
}
@end
@implementation FGFriendProfileView
@synthesize tb_friendProfile;
@synthesize arr_data;
@synthesize cv_badges;
@synthesize cv_friends;
@synthesize cv_profileInfo;
@synthesize str_friendId;
@synthesize view_commentMorePopup;
@synthesize bool_isFollow;
@synthesize str_currentReportPostId;
@synthesize str_currentReportUserID;
#pragma mark - 生命周期
- (void)awakeFromNib {
  [super awakeFromNib];
  
  ml_tmp      = [[OHAttributedLabel alloc] init];
  ml_tmp.font = font(FONT_TEXT_REGULAR, 16);
  [self internalInitalView];
  [self internalNotification];
}

- (void)internalInitalView {
  [commond useDefaultRatioToScaleView:tb_friendProfile];
  // 删除多余行
  self.tb_friendProfile.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  self.arr_data = [[NSMutableArray alloc] initWithObjects:@{},@{}, nil];
  [self.tb_friendProfile reloadData];
  [self.tb_friendProfile addPullToRefreshWithActionHandler:nil];
  [self.tb_friendProfile setShowsPullToRefresh:NO];
  [self.tb_friendProfile triggerRecoveryAnimationIfNeeded];
  [self.tb_friendProfile setupLoadingMaskLayerHidden:NO withAlpha:1.0 withSpinnerHidden:NO];
  
  [self.tb_friendProfile triggerRecoveryAnimationIfNeeded];
  __weak __typeof(self) weakSelf = self;
    commentCursor = 0;
  [tb_friendProfile addInfiniteScrollingWithActionHandler:^{
    [weakSelf runRequst_getMorePostList];
  }];
  
  self.tb_friendProfile.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
    [weakSelf runRequest_getUserProfiler];
  }];
  
}

- (void)dealloc {
  self.arr_data         = nil;
  self.tb_friendProfile = nil;
  self.cv_badges        = nil;
  self.cv_friends       = nil;
  self.cv_profileInfo   = nil;
  self.str_friendId = nil;
    self.str_currentReportUserID = nil;
    self.str_currentReportPostId = nil;
  
  [self clearNotification];
  NSLog(@":::::>dealloc %s %d", __FUNCTION__, __LINE__);
}
#pragma mark - UITableViewDelegate
/*table cell高度*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.row == 0)
    return 160 * ratioH;
  else if (indexPath.row == 1)
    return 90 * ratioH;
  
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
    NSLog(@"profile cell=%@", cell);
  }
  else if (indexPath.row == 1)
    cell = [self profileMyBadgesViewCell:tableView];
  else
  {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  if (indexPath.row == 1) {
    ;
    NSLog(@"dataInfo==%@", arr_data[indexPath.row]);
    NSString *_str_id = str_friendId;
    NSString *_str_name = arr_data[0][@"username"];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGMyBadgesViewController *vc_badges = [[FGMyBadgesViewController alloc] initWithNibName:@"FGMyBadgesViewController" bundle:nil withId:_str_id name:_str_name];
    [manager pushController:vc_badges navigationController:nav_current];
  }
}

#pragma mark - 自定义cell
- (UITableViewCell *)profileInfoViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGUserProfileInfoCellView";
  FGUserProfileInfoCellView *cell     = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil)
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGUserProfileInfoCellView" owner:self options:nil] lastObject];
  return cell;
}

- (UITableViewCell *)profileMyBadgesViewCell:(UITableView *)tableView {
  static NSString *CellIdentifier = @"FGProfileMyBadgesCellView";
  FGProfileMyBadgesCellView* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil)
    cell = [[[NSBundle mainBundle] loadNibNamed:@"FGProfileMyBadgesCellView" owner:self options:nil] lastObject];
  return cell;
}

- (FGUserProfileInfoCellView *)getUserProfileViewCell {
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  return (FGUserProfileInfoCellView *)[self.tb_friendProfile cellForRowAtIndexPath:tmpIndexPath];
}

-(UITableViewCell *)giveMePostFollowingCellView:(UITableView *)_tb {
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


#pragma mark - 利用scrollView 实现顶部的一个缩放特效
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//  if (scrollView.contentOffset.y <= 0)
//  {
//    NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
//    UITableViewCell *curCell = [self.tb_friendProfile cellForRowAtIndexPath:indexPath];
//    if ([curCell isKindOfClass:[FGUserProfileInfoCellView class]]) {
//      FGUserProfileInfoCellView *cell = (FGUserProfileInfoCellView *)curCell;
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

- (void)bindDataToUI {
  
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_ProfilePage)];
  
  NSArray *_arr = _dic_result[@"Responses"];
  NSDictionary *_dic_tmp = _arr[0][@"ResponseContent"];
  NSString *_str_name =   [_dic_tmp[@"UserName"] isEmptyStr] ? multiLanguage(@"---") : _dic_tmp[@"UserName"];

  totalFollow = [_dic_tmp[@"TotalFollow"] integerValue];
  totalFollower = [_dic_tmp[@"TotalFollower"] integerValue];
  totalPost = [_dic_tmp[@"TotalPost"] integerValue];
  
  NSDictionary *_dic_post = _arr[2][@"ResponseContent"];
  NSArray *_arr_post = [NSArray arrayWithArray:_dic_post[@"Posts"]];
  self.bool_isFollow = [_dic_tmp[@"IsFollowed"] boolValue];
  
  
  //初始化头像,如果已经有头像数据了就不需要再初始化了
  NSDictionary *_dic_userAvatarInfo;
  if (self.arr_data > 0) {
      NSDictionary *_dic_profileInfos = self.arr_data[0];
      if (!ISNULLObj(_dic_profileInfos[@"isDownloadAvatar"]) &&
          [_dic_profileInfos[@"isDownloadAvatar"] boolValue]) {
        _dic_userAvatarInfo = @{@"img" : _dic_profileInfos[@"img"],
                               @"imgbg": _dic_profileInfos[@"imgbg"],
                                @"isDownloadAvatar":@YES};
      }else {
        _dic_userAvatarInfo = [FGUtils getUserAvatarInfoWithType:YES];
        //下载头像
        [self action_downloadUserAvatarWithUrl:_dic_tmp[@"UserIcon"]];
      }
  } else {
    _dic_userAvatarInfo = [FGUtils getUserAvatarInfoWithType:YES];
  }

  [self.arr_data removeAllObjects];
  NSDictionary *profileInfos = @{
                                 @"isDownloadAvatar":_dic_userAvatarInfo[@"isDownloadAvatar"],
                                 @"img" : _dic_userAvatarInfo[@"img"],
                                 @"imgbg": _dic_userAvatarInfo[@"imgbg"],
                                 @"imgUrl": _dic_tmp[@"UserIcon"],
                                 @"username" : _str_name,
                                 @"post": [NSString stringWithFormat:@"%@",_dic_tmp[@"TotalPost"]],
                                 @"follow": [NSString stringWithFormat:@"%@",_dic_tmp[@"TotalFollow"]],
                                 @"follower": [NSString stringWithFormat:@"%@",_dic_tmp[@"TotalFollower"]],
                                 @"isFollowed": [NSNumber numberWithBool:[_dic_tmp[@"IsFollowed"] boolValue]],
                                 @"id": [NSString stringWithFormat:@"%@",_dic_tmp[@"UserId"]]
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
    @"title" : multiLanguage(@"Badges"),
    @"badgesCnt" : [NSNumber numberWithInteger:(_int_gotHiddenBadges + _int_gotBadges)],//[NSNumber numberWithInteger:myBadges.count],
    @"badgesList" : myBadges
  };
  [self.arr_data addObject:myBadgesInfos];
  
  commentCursor = [_dic_post[@"Cursor"] intValue];
  totalComment = [_dic_post[@"TotalCount"] intValue];
  
  [self.arr_data addObjectsFromArray:_arr_post];

  [self.tb_friendProfile reloadData];
  [self.tb_friendProfile setupLoadingMaskLayerHidden:YES];
  [self hideFooterLoadingIfNeeded];
  [self.tb_friendProfile.mj_header endRefreshing];
}


- (void)refreshFollowStatus {
  self.bool_isFollow = !self.bool_isFollow;
  NSMutableDictionary *_mdic_profileInfos = [NSMutableDictionary dictionaryWithDictionary:self.arr_data[0]];
  _mdic_profileInfos[@"isFollowed"] = [NSNumber numberWithBool:self.bool_isFollow];
  NSInteger _int_follower = [_mdic_profileInfos[@"follower"] intValue];
  _int_follower = _int_follower + (self.bool_isFollow?1:-1);
  //刷新粉丝数量
  [_mdic_profileInfos setValue:[NSString stringWithFormat:@"%ld",_int_follower] forKey:@"follower"];
  
  [self.arr_data replaceObjectAtIndex:0 withObject:_mdic_profileInfos];
  
  NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  [self.tb_friendProfile reloadRowsAtIndexPaths:@[tmpIndexPath] withRowAnimation:UITableViewRowAnimationNone];
  
  
}

-(void)hideFooterLoadingIfNeeded {
  
  [self.tb_friendProfile.refreshFooter endRefreshing];
  if (commentCursor == -1 || totalComment == 0)
    [self.tb_friendProfile allowedShowActivityAtFooter:NO];
  else
    [self.tb_friendProfile allowedShowActivityAtFooter:YES];
}

-(void)runRequst_reloadPostList {
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:str_friendId forKey:@"Filter"];
    [_dic_info setObject:@"GetPost_reload" forKey:@"GetPost_reload"];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
    [[NetworkManager_Post sharedManager] postRequest_getPostList:str_friendId keyword:@"" cursor:0 count:10 userinfo:_dic_info];
}

-(void)runRequst_getMorePostList {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:str_friendId forKey:@"Filter"];
  [_dic_info setObject:@"GetPost_loadMore" forKey:@"GetPost_loadMore"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
  [[NetworkManager_Post sharedManager] postRequest_getPostList:str_friendId keyword:@"" cursor:commentCursor count:10 userinfo:_dic_info];
}

- (void)runRequest_getUserProfiler {
  NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
  [_dic_info setObject:str_friendId forKey:@"friendId"];
  [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];//指定了只能由当前viewController接收当前请求的数据
  [[NetworkManager_Profile sharedManager] postRequest_Profile_ProfilePageWithUserId:str_friendId postFilter:str_friendId userinfo:_dic_info];
}

-(void)reloadPosts
{
    [self.arr_data removeObjectsInRange:NSMakeRange(2, [self.arr_data count]-2)];
    [self loadMorePosts];
}


- (void)loadMorePosts {
  NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetPostList)];
  NSDictionary * _dic_post = _dic_result;
  NSArray *_arr_post = _dic_post[@"Posts"];
  
  commentCursor = [_dic_post[@"Cursor"] intValue];
  totalComment = [_dic_post[@"TotalCount"] intValue];
  
  NSArray *arr_tmp = _arr_post;
  [self.arr_data addObjectsFromArray:arr_tmp];
  [self.tb_friendProfile reloadData];
  [self hideFooterLoadingIfNeeded];
}

- (void)gotoProfilePost {
  CGFloat flt_displayHeight = (568-62) * ratioH;
  CGFloat flt_topHeight = (160 + 90) * ratioH;
  CGFloat flt_tb_contentHeight = self.tb_friendProfile.contentSize.height;
  
  if (flt_tb_contentHeight - flt_topHeight > flt_displayHeight) {
    [self.tb_friendProfile setContentOffset:CGPointMake(0, flt_topHeight) animated:YES];
  } else {
    [self.tb_friendProfile setContentOffset:CGPointMake(0, flt_tb_contentHeight-flt_displayHeight) animated:YES];
  }
}

-(void)afterDeletePost
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_DeletePost)];
    int Code = [[_dic_result objectForKey:@"Code"] intValue];
    if(Code == 0)
    {
        [self runRequst_reloadPostList];
    }
}

- (void)beginRefresh {
  [self.tb_friendProfile.mj_header beginRefreshing];
}

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
      NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":[FGUtils getUserBgImage], @"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self]};
      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATEFIRENDPAVATAR object:_dic_info];
    });
#else
    dispatch_sync(dispatch_get_main_queue(), ^{
      
      if (blurImage != nil){
        NSDictionary *_dic_info = @{@"isDownloadAvatar":@YES,@"img":_img,@"imgBlur":blurImage, @"KEY_NOTIFY_IDENTIFIER":[NetworkManager giveHashCodeByObj:self]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UPDATEFIRENDPAVATAR object:_dic_info];
      }
    });
#endif
  });
}

#pragma mark - buttonAction
-(void)buttonAction_comment:(UIButton *)_btn {
  NSInteger _index = _btn.tag - 1;
  FGControllerManager *manager = [FGControllerManager sharedManager];
  FGPostCommentDetailViewController *vc_commentDetail = [[FGPostCommentDetailViewController alloc] initWithNibName:@"FGPostCommentDetailViewController" bundle:nil postInfo:[arr_data objectAtIndex:_index]];
  [manager pushController:vc_commentDetail navigationController:nav_current];
}

-(void)buttonAction_more:(UIButton *)_btn {
    NSInteger _index = _btn.tag - 1;
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
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    [[NetworkManager_Post sharedManager] postRequest_deletePost:str_currentReportPostId userinfo:_dic_info];
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > [arr_reportContents count] - 1)
        return;
    
    [[NetworkManager_Post sharedManager] postRequest_accusePost:str_currentReportPostId content:[arr_reportContents objectAtIndex:buttonIndex] userinfo:nil];
}

-(void)internalInitalPostMoreView {
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

#pragma mark - notification
- (void)notification_updateFirendUserIconWithInfo:(id)obj {
  NSDictionary *_dic_info = [obj object];
  if(self.hash != [_dic_info[KEY_NOTIFY_IDENTIFIER] longValue])
    return;
  
  UIImage *_img_icon = _dic_info[@"img"];
  UIImage *_img_blur = _dic_info[@"imgBlur"];
  
  NSMutableDictionary *_mdic = [NSMutableDictionary dictionaryWithDictionary:self.arr_data[0]];
  [_mdic setValue:_img_blur forKey:@"imgbg"];
  [_mdic setValue:_img_icon forKey:@"img"];
  [_mdic setValue:_dic_info[@"isDownloadAvatar"] forKey:@"isDownloadAvatar"];

  [self.arr_data replaceObjectAtIndex:0 withObject:_mdic];
  [FGUtils reloadCellWithTableView:self.tb_friendProfile atIndex:0];
  FGFriendProfileViewController *_vc = (FGFriendProfileViewController *)[self viewController];
  [_vc setupFriendProfileAction];
}

- (void)internalNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_updateFirendUserIconWithInfo:) name:NOTIFICATION_UPDATEFIRENDPAVATAR object:nil];
}

- (void)clearNotification {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATEFIRENDPAVATAR object:nil];
}
@end
