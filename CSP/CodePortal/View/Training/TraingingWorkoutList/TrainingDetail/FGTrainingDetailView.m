//
//  FGTrainingDetailView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGCommentsCommonCellView.h"
#import "FGTrainingDetailDescriptionCellView.h"
#import "FGTrainingDetailDescriptionTitleCellView.h"
#import "FGTrainingDetailLikesBannerCellView.h"
#import "FGTrainingDetailSubjectcCellView.h"
#import "FGTrainingDetailView.h"
#import "FGTrainingStepByStepViewController.h"
#import "FGTrainingStepByStepViewController.h"
#import "FGVideoModel.h"
#import "Global.h"
#import "OHAttributedLabel.h"
#import "UIScrollView+FGRereshFooter.h"
@interface FGTrainingDetailView () {
    NSMutableArray *arr_dataInTable;
    NSString *str_description;
    BOOL haveLikes;
    BOOL isDescriptionClosed;
    UILabel *lb_tmp;
    OHAttributedLabel *ml_tmp;
    int commentCursor;
    int totalComment;
}
@end

@implementation FGTrainingDetailView
@synthesize view_commentSectionTitle;
@synthesize tb;
@synthesize str_workoutId;
@synthesize str_userCalories;
@synthesize view_dialog;
@synthesize view_commentMorePopup;
@synthesize str_currentSelectedCommentUserID;
@synthesize str_currentSelectedCommentID;
@synthesize currentSelectedIndexPath;
@synthesize isNeedRemoveComments;
#pragma mark - 生命周期
- (void)awakeFromNib {
    [super awakeFromNib];
    tb.delegate   = self;
    tb.dataSource = self;
    
    lb_tmp               = [[UILabel alloc] init];
    lb_tmp.numberOfLines = 0;
    lb_tmp.textAlignment = NSTextAlignmentLeft;
    
    ml_tmp      = [[OHAttributedLabel alloc] init];
    ml_tmp.font = font(FONT_TEXT_REGULAR, 16);
    
    arr_dataInTable = [[NSMutableArray alloc] init];
    [commond useDefaultRatioToScaleView:tb];
    [self internalInitalCommentsTitleSectionView];
    
    commentCursor = 0;
    [self addPullToRefresh];
}

-(void)addPullToRefresh
{
    //TODO: 获取更多评论
    [self.tb addInfiniteScrollingWithActionHandler:^{
        
        [[NetworkManager_Training sharedManager] postRequest_GetTrainCommentList:commentCursor trainingID:[NSString stringWithFormat:@"%@", str_workoutId] count:10 userinfo:nil];
        
    }];
    
    __weak FGTrainingDetailView *weakSelf = self;
    [tb addPullToRefreshWindowsStyleWithActionHandler:^{
        [weakSelf postRequest];
    }];
    [tb triggerSetProgressTintColor:[UIColor blackColor]];
}

#pragma mark - 初始化
- (void)dealloc {
    NSLog(@"::::>dealloc %s %d", __FUNCTION__, __LINE__);
    arr_dataInTable = nil;
    lb_tmp          = nil;
    str_description = nil;
    str_workoutId   = nil;
    str_userCalories = nil;
    SAFE_RemoveSupreView(view_dialog);
    view_dialog.delegate = nil;
    view_dialog          = nil;
    ml_tmp               = nil;
    str_currentSelectedCommentUserID = nil;
    str_currentSelectedCommentID = nil;
    currentSelectedIndexPath = nil;
}

-(void)clearMemory
{
    if(view_dialog)
    [view_dialog clearMemory];
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
    
    [view_dialog.textView setupWithSpecialPattern:@"@" withActionHandler:^{
        [commond presentUserPickViewFromController:[self viewController] listType:ListType_User];
        
    }];
    [view_dialog.textView setupWithSpecialPattern:@"#" withActionHandler:^{
        [commond presentUserPickViewFromController:[self viewController] listType:ListType_Topic];
    }];
}

- (void)internalInitalCommentsTitleSectionView {
    if (view_commentSectionTitle)
        return;
    view_commentSectionTitle = (FGTrainingDetailCommentsTitleSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingDetailCommentsTitleSectionView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_commentSectionTitle];
}

#pragma mark - 利用一个已经临时的UILabel 来计算 table中 带可变高度UILabel的cellview的总高度
- (CGFloat)calculateCellHeightByDynamicView:(UIView *)_view originalCellHeight:(CGFloat)_originalCellHeight originalLabelFrame:(CGRect)_originalLabelFrame {
    CGFloat cellHeight = (_originalCellHeight - _originalLabelFrame.size.height) * ratioH + _view.frame.size.height;
    
    return cellHeight;
}

#pragma mark - 计算高度

- (CGFloat)setupTmpLabelHeightByText:(NSString *)_str_text lineSpace:(CGFloat)_lineSpace font:(UIFont *)_font originalLabelFrame:(CGRect)_originalLabelFrame {
    lb_tmp.text  = _str_text;
    lb_tmp.frame = _originalLabelFrame;
    lb_tmp.font  = _font;
    [commond useDefaultRatioToScaleView:lb_tmp];
    [lb_tmp setLineSpace:_lineSpace alignment:NSTextAlignmentLeft];
    [lb_tmp sizeToFit];
    CGFloat labelHeight = lb_tmp.frame.size.height;
    return labelHeight;
}


- (CGFloat)sizeThatAttributeString:(NSString *)content width:(CGFloat)width {
//    [ml_tmp OHLB_setupHTMLParserWithContent:content width:width];
    [ml_tmp OHLB_setupHTMLParserWithContent:content width:width linkFont:font(FONT_TEXT_REGULAR, 17) normalFont:font(FONT_TEXT_REGULAR, 16)];
    [ml_tmp OHALB_setupLineSpacing:1];
    return ml_tmp.bounds.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0) {
        return 268 * ratioH;
    } //视频界面的高度
    else if (indexPath.section == 1) {
        static int _cursor         = 0;
        static int _subject_cursor = 0;
        if (haveLikes) {
            _cursor = 1;
            if (indexPath.row == _cursor - 1)
                return 44 * ratioH;
            
        } //赞的高度
        else
            _cursor = 0;
        
        if (indexPath.row == _cursor) {
            return 44 * ratioH; //简介标题按钮的高度
        }
        
        if (isDescriptionClosed) {
            _subject_cursor = _cursor + 1;
            
        } //如果关闭简介
        else {
            if (indexPath.row == _cursor + 1) {
                NSString *str_text          = [[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
                CGFloat _originalCellHeight = 54;                        //54是xib中cell原始高度
                CGRect _originalLabelBounds = CGRectMake(0, 0, 281, 37); //这两魔法数字 和xib中宽高相同 37是xib中UILabel的原始高度 289是原始宽度
                [self setupTmpLabelHeightByText:str_text lineSpace:6 font:font(FONT_TEXT_REGULAR, 16) originalLabelFrame:_originalLabelBounds];
                CGFloat cellHeight = [self calculateCellHeightByDynamicView:lb_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds];
                return cellHeight;
            } //简介文字的高度
            
            _subject_cursor = _cursor + 2;
        } //如果没有关闭简介
        
        if (indexPath.row >= _subject_cursor) {
            if (indexPath.row == [[arr_dataInTable objectAtIndex:indexPath.section] count] - 1) {
                return 38 * 1.2 * ratioH;
            } //最后一个FGTrainingDetailSubjectcCellView 要稍微高点
            else
                return 38 * ratioH;
        } //摘要的高度
        
    } else if (indexPath.section == 2) {
        NSString *str_text = [[[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"Content"];
        
        CGFloat _originalCellHeight = 94;                        //94是xib中cell原始高度，
        CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21); //这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
        
        [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
        
        CGFloat cellHeight = [self calculateCellHeightByDynamicView:ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds];
        
        return cellHeight;
        
    } //评论内容的高度
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if (section == 0 || section == 1)
        return 0;
    else
        return view_commentSectionTitle.frame.size.height; //只有Comment的section
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if (section == 0 || section == 1)
        return nil;
    else {
        view_commentSectionTitle.lb_commentsCount.text = [NSString stringWithFormat:@"%@ (%d)", multiLanguage(@"Comments"), totalComment];
        return view_commentSectionTitle; //只有Comment的section
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    currentSelectedIndexPath = indexPath;
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([curCell isKindOfClass:[FGTrainingDetailDescriptionTitleCellView class]]) {
        FGTrainingDetailDescriptionTitleCellView *cell = (FGTrainingDetailDescriptionTitleCellView *)curCell;
        if (isDescriptionClosed) //简介已经关闭
        {
            isDescriptionClosed                = NO;
            NSIndexPath *indexPathNeedToInsert = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            
            NSMutableArray *_arr_singleSection = [arr_dataInTable objectAtIndex:indexPathNeedToInsert.section];
            [_arr_singleSection insertObject:str_description atIndex:indexPathNeedToInsert.row];
            
            [cell openAnimation];
            
            [tb beginUpdates];
            NSArray *arrInsertRows = [NSArray arrayWithObject:indexPathNeedToInsert];
            [tb insertRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationNone];
            [tb endUpdates];
            
        } else {
            isDescriptionClosed               = YES;
            NSIndexPath *indexPathNeedToDelte = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            
            NSMutableArray *_arr_singleSection = [arr_dataInTable objectAtIndex:indexPath.section];
            [_arr_singleSection removeObjectAtIndex:indexPathNeedToDelte.row];
            
            [cell closeAnimation];
            
            [tb beginUpdates];
            NSArray *arrInsertRows = [NSArray arrayWithObject:indexPathNeedToDelte];
            [tb deleteRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationNone];
            [tb endUpdates];
        }
    }
    else if([curCell isKindOfClass:[FGTrainingDetailLikesBannerCellView class]])
    {
        [commond presentTrainingLikesViewFromController:[self viewController] trainingID:str_workoutId];
    }
    else if([curCell isKindOfClass:[FGCommentsCommonCellView class]])
    {
        NSMutableDictionary *_dic_singleComment = [[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        str_currentSelectedCommentUserID = [_dic_singleComment objectForKey:@"UserId"];
        str_currentSelectedCommentID = [_dic_singleComment objectForKey:@"CommentId"];
        [self internalInitalPostMoreView];
    }
}


#pragma mark - reshDownloadButtonStatus
- (void)refreshDownloadButtonStatus {
    FGTrainingDetailTopVideoThumbnailCellView *cell = [tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell updateDownloadButtonStatus];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [arr_dataInTable count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (section == 0)
        return 1; //视频界面只有1个row
    else
        return [[arr_dataInTable objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [self giveMeVideoThumbnailCellView:tableView];
        [(FGTrainingDetailTopVideoThumbnailCellView *)cell updateDownloadButtonStatus];
        ((FGTrainingDetailTopVideoThumbnailCellView *)cell)._str_trainId = str_workoutId;
        ((FGTrainingDetailTopVideoThumbnailCellView *)cell).str_UserCalories = str_userCalories;
        [cell updateCellViewWithInfo:[arr_dataInTable objectAtIndex:indexPath.section]];
    } else if (indexPath.section == 1) {
        static int _cursor         = 0;
        static int _subject_cursor = 0;
        if (haveLikes) {
            if (indexPath.row == 0) {
                cell = [self giveMeLikesBannerCellView:tableView];
                [cell updateCellViewWithInfo:[[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            }
            
            _cursor = 1; //如果有赞 下标从1开始
        }              //如果有赞第一行是赞的cell
        else
            _cursor = 0;
        
        if (indexPath.row == _cursor) {
            cell = [self giveMeDescriptionTitleCellView:tableView];
            if (isDescriptionClosed)
                [(FGTrainingDetailDescriptionTitleCellView *)cell closeAnimationWithAnimation:NO];
            else
                [(FGTrainingDetailDescriptionTitleCellView *)cell openAnimationWithAnimation:NO];
            [cell updateCellViewWithInfo:[[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        }
        
        if (isDescriptionClosed) {
            _subject_cursor = _cursor + 1;
        } //如果关闭简介
        else {
            if (indexPath.row == _cursor + 1) {
                cell = [self giveMeDescriptionCellView:tableView];
                [cell updateCellViewWithInfo:[[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            }
            _subject_cursor = _cursor + 2;
        } //如果没有关闭简介
        
        if (indexPath.row >= _subject_cursor) {
            cell = [self giveMeSubjectcCellView:tableView];
            [cell updateCellViewWithInfo:[[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            if (indexPath.row == [[arr_dataInTable objectAtIndex:indexPath.section] count] - 1) {
                FGTrainingDetailSubjectcCellView *cell_subject = (FGTrainingDetailSubjectcCellView *)cell;
                cell_subject.view_separator.hidden             = YES;
            } //最后一个FGTrainingDetailSubjectcCellView 隐藏它的分割线
        }
        
    } else if (indexPath.section == 2) {
        cell = [self giveMeCommentsCellView:tableView];
        [cell updateCellViewWithInfo:[[arr_dataInTable objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
- (UITableViewCell *)giveMeVideoThumbnailCellView:(UITableView *)_tb {
    NSString *CellIdentifier                        = @"FGTrainingDetailTopVideoThumbnailCellView";
    FGTrainingDetailTopVideoThumbnailCellView *cell = (FGTrainingDetailTopVideoThumbnailCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingDetailTopVideoThumbnailCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - 初始化Likes的tableCell
- (UITableViewCell *)giveMeLikesBannerCellView:(UITableView *)_tb {
    NSString *CellIdentifier                  = @"FGTrainingDetailLikesBannerCellView";
    FGTrainingDetailLikesBannerCellView *cell = (FGTrainingDetailLikesBannerCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingDetailLikesBannerCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - 初始化简介标题的tableCell
- (UITableViewCell *)giveMeDescriptionTitleCellView:(UITableView *)_tb {
    NSString *CellIdentifier                       = @"FGTrainingDetailDescriptionTitleCellView";
    FGTrainingDetailDescriptionTitleCellView *cell = (FGTrainingDetailDescriptionTitleCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingDetailDescriptionTitleCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - 初始化简介内容的tableCell
- (UITableViewCell *)giveMeDescriptionCellView:(UITableView *)_tb {
    NSString *CellIdentifier                  = @"FGTrainingDetailDescriptionCellView";
    FGTrainingDetailDescriptionCellView *cell = (FGTrainingDetailDescriptionCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingDetailDescriptionCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - 初始摘要列的tablecell
- (UITableViewCell *)giveMeSubjectcCellView:(UITableView *)_tb {
    NSString *CellIdentifier               = @"FGTrainingDetailSubjectcCellView";
    FGTrainingDetailSubjectcCellView *cell = (FGTrainingDetailSubjectcCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingDetailSubjectcCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - 初始评论列的tablecell
- (UITableViewCell *)giveMeCommentsCellView:(UITableView *)_tb {
    NSString *CellIdentifier       = @"FGCommentsCommonCellView";
    FGCommentsCommonCellView *cell = (FGCommentsCommonCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FGCommentsCommonCellView" owner:self options:nil];
        cell         = (FGCommentsCommonCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

#pragma mark - 利用scrollView 实现顶部的一个缩放特效
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *curCell = [tb cellForRowAtIndexPath:indexPath];
        if ([curCell isKindOfClass:[FGTrainingDetailTopVideoThumbnailCellView class]]) {
            FGTrainingDetailTopVideoThumbnailCellView *cell = (FGTrainingDetailTopVideoThumbnailCellView *)curCell;
            CGFloat scalePercent                            = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
            cell.iv_videoThumbnail.transform                = CGAffineTransformMakeScale(1 + scalePercent * 1.8, 1 + scalePercent * 1.8);
            CGRect _frame                                   = cell.iv_videoThumbnail.frame;
            _frame.origin.y                                 = scrollView.contentOffset.y;
            cell.iv_videoThumbnail.frame                    = _frame;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (view_dialog) {
        [view_dialog closePad];
    }
}

- (void)postRequest {
    [self.tb triggerStartRefresh];
    [[NetworkManager_Training sharedManager] postRequest_GetTrainDetailPageBytrainingID:[NSString stringWithFormat:@"%@", str_workoutId] userinfo:nil];
}

- (void)internalInitalVideoModel {
    
    FGVideoModel *model_video      = [FGVideoModel sharedModel];
    [model_video cancelDownloading];
    [FGVideoModel clearVideoModel];
    model_video      = [FGVideoModel sharedModel];
    model_video.str_workoutID = str_workoutId;
    NSMutableDictionary *_dic_step = [self giveMeResponseContentByResponseName:@"GetTrainingStep"];
    NSMutableArray *_arr_tmp_url  = [_dic_step objectForKey:@"StepVideos"];
   // _arr_tmp_url = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"urlinfos" ofType:@"json"]];
   // NSLog(@"_arr_tmp_url = %@",_arr_tmp_url);  加载测试数据
        for (NSMutableDictionary *_dic_singleInfo in _arr_tmp_url) {
            NSString *str_url = [_dic_singleInfo objectForKey:@"VideoUrl"];
            NSString *str_audioUrl = [_dic_singleInfo objectForKey:@"AudioUrl"];
            if(![str_url isEmptyStr])
            {
                [model_video.arr_urls addObject:str_url];
                [model_video.arr_urlInfos addObject:_dic_singleInfo];
            }
            if(![str_audioUrl isEmptyStr])
            {
                if(![model_video.arr_audioUrls containsObject:str_audioUrl])
                    [model_video.arr_audioUrls addObject:str_audioUrl];//去除重复的url
            }
        }
    [model_video filteRepeatedAudioUrlAndRecordThePlayIndex];
    [model_video filteRepeatedUrlAndRecordTheCount];
}

- (void)bindDataToUI {
    [self internalInitalVideoModel];
    [arr_dataInTable removeAllObjects];
    
    NSMutableDictionary *_dic_response_details   = [self giveMeResponseContentByResponseName:@"GetTrainDetail"];
    NSMutableDictionary *_dic_videoThumbnailData = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_videoThumbnailData setObject:[_dic_response_details objectForKey:@"Likes"] forKey:@"Likes"];
    [_dic_videoThumbnailData setObject:[_dic_response_details objectForKey:@"IsLike"] forKey:@"IsLike"];
    [_dic_videoThumbnailData setObject:[_dic_response_details objectForKey:@"Thumbnail"] forKey:@"Thumbnail"];
    [_dic_videoThumbnailData setObject:[_dic_response_details objectForKey:@"IsFavorite"] forKey:@"IsFavorite"];
    [arr_dataInTable addObject:_dic_videoThumbnailData];
    str_userCalories = [_dic_response_details objectForKey:@"UserCalories"];
    
    
    NSMutableArray *_arr_like_description_detail = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableDictionary *_dic_likes = [self giveMeResponseContentByResponseName:@"GetTrainLikeList"];
    NSMutableArray *_arr_likes      = [_dic_likes objectForKey:@"Likes"];
    
    if ([_arr_likes count] == 0) {
        haveLikes = NO;
    } else {
        haveLikes = YES;
        [_arr_like_description_detail addObject:_dic_likes];
    }
    
    NSString *_str_desctiptionTitle = [_dic_response_details objectForKey:@"ScreenName"];
    
    [_arr_like_description_detail addObject:_str_desctiptionTitle];
    
    isDescriptionClosed = NO;
    str_description     = [_dic_response_details objectForKey:@"Discreption"];
    [_arr_like_description_detail addObject:str_description];
    
    NSMutableDictionary *_dic_subject1 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject1 setObject:@"Intensity" forKey:@"Key"];
    [_dic_subject1 setObject:[_dic_response_details objectForKey:@"Intensity"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject1];
    
    NSMutableDictionary *_dic_subject2 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject2 setObject:@"Level" forKey:@"Key"];
    [_dic_subject2 setObject:[_dic_response_details objectForKey:@"Level"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject2];
    
    NSMutableDictionary *_dic_subject3 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject3 setObject:@"Duration" forKey:@"Key"];
    [_dic_subject3 setObject:[_dic_response_details objectForKey:@"Duration"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject3];
    
    NSMutableDictionary *_dic_subject4 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject4 setObject:@"Equipment_Needed" forKey:@"Key"];
    [_dic_subject4 setObject:[_dic_response_details objectForKey:@"Equipment_Needed"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject4];
    
    NSMutableDictionary *_dic_subject5 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject5 setObject:@"Workout_Type" forKey:@"Key"];
    [_dic_subject5 setObject:[_dic_response_details objectForKey:@"Workout_Type"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject5];
    
    NSMutableDictionary *_dic_subject6 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject6 setObject:@"Estimated_Calories_Burned" forKey:@"Key"];
    [_dic_subject6 setObject:[_dic_response_details objectForKey:@"Estimated_Calories_Burned"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject6];
    
    /*NSMutableDictionary *_dic_subject7 = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_subject7 setObject:@"Goal" forKey:@"Key"];
    [_dic_subject7 setObject:[_dic_response_details objectForKey:@"Goal"] forKey:@"Value"];
    [_arr_like_description_detail addObject:_dic_subject7];*/
    
    [arr_dataInTable addObject:_arr_like_description_detail];
    
    NSMutableDictionary *_dic_comments = [self giveMeResponseContentByResponseName:@"GetTrainCommentList"];
    NSMutableArray *_arr_comments      = [_dic_comments objectForKey:@"Comments"] ;
    totalComment                       = [[_dic_comments objectForKey:@"TotalCount"] intValue];
    commentCursor                      = [[_dic_comments objectForKey:@"Cursor"] intValue];
    
    if (commentCursor == -1 || totalComment == 0)
        [tb allowedShowActivityAtFooter:NO];
    else
        [tb allowedShowActivityAtFooter:YES];
    
    if(!isNeedRemoveComments)
        [arr_dataInTable addObject:_arr_comments];
    _arr_comments = nil;
    [tb reloadData];
    [self scrollViewDidScroll:tb];
    [tb triggerStopRefresh];
    
    [self internalInitalDialogView];
    
    [self refreshDownloadButtonStatus];
}



- (id)giveMeResponseContentByResponseName:(NSString *)_str_responseName {
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainDetailPage)];
    return [self giveMeResponseContentByResponseName:_str_responseName fromDatas:_dic_result];
}

- (id)giveMeResponseContentByResponseName:(NSString *)_str_responseName fromDatas:(NSMutableDictionary *)_dic_result {
    NSMutableArray *_arr_datas       = [_dic_result objectForKey:@"Responses"];
    for (NSMutableDictionary *_dic_data in _arr_datas) {
        NSString *str_responseName = [_dic_data objectForKey:@"ResponseName"];
        if ([_str_responseName isEqualToString:str_responseName]) {
            id _obj_responseContent = [_dic_data objectForKey:@"ResponseContent"];
            return _obj_responseContent;
        }
    }
    return nil;
}

#pragma mark - 加载更多评论
- (void)loadMoreComments {
    __weak FGTrainingDetailView *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainCommentList)];
        NSMutableArray *arr_commentsInfo = [_dic_result objectForKey:@"Comments"];
        commentCursor                    = [[_dic_result objectForKey:@"Cursor"] intValue];
        totalComment                     = [[_dic_result objectForKey:@"TotalCount"] intValue];
        [[arr_dataInTable lastObject] addObjectsFromArray:arr_commentsInfo];
        NSLog(@"arr_dataInTable = %@", arr_dataInTable);
        [weakSelf.tb reloadData];
        [weakSelf.tb.refreshFooter endRefreshing];
        
        if (commentCursor == -1)
            [tb allowedShowActivityAtFooter:NO];
        else
            [tb allowedShowActivityAtFooter:YES];
        
    });
}

#pragma mark - 刷新评论的第一页
- (void)reloadComments {
    [[arr_dataInTable lastObject] removeAllObjects];
    [self loadMoreComments];
}

#pragma mark - 提交评论后的行为
- (void)afterSubmitComment {
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:@"RefreshComment" forKey:@"RefreshComment"];
    commentCursor = 0;
    [[NetworkManager_Training sharedManager] postRequest_GetTrainCommentList:commentCursor trainingID:[NSString stringWithFormat:@"%@", str_workoutId] count:10 userinfo:_dic_info];
}



#pragma mark - 刷新Likes后
-(void)afterUpdateTranLikes
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainLikeList)];
    
    if(haveLikes)
    {
        if([[_dic_result objectForKey:@"TotalCount"] intValue] > 0)
        {
            NSMutableArray *_arr_likesDetailInfo = [arr_dataInTable objectAtIndex:1] ;
            [_arr_likesDetailInfo replaceObjectAtIndex:0 withObject:_dic_result];
        }//更新后点赞不为0 替换数据
        else
        {
            haveLikes = NO;
            NSMutableArray *_arr_descriptionDetail = [arr_dataInTable objectAtIndex:1];
            [_arr_descriptionDetail removeObjectAtIndex:0];
        }//更新后点赞为0，删除数据
        
    }//如果更新前有点赞cell
    else{
        if([[_dic_result objectForKey:@"TotalCount"] intValue] > 0)
        {
            haveLikes = YES;
            NSMutableArray *_arr_descriptionDetail = [arr_dataInTable objectAtIndex:1];
            [_arr_descriptionDetail insertObject:_dic_result atIndex:0];//插入点赞信息
        }//更新后点赞不为0
        
    }//如果更新前没有点赞cell
    [tb reloadData];
}

-(void)afterUpdateTranDetail
{
    [[NetworkManager_Training sharedManager] postRequest_GetTrainLikeList:YES count:8 trainingID:str_workoutId userinfo:nil];
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetTrainDetail)];
    NSMutableDictionary *_dic_trainDetail = [arr_dataInTable objectAtIndex:0] ;
    [_dic_trainDetail setObject:[_dic_result objectForKey:@"IsLike"] forKey:@"IsLike"];
    [_dic_trainDetail setObject:[_dic_result objectForKey:@"IsFavorite"] forKey:@"IsFavorite"];
    
    
    
}

#pragma mark - FGDialogTextInputViewDelegate

- (void)dialogDidClickSend:(NSString *)_str_textNeedToSend {
    if ([_str_textNeedToSend isEmptyStr])
        return;
    
    
    
    NSString *_htmlWrapped = [FGUtils formatToHtmlStringWithString:self.view_dialog.textView.attributedText.string useMatchPatterns:[self.view_dialog.textView textlinkInfos]];
    NSLog(@"_htmlWrapped = %@",_htmlWrapped);
    [[NetworkManager_Training sharedManager] postRequest_SubmitTrainComment:[NSString stringWithFormat:@"%@", str_workoutId] content:_htmlWrapped userinfo:nil];
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
    if(_str_userid && ![_str_userid isEmptyStr])
    {
        if([_str_userid isEqualToString:str_currentSelectedCommentUserID])
        {
            view_commentMorePopup.cb_deletePost.hidden = NO;
            [view_commentMorePopup.cb_deletePost.button addTarget:self action:@selector(buttonAction_commentMore_delete:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
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
    
    totalComment--;
    view_commentSectionTitle.lb_commentsCount.text = [NSString stringWithFormat:@"%@ (%d)", multiLanguage(@"Comments"), totalComment];
    [arr_dataInTable[currentSelectedIndexPath.section] removeObjectAtIndex:currentSelectedIndexPath.row];
    [tb beginUpdates];
    [tb deleteRowsAtIndexPaths:@[currentSelectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [tb endUpdates];
    
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    [[NetworkManager_Training sharedManager] postRequest_DeleteTrainComment:str_currentSelectedCommentID  userinfo:_dic_info];
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex > [arr_reportContents count] - 1)
        return;
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:[self viewController]];
    [[NetworkManager_Training sharedManager] postReuqest_AccuseTrainComment:str_currentSelectedCommentUserID content:[arr_reportContents objectAtIndex:buttonIndex] userinfo:_dic_info];
}

@end
