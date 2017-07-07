//
//  FGPostAllPostsCollectView.m
//  CSP
//
//  Created by Ryan Gong on 16/10/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPostAllPostsCollectView.h"
#import "Global.h"
#import "FGPostSectionTitleView.h"
#import "FGPostCollectionViewCell.h"
#import "FGPostSectionTitleView.h"
#import "XLPlainFlowLayout.h"
#import "NetworkManager_Post.h"
#import "FGPostCommentDetailViewController.h"
#import "FGPostCameraButtonCollectionCell.h"
#define cellWith (106 * ratioW)
#define cellHeight (106 * ratioH)
#define cellWith_cameraButton (320 * ratioW)
#define cellHeight_cameraButton (60 * ratioH)
#define CELLSIZE(width, height) CGSizeMake(width, height);

@interface FGPostAllPostsCollectView()
{
    NSInteger commentCursor;
    NSInteger totalComment;
}
@end

// 注意const的位置
static NSString *const cellId_buttonCell   = @"FGPostCameraButtonCollectionCell";
static NSString *const cellId_imageCell   = @"FGPostCollectionViewCell";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";

@implementation FGPostAllPostsCollectView
@synthesize cv_allPosts;
@synthesize arr_data;
@synthesize view_cameraButton;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:cv_allPosts];
    [self internalInitalCollectionView];
    
    commentCursor = 0;
    
    __weak __typeof(self) weakSelf = self;
    cv_allPosts.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        commentCursor = 0;
        [weakSelf postRequst_getAllPostList];
    }];
    
    //TODO: 获取更多评论
    [cv_allPosts addInfiniteScrollingWithActionHandler:^{
        // 后台执行：
        [weakSelf postReqeust_getMorePostList];
    }];
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.arr_data = nil;
    view_cameraButton = nil;
}

-(void)beginRefresh
{
    [cv_allPosts.mj_header beginRefreshing];
    [NetworkEventTrack track:KEY_TRACK_EVENTID_GETPOST attrs:nil];//追踪 getPost
}

- (void)internalInitalCollectionView {
    //创建一个layout布局类
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    XLPlainFlowLayout *layout = [XLPlainFlowLayout new];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CELLSIZE(cellWith, cellWith);
    layout.naviHeight                    = 0;
    cv_allPosts.collectionViewLayout = layout;
    
    cv_allPosts.backgroundColor = [UIColor whiteColor];
    cv_allPosts.dataSource      = self;
    cv_allPosts.delegate        = self;
    
    // 注册cell、sectionHeader、sectionFooter
    [cv_allPosts registerClass:[FGPostCameraButtonCollectionCell class] forCellWithReuseIdentifier:cellId_buttonCell];
    [cv_allPosts registerClass:[FGPostCollectionViewCell class] forCellWithReuseIdentifier:cellId_imageCell];

    
    //注册头部视图
    [cv_allPosts registerNib:[UINib nibWithNibName:NSStringFromClass([FGPostSectionTitleView class]) bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:headerId];
}

-(void)internalInitalCameraButton
{
    if(view_cameraButton)
        return;
    
    view_cameraButton = (FGPostCameraButtonView *)[[[NSBundle mainBundle] loadNibNamed:@"FGPostCameraButtonView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_cameraButton];
    CGRect _frame = view_cameraButton.frame;
    _frame.origin.y = -view_cameraButton.frame.size.height;
    view_cameraButton.frame = _frame;
    [cv_allPosts addSubview:view_cameraButton];
}

-(void)setupScrollViewFeature
{
    if(!view_cameraButton)
        return;
    
    cv_allPosts.contentInset = UIEdgeInsetsMake(view_cameraButton.frame.size.height,0,0,0);
}

#pragma mark - UICollectionViewDataSource
//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(section == 0)
        return 1;
    else if(section == 1)
        return [self.arr_data count];
    
    return 0;
}

//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
    {
        FGPostCameraButtonCollectionCell *cell = (FGPostCameraButtonCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId_buttonCell forIndexPath:indexPath];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        FGPostCollectionViewCell *cell = (FGPostCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId_imageCell forIndexPath:indexPath];
        NSDictionary *cellInfo       = self.arr_data[indexPath.row];
        [cell setupPostThumbnailByUrlPath:cellInfo];
         return cell;
    }
   
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
    {
        return CELLSIZE(cellWith_cameraButton, cellHeight_cameraButton);
    }
    else if(indexPath.section == 1)
    {
        return CELLSIZE(cellWith, cellHeight);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0f;
}
//定义header的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if(section == 0)
    {
        return CGSizeZero;
    }
    else if(section == 1)
    {
        return CGSizeMake(self.frame.size.width, 40 * ratioH);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1)
    {
        UICollectionReusableView *reusableview = nil;
        if (kind == UICollectionElementKindSectionHeader) {
            FGPostSectionTitleView *headerView = (FGPostSectionTitleView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId forIndexPath:indexPath];
            headerView.alpha = .95;
            reusableview = headerView;
        }
        return reusableview;
    }
    else
        return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"indexPath = %@",indexPath);
    if(indexPath.section == 1)
    {
        FGControllerManager *manager = [FGControllerManager sharedManager];
        FGPostCommentDetailViewController *vc_commentDetail = [[FGPostCommentDetailViewController alloc] initWithNibName:@"FGPostCommentDetailViewController" bundle:nil postInfo:[arr_data objectAtIndex:indexPath.row]];
        [manager pushController:vc_commentDetail navigationController:nav_current];
    }
    
}

-(void)hideFooterLoadingIfNeeded
{
    [cv_allPosts.refreshFooter endRefreshing];
    if (commentCursor == -1 || totalComment == 0)
        [cv_allPosts allowedShowActivityAtFooter:NO];
    else
        [cv_allPosts allowedShowActivityAtFooter:YES];
}

-(void)bindDataToUI;
{
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetPostList) alias:@"AllPost"];
    [arr_data removeAllObjects];
    
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    arr_data = [_dic_result objectForKey:@"Posts"];
    
    [self.cv_allPosts reloadData];
    [cv_allPosts.mj_header endRefreshing];
    [self hideFooterLoadingIfNeeded];
}

- (void)loadMorePosts {
   
        NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_POST_GetPostList) alias:@"AllPost_loadMore"];
        commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
        totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
        [arr_data addObjectsFromArray:[_dic_result objectForKey:@"Posts"]];
        
        [self.cv_allPosts reloadData];
        [self hideFooterLoadingIfNeeded];

}

-(void)postRequst_getAllPostList
{
   
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"AllPost" notifyOnVC:[self viewController]  repelKEY:@"REPEL_POST"];
    [[NetworkManager_Post sharedManager] postRequest_getPostList:@"" keyword:@"" cursor:commentCursor count:24 userinfo:_dic_info];
}

-(void)postReqeust_getMorePostList
{
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"AllPost_loadMore" notifyOnVC:[self viewController]  repelKEY:@"REPEL_POST"];
    [[NetworkManager_Post sharedManager] postRequest_getPostList:@"" keyword:@"" cursor:commentCursor count:24 userinfo:_dic_info];
}
@end
