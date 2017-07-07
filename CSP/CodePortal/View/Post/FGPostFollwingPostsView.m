//
//  FGPostFollwingPostsView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostFollwingPostsView.h"
#import "Global.h"
#import "FGPostsFollowingCellView.h"
#import "FGPostCommentDetailViewController.h"
#import "NetworkManager_Post.h"

@interface FGPostFollwingPostsView()
{
  
   
}

@end

@implementation FGPostFollwingPostsView
@synthesize tb;
@synthesize arr_data;
@synthesize view_cameraButton;
@synthesize view_sectionTitle;
@synthesize view_commentMorePopup;
@synthesize lb_tmp;
@synthesize ml_tmp;
@synthesize commentCursor;
@synthesize totalComment;
@synthesize str_currentReportPostId;
@synthesize str_currentReportUserID;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:tb];
    tb.delegate = self;
    tb.dataSource = self;
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    
    lb_tmp = [[UILabel alloc] init];
    lb_tmp.numberOfLines = 0;
    lb_tmp.textAlignment = NSTextAlignmentLeft;
    
    ml_tmp      = [[OHAttributedLabel alloc] init];
    ml_tmp.font = font(FONT_TEXT_REGULAR, 16);

    [self internalInitalSectionTitleView];
    
    __weak __typeof(self) weakSelf = self;
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        commentCursor = 0;
        [weakSelf postRequst_getPostList];
    }];
    
    //TODO: 获取更多评论
    [tb addInfiniteScrollingWithActionHandler:^{
        [self postRequst_getMorePostList];
    }];
}

-(void)beginRefresh
{
    [tb.mj_header beginRefreshing];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
    view_cameraButton = nil;
    view_sectionTitle = nil;
    ml_tmp = nil;
    str_currentReportPostId = nil;
    str_currentReportUserID = nil;
    [commond removePhotoVideoGallery];
    [FGSharedAVPlayerLayer clearPlayerLayerModel];
}

#pragma mark - 初始化view
-(void)internalInitalSectionTitleView
{
    if(view_sectionTitle)
        return;
    view_sectionTitle = (FGPostSectionTitleView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostSectionTitleView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_sectionTitle];
    [view_sectionTitle setFollowingHighlighted];
}

#pragma mark - 利用一个已经临时的UILabel 来计算 table中 带可变高度UILabel的cellview的总高度
- (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
originalCollectionFrame:(CGRect)_originalCollectionFrame collectionImagesCount:(NSInteger)_collectionImagesCount{
    
    float cellWidth = CollectionWidth / (float)_collectionImagesCount;
    cellWidth = _collectionImagesCount == 1 ? CollectionWidth * 0.8f : cellWidth;//略微缩小1张图的 大小
    
    CGFloat collecionCellHeight =  cellWidth;
    
    CGFloat cellHeight = (_originalCellHeight - _originalLabelFrame.size.height - _originalCollectionFrame.size.height) * ratioH + _view.frame.size.height + collecionCellHeight + 15 * ratioH;
    return cellHeight;
}

- (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                    originalVideoContainerFrame:(CGRect)_originalVideoContainerFrame{
    
    CGFloat videoContainerHeight = 180 * ratioW / 1.33;//高度是根据宽度 4:3 的比例得到的
    CGFloat cellHeight = (_originalCellHeight - _originalLabelFrame.size.height - _originalVideoContainerFrame.size.height) * ratioH + _view.frame.size.height + videoContainerHeight + 15 * ratioH;
    
    
    return cellHeight;
}

- (CGFloat)sizeThatAttributeString:(NSString *)content width:(CGFloat)width {
//    [ml_tmp OHLB_setupHTMLParserWithContent:content width:width];
  [ml_tmp OHLB_setupHTMLParserWithContent:content width:width linkFont:font(FONT_TEXT_REGULAR, 17)];
  [ml_tmp OHALB_setupLineSpacing:1];
    return ml_tmp.bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0)
    {
        return 60 * ratioH;//60是FGPostCameraButtonView xib中原始高度
    }
    else if(indexPath.section == 1)
    {
        NSString *str_text = [[arr_data  objectAtIndex:indexPath.row] objectForKey:@"Content"];
        CGFloat _originalCellHeight = 123;//123是xib中cell原始高度，
        CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21);//这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
         CGRect _originalCollectionBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中CollectionView的原始高度 171是原始宽度
         CGRect _originalVideoContainerBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中videoContainer的原始高度 171是原始宽度
        NSInteger imageCount = [[[arr_data objectAtIndex:indexPath.row] objectForKey:@"Images"] count];
        NSString *_str_videoUrl = [[arr_data objectAtIndex:indexPath.row] objectForKey:@"Video"];
        if(![_str_videoUrl isEmptyStr] && imageCount <= 0)
        {
            [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
            CGFloat cellHeight = [self calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalVideoContainerFrame:_originalVideoContainerBounds];
            return cellHeight;
        }//视频cell的高度
        else
        {
            [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
            CGFloat cellHeight = [self calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalCollectionFrame:_originalCollectionBounds collectionImagesCount:imageCount];
            return cellHeight;
        }//图片cell的高度
        return 0;
        
    }//评论内容的高度
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if(section == 0 )
        return 0;
    else if(section == 1)
        return view_sectionTitle.frame.size.height;//只有Comment的section
    else
        return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if(section == 0 )
        return nil;
    else if(section == 1)
        return view_sectionTitle;//只有Comment的section
    else
        return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0)
        return 1;//视频界面只有1个row
    else
        return [arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    if(indexPath.section == 0)
    {
        cell = [self giveMeCameraButtonCellView:tableView];
    }
    else if(indexPath.section == 1)
    {
        cell = [self giveMePostFollowingCellView:tableView];
        [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
        ((FGPostsFollowingCellView *)cell).indexPathInTable = indexPath;
        ((FGPostsFollowingCellView *)cell).btn_comments.tag = indexPath.row + 1;
        ((FGPostsFollowingCellView *)cell).btn_more.tag = indexPath.row + 1;
    }
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMeCameraButtonCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGPostCameraButtonView";
    FGPostCameraButtonView *cell = (FGPostCameraButtonView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGPostCameraButtonView *)[nib objectAtIndex:0];
        
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

-(void)hideFooterLoadingIfNeeded
{
   
    [tb.refreshFooter endRefreshing];
    if (commentCursor == -1 || totalComment == 0)
        [tb allowedShowActivityAtFooter:NO];
    else
        [tb allowedShowActivityAtFooter:YES];
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

-(void)bindDataToUI
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetPostList) alias:@"GetPost"];
    [arr_data removeAllObjects];
    
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    arr_data = [NSMutableArray arrayWithArray:[_dic_result objectForKey:@"Posts"]];
    
    [tb resetNoResultView];
    if([arr_data count] == 0)
    {
        float regionHeight = tb.frame.size.height - view_cameraButton.frame.size.height - view_sectionTitle.frame.size.height;
        float regionOrigin = view_cameraButton.frame.size.height + view_sectionTitle.frame.size.height;
        float centerY = regionOrigin + regionHeight / 2;
        [tb showNoResultWithText:multiLanguage(@"No post info yet!") atCenterY:centerY];
    }

    
    [tb reloadData];
    [self hideFooterLoadingIfNeeded];
    [tb.mj_header endRefreshing];
}

- (void)loadMoreFollowing{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetPostList) alias:@"GetPost_loadMore"];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:@"Posts"]];
    [tb reloadData];
    [self hideFooterLoadingIfNeeded];
}

-(void)afterDeletePost
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_DeletePost)];
    int Code = [[_dic_result objectForKey:@"Code"] intValue];
    if(Code == 0)
    {
        [self beginRefresh];
    }
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

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > [arr_reportContents count] - 1)
        return;
    
    
    [[NetworkManager_Post sharedManager] postRequest_accusePost:str_currentReportPostId content:[arr_reportContents objectAtIndex:buttonIndex] userinfo:nil];
}


-(void)postRequst_getMorePostList
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"GetPost_loadMore" notifyOnVC:[self viewController] repelKEY:@"REPEL_POST"];
    [[NetworkManager_Post sharedManager] postRequest_getPostList:@"@" keyword:@"" cursor:commentCursor count:10 userinfo:_dic_info];
}

-(void)postRequst_getPostList
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"GetPost" notifyOnVC:[self viewController]  repelKEY:@"REPEL_POST"];
    [[NetworkManager_Post sharedManager] postRequest_getPostList:@"@" keyword:@"" cursor:commentCursor count:10 userinfo:_dic_info];
}


@end
