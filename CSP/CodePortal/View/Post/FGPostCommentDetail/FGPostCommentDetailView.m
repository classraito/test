//
//  FGPostCommentDetailView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostCommentDetailView.h"
#import "Global.h"
#import "FGPostsFollowingCellView.h"
#import "FGCommentsCommonCellView.h"
#import "FGPostsCommonCellView.h"
#import "NetworkManager_Post.h"
@interface FGPostCommentDetailView()
{
    NSString *str_postId;
    OHAttributedLabel *ml_tmp;
    NSInteger commentCursor;
    NSInteger totalComment;
}
@end

@implementation FGPostCommentDetailView
@synthesize tb;
@synthesize arr_commentData;
@synthesize dic_postData;
@synthesize view_commentTitle;
@synthesize view_dialog;
@synthesize currentSelectedIndexPath;
@synthesize str_currentSelectedCommentID;
@synthesize str_currentSelectedCommentUserID;
@synthesize str_currentSelectedPostID;
@synthesize view_commentMorePopup;
@synthesize moreButtonType;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:tb];
    
   
    arr_commentData = [[NSMutableArray alloc] initWithCapacity:1];
   
    
    ml_tmp      = [[OHAttributedLabel alloc] init];
    ml_tmp.font = font(FONT_TEXT_REGULAR, 16);
    
    commentCursor = 0;
    
    [self internalInitalCommentTitleView];
    
    __weak typeof(self) weakSelf = self;
    tb.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        commentCursor = 0;
        [weakSelf postRequest_getPostCommentList];
    }];
    
   
    //TODO: 获取更多评论
    [tb addInfiniteScrollingWithActionHandler:^{
        [weakSelf postRequest_getMorePostCommentList];
        
    }];
}

-(void)setupPostId:(NSString *)_str_postId
{
    str_postId = nil;
    str_postId = [_str_postId mutableCopy];
   
    [self.tb.mj_header beginRefreshing];
    

}

-(void)clearMemory
{
    view_dialog.delegate = nil;
    [view_dialog clearMemory];
    view_dialog = nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_commentData = nil;
    dic_postData = nil;
    ml_tmp = nil;
    str_postId = nil;
}

-(void)internalInitalCommentTitleView
{
    if(view_commentTitle)
        return;
    view_commentTitle = (FGTrainingDetailCommentsTitleSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingDetailCommentsTitleSectionView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_commentTitle];
}

- (void)internalInitalDialogView {
    if (view_dialog)
        return;
    view_dialog = (FGDialogTextInputView *)[[[NSBundle mainBundle] loadNibNamed:@"FGDialogTextInputView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_dialog];
    CGRect _frame     = view_dialog.frame;
    _frame.origin.y   = self.frame.size.height - _frame.size.height;
    view_dialog.frame = _frame;
    [self addSubview:view_dialog];
    [view_dialog setPlaceholderText:multiLanguage(@"Write a comment")];
    [view_dialog setupUI];
    view_dialog.delegate = self;
    
    _frame             = tb.frame;
    _frame.size.height = self.frame.size.height - view_dialog.frame.size.height;
    tb.frame           = _frame;
    
    if([arr_commentData count] == 0)
    {
//      [view_dialog.textView performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:.25];
    }
    
    [view_dialog.textView setupWithSpecialPattern:@"@" withActionHandler:^{
        [commond presentUserPickViewFromController:[self viewController] listType:ListType_User];
    }];
    [view_dialog.textView setupWithSpecialPattern:@"#" withActionHandler:^{
        [commond presentUserPickViewFromController:[self viewController] listType:ListType_Topic];
    }];
}


#pragma mark - 利用一个已经临时的UILabel 来计算 table中 带可变高度UILabel的cellview的总高度
- (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame
                    originalCollectionFrame:(CGRect)_originalCollectionFrame collectionImagesCount:(NSInteger)_collectionImagesCount
{
    CGFloat collecionCellHeight;
    
    if(_collectionImagesCount == 0)
    {
        collecionCellHeight = 0;
    }
    else
    {
        float cellWidth = CollectionWidth / (float)_collectionImagesCount;
        cellWidth = _collectionImagesCount == 1 ? CollectionWidth * 0.8f : cellWidth;//略微缩小1张图的 大小
        
        collecionCellHeight =  cellWidth;
    }
    
    
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
    [ml_tmp OHLB_setupHTMLParserWithContent:content width:width linkFont:font(FONT_TEXT_REGULAR, 17) normalFont:font(FONT_TEXT_REGULAR, 16)];
    [ml_tmp OHALB_setupLineSpacing:1];
    return ml_tmp.bounds.size.height;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    currentSelectedIndexPath = indexPath;
    moreButtonType = MoreButtonType_Comment;
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    if([curCell isKindOfClass:[FGCommentsCommonCellView class]])
    {
        NSMutableDictionary *_dic_singleComment = [arr_commentData objectAtIndex:indexPath.row];
        str_currentSelectedCommentUserID = [_dic_singleComment objectForKey:@"UserId"];
        str_currentSelectedCommentID = [_dic_singleComment objectForKey:@"CommentId"];
        [self internalInitalPostMoreView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0)
    {
        NSString *str_text = [dic_postData objectForKey:@"Content"];
        CGFloat _originalCellHeight = 123;//123是xib中cell原始高度，
        CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21);//这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
        CGRect _originalCollectionBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中CollectionView的原始高度 206是原始宽度
        CGRect _originalVideoContainerBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中videoContainer的原始高度 171是原始宽度
        NSInteger imageCount = [[dic_postData objectForKey:@"Images"] count];
        NSString *_str_videoUrl = [dic_postData objectForKey:@"Video"];
        
        [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
        if(![_str_videoUrl isEmptyStr] && imageCount <= 0)
        {
            
            CGFloat cellHeight = [self calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalVideoContainerFrame:_originalVideoContainerBounds];
            return cellHeight;
        }
        else
        {
            CGFloat cellHeight = [self calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalCollectionFrame:_originalCollectionBounds collectionImagesCount:imageCount];
            return cellHeight;
        }


        return 0;
    }
    else if(indexPath.section == 1)
    {
        NSString *str_text = [[arr_commentData objectAtIndex:indexPath.row] objectForKey:@"Content"];
        
        CGFloat _originalCellHeight = 94;                        //94是xib中cell原始高度，
        CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21); //这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
        
        [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
        
        CGFloat cellHeight = [self calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalCollectionFrame:CGRectZero collectionImagesCount:0];
        return cellHeight;
        
    }//评论内容的高度
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if(section == 0 )
        return 0;
    else if(section == 1)
        return view_commentTitle.frame.size.height;//只有Comment的section
    else
        return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if(section == 0 )
        return nil;
    else if(section == 1)
    {
        view_commentTitle.lb_commentsCount.text = [NSString stringWithFormat:@"%@ (%ld)", multiLanguage(@"Comments"), totalComment];
        return view_commentTitle;//只有Comment的section
    }
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
    {
        if(dic_postData)
            return 1;//视频界面只有1个row
        else
            return 0;
    }
    else
        return [arr_commentData count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    if(indexPath.section == 0)
    {
        cell = [self giveMePostsFollowingCellView:tableView];
         [cell updateCellViewWithInfo:dic_postData];
        ((FGPostsFollowingCellView *)cell).lb_comments.text = [NSString stringWithFormat:@"(%ld)",totalComment];
    }
    else if(indexPath.section == 1)
    {
        cell = [self giveMeCommentsCellView:tableView];
        [cell updateCellViewWithInfo:[arr_commentData objectAtIndex:indexPath.row]];
    }
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (view_dialog) {
        [view_dialog closePad];
    }
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMePostsFollowingCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGPostsFollowingCellView";
    FGPostsFollowingCellView *cell = (FGPostsFollowingCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGPostsFollowingCellView *)[nib objectAtIndex:0];
    }
    
    [cell.btn_more addTarget:self action:@selector(buttonAction_more:) forControlEvents:UIControlEventTouchUpInside];
    cell.btn_comments.userInteractionEnabled = NO;
    cell.btn_comments.enabled = NO;
    
    return cell;
}

-(UITableViewCell *)giveMeCommentsCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGCommentsCommonCellView";
    FGCommentsCommonCellView *cell = (FGCommentsCommonCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGCommentsCommonCellView *)[nib objectAtIndex:0];
    }
    
    return cell;
}


-(void)bindDataToUI:(NSMutableDictionary *)_dic_postInfo
{
    tb.delegate = self;
    tb.dataSource = self;
    [arr_commentData removeAllObjects];
    
    dic_postData = _dic_postInfo;
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetCommentList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [[FGPostLikesCommentsSyncModel sharedModel] setCommentsCount:(int)totalComment
                                                        byPostId:str_postId];//POSTSYNC: 网络更新totalComment后后本地全局更新 comments
    
    arr_commentData = [_dic_result objectForKey:@"Comments"];
    
    [tb reloadData];
    [self hideFooterLoadingIfNeeded];
    [tb.mj_header endRefreshing];
    [self internalInitalDialogView];
}

- (void)loadMoreComments{
   
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetCommentList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
  
    [[FGPostLikesCommentsSyncModel sharedModel] setCommentsCount:(int)totalComment
                                                        byPostId:str_postId];//POSTSYNC: 网络更新totalComment后后本地全局更新 comments
    
    [arr_commentData addObjectsFromArray:[_dic_result objectForKey:@"Comments"]];
    [tb reloadData];
    [self hideFooterLoadingIfNeeded];
    
}

-(void)updateLikeStatusByPostId:(NSString *)_postId isLike:(BOOL)_isLike likes:(int)_likes
{
    [[FGPostLikesCommentsSyncModel sharedModel] setLikes:_likes byPostId:_postId];//POSTSYNC:
    [[FGPostLikesCommentsSyncModel sharedModel] setIsLike:_isLike byPostId:_postId];//POSTSYNC:
    [dic_postData setObject:@(_isLike) forKey:@"IsLike"];
    [dic_postData setObject:@(_likes) forKey:@"Like"];
}

-(void)hideFooterLoadingIfNeeded
{
    
    [tb.refreshFooter endRefreshing];
    if (commentCursor == -1 || totalComment == 0)
        [tb allowedShowActivityAtFooter:NO];
    else
        [tb allowedShowActivityAtFooter:YES];
}


-(void)postRequest_getPostCommentList
{
    NetworkRequestInfo *_dic_userinfo = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController] repelKEY:nil];
    [[NetworkManager_Post sharedManager] postRequest_getCommentList:str_postId cursor:commentCursor count:10 userinfo:_dic_userinfo];
}

-(void)postRequest_getMorePostCommentList
{
    //NSMutableDictionary *_dic_userinfo = [NSMutableDictionary dictionaryWithCapacity:1 ];
    
    NetworkRequestInfo *_dic_userinfo = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    [_dic_userinfo setObject:@"Post_GetMoreComment" forKey:@"Post_GetMoreComment"];
    
    [[NetworkManager_Post sharedManager] postRequest_getCommentList:str_postId cursor:commentCursor count:10 userinfo:_dic_userinfo];
}

#pragma mark - FGDialogTextInputViewDelegate
- (void)dialogDidClickSend:(NSString *)_str_textNeedToSend {
    if ([_str_textNeedToSend isEmptyStr])
        return;
    
    
    NSString *_htmlWrapped = [FGUtils formatToHtmlStringWithString:self.view_dialog.textView.attributedText.string useMatchPatterns:[self.view_dialog.textView textlinkInfos]];
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController] repelKEY:nil];
    [[NetworkManager_Post sharedManager] postRequest_submitComment:str_postId content:_htmlWrapped userinfo:_dic_info];
}



#pragma mark - comment more button
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
    if(moreButtonType == MoreButtonType_Comment && _str_userid && ![_str_userid isEmptyStr])
    {
        if([_str_userid isEqualToString:str_currentSelectedCommentUserID])
        {
            view_commentMorePopup.cb_deletePost.hidden = NO;
            [view_commentMorePopup.cb_deletePost.button addTarget:self action:@selector(buttonAction_commentMore_delete:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}


-(void)buttonAction_more:(UIButton *)_btn
{
    moreButtonType = MoreButtonType_Post;
    str_currentSelectedPostID = [dic_postData objectForKey:@"PostId"];
    str_currentSelectedCommentUserID = [dic_postData objectForKey:@"UserId"];
    [self internalInitalPostMoreView];
}

-(void)buttonAction_commentMore_report:(id)_sender
{
    if(!view_commentMorePopup)
        return;
    SAFE_RemoveSupreView(view_commentMorePopup);
    view_commentMorePopup = nil;
    [commond showReportActionSheet:self showInView:self];
}

-(void)buttonAction_commentMore_cancel:(id)_sender
{
    if(!view_commentMorePopup)
        return;
    SAFE_RemoveSupreView(view_commentMorePopup);
    view_commentMorePopup = nil;
    
}

-(void)buttonAction_commentMore_delete:(id)_sender
{
    if(!view_commentMorePopup)
        return;
    SAFE_RemoveSupreView(view_commentMorePopup);
    view_commentMorePopup = nil;
    
    [arr_commentData removeObjectAtIndex:currentSelectedIndexPath.row];
   
    totalComment --;
    view_commentTitle.lb_commentsCount.text = [NSString stringWithFormat:@"%@ (%ld)", multiLanguage(@"Comments"), totalComment];
    FGPostsFollowingCellView *cell = (FGPostsFollowingCellView *)[self giveMePostsFollowingCellView:tb];
    cell.lb_comments.text = [NSString stringWithFormat:@"%ld",totalComment];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [tb beginUpdates];
    [tb reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    [tb deleteRowsAtIndexPaths:@[currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tb endUpdates];
    
    
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    [[NetworkManager_Post sharedManager] postRequest_deletePostComment:str_currentSelectedCommentID userinfo:_dic_info];
    
    [[FGPostLikesCommentsSyncModel sharedModel] setCommentsCount:(int)totalComment
                                                        byPostId:str_postId];////POSTSYNC: 删除后本地全局更新 comments
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > [arr_reportContents count] - 1)
        return;
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    if(moreButtonType == MoreButtonType_Comment)
    {
        [[NetworkManager_Post sharedManager] postRequest_AccuseComment:str_currentSelectedCommentID content:[arr_reportContents objectAtIndex:buttonIndex] userinfo:_dic_info];
    }
    else if(moreButtonType == MoreButtonType_Post)
    {
        [[NetworkManager_Post sharedManager] postRequest_accusePost:str_currentSelectedPostID content:[arr_reportContents objectAtIndex:buttonIndex] userinfo:_dic_info];
    }
    
}
@end
