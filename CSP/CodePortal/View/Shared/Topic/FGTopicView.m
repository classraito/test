//
//  FGTopicView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTopicView.h"
#import "Global.h"
#import "FGTopicTopBannerCellView.h"
#import "NetworkManager_Post.h"
@implementation FGTopicView
@synthesize str_topicId;
@synthesize str_topicName;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
   if(self.view_sectionTitle)
   {
       SAFE_RemoveSupreView(self.view_sectionTitle);
       self.view_sectionTitle = nil;
   }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0)
    {
        return 160 * ratioH;//160是FGTopicTopBannerCellView xib中原始高度
    }
    else if(indexPath.section == 1)
    {
        NSString *str_text = [[self.arr_data  objectAtIndex:indexPath.row] objectForKey:@"Content"];
        CGFloat _originalCellHeight = 123;//123是xib中cell原始高度，
        CGRect _originalLabelBounds = CGRectMake(0, 0, 223, 21);//这两魔法数字 和xib中宽高相同 21是xib中UILabel的原始高度 223是原始宽度
        CGRect _originalCollectionBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中CollectionView的原始高度 171是原始宽度
        CGRect _originalVideoContainerBounds = CGRectMake(0, 0, 171, 21);//这两魔法数字 和xib中宽高相同 21是xib中videoContainer的原始高度 171是原始宽度
        NSInteger imageCount = [[[self.arr_data objectAtIndex:indexPath.row] objectForKey:@"Images"] count];
        NSString *_str_videoUrl = [[self.arr_data objectAtIndex:indexPath.row] objectForKey:@"Video"];
        if(![_str_videoUrl isEmptyStr] && imageCount <= 0)
        {
            [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
            CGFloat cellHeight = [self calculateCellHeightByDynamicView:self.ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalVideoContainerFrame:_originalVideoContainerBounds];
            return cellHeight;
        }
        else
        {
            [self sizeThatAttributeString:str_text width:_originalLabelBounds.size.width * ratioW];
            CGFloat cellHeight = [self calculateCellHeightByDynamicView:self.ml_tmp originalCellHeight:_originalCellHeight originalLabelFrame:_originalLabelBounds originalCollectionFrame:_originalCollectionBounds collectionImagesCount:imageCount];
            return cellHeight;
        }
        return 0;
        
    }//评论内容的高度
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if(section == 0 )
        return 0;
    else if(section == 1)
        return 0;//只有Comment的section
    else
        return 0;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
 
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
        return [self.arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    if(indexPath.section == 0)
    {
        cell = [self giveMeTopicTopBananerCellView:tableView];
        
    }
    else if(indexPath.section == 1)
    {
        cell = [self giveMePostFollowingCellView:tableView];
        [cell updateCellViewWithInfo:[self.arr_data objectAtIndex:indexPath.row]];
        ((FGPostsFollowingCellView *)cell).indexPathInTable = indexPath;
        ((FGPostsFollowingCellView *)cell).btn_comments.tag = indexPath.row + 1;
        ((FGPostsFollowingCellView *)cell).btn_more.tag = indexPath.row + 1;
    }
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMeTopicTopBananerCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGTopicTopBannerCellView";
    FGTopicTopBannerCellView *cell = (FGTopicTopBannerCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGTopicTopBannerCellView *)[nib objectAtIndex:0];
    }
    cell.lb_topicName.text = str_topicName;
    cell.lb_postCount.text = [NSString stringWithFormat:@"%ld %@",self.totalComment,multiLanguage(@"POST")];
    return cell;
}


-(void)postRequst_getMorePostList
{
    
     NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"GetPost_loadMore" notifyOnVC:[self viewController]];
    NSString *_str_filter = [NSString stringWithFormat:@"#%@",str_topicId];
    [_dic_info setObject:_str_filter forKey:@"Filter"];
    [[NetworkManager_Post sharedManager] postRequest_getPostList:_str_filter keyword:@"" cursor:self.commentCursor count:10 userinfo:_dic_info];
}

-(void)postRequst_getPostList
{
   
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"GetPost" notifyOnVC:[self viewController]];
    NSString *_str_filter = [NSString stringWithFormat:@"#%@",str_topicId];
    [_dic_info setObject:_str_filter forKey:@"Filter"];
    [[NetworkManager_Post sharedManager] postRequest_getPostList:_str_filter keyword:@"" cursor:self.commentCursor count:10 userinfo:_dic_info];
}

-(void)dealloc
{
    
    str_topicName = nil;
    str_topicId = nil;
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
