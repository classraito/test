//
//  FGLikesPickupViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLikesPickupViewController.h"
#import "Global.h"
#import "FGUserPickupTableViewCell.h"
@interface FGLikesPickupViewController ()
{
    
}
@end

@implementation FGLikesPickupViewController
@synthesize tb;
@synthesize arr_data;
@synthesize str_trainingID;
@synthesize str_groupID;
@synthesize commentCursor;
@synthesize totalComment;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil trainingID:(NSString *)_str_trainingID
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_trainingID = _str_trainingID ;
        str_groupID = nil;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil groupId:(NSString *)_str_groupId
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_groupID = _str_groupId ;
        str_trainingID = nil;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SAFE_RemoveSupreView(self.view_topPanel);
    [self hideBottomPanelWithAnimtaion:NO];
    
    [commond useDefaultRatioToScaleView:tb];
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    __weak id weakSelf = self;
    // 下拉刷新
    self.tb.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf postRequest_getList];
    }];
    
    //TODO: 获取更多评论
    [tb addInfiniteScrollingWithActionHandler:^{
        [weakSelf postRequest_getMoreList];
    }];
    
    [self beginRefresh];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
    str_groupID = nil;
    str_trainingID = nil;
    [self.tb setRefreshFooter:nil];
    self.tb.mj_header=nil;
}

-(void)beginRefresh
{
    [tb.mj_header beginRefreshing];
}

-(void)hideFooterLoadingIfNeeded
{
    
    [tb.refreshFooter endRefreshing];
    if (commentCursor == -1 || totalComment == 0)
        [tb allowedShowActivityAtFooter:NO];
    else
        [tb allowedShowActivityAtFooter:YES];
}


-(void)postRequest_getList
{
    if(str_groupID)
    {
        NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
        [[NetworkManager_Location sharedManager] postRequest_Locations_groupParticipant:str_groupID isFirstPage:YES count:10 userinfo:_dic_info];
    }
    
    if(str_trainingID)
    {
        NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
        [[NetworkManager_Training sharedManager] postRequest_GetTrainLikeList:YES count:10 trainingID:str_trainingID userinfo:_dic_info];
    }
}

-(void)postRequest_getMoreList
{
    if(str_groupID)
    {
        NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
        [_dic_info setObject:@"LoadMore" forKey:@"LoadMore"];
        [[NetworkManager_Location sharedManager] postRequest_Locations_groupParticipant:str_groupID isFirstPage:NO count:10 userinfo:_dic_info];
    }
    
    if(str_trainingID)
    {
        NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
        [_dic_info setObject:[NetworkManager giveHashCodeByObj:self] forKey:KEY_NOTIFY_IDENTIFIER];
        [_dic_info setObject:@"LoadMore" forKey:@"LoadMore"];
        [[NetworkManager_Training sharedManager] postRequest_GetTrainLikeList:NO count:10 trainingID:str_trainingID userinfo:_dic_info];
    }

}

-(void)bindDataToUI
{
    NSString *str_url = @"";
    NSString *str_jsonKey = @"";
    if(str_groupID)
    {
        str_url = HOST(URL_LOCATION_GroupParticipant);
        str_jsonKey = @"Participants";
    }
    
    if(str_trainingID)
    {
         str_url = HOST(URL_TRAINING_GetTrainLikeList);
        str_jsonKey = @"Likes";
    }
    
    [arr_data removeAllObjects];
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:str_url];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:str_jsonKey]];
    tb.delegate = self;
    tb.dataSource = self;
    [tb reloadData];
    [tb.mj_header endRefreshing];
    [self  hideFooterLoadingIfNeeded];
}

-(void)loadMoreData
{
    NSString *str_url = @"";
    NSString *str_jsonKey = @"";
    if(str_groupID)
    {
        str_url = HOST(URL_LOCATION_GroupParticipant);
        str_jsonKey = @"Participants";
    }
    
    if(str_trainingID)
    {
        
        str_url = HOST(URL_TRAINING_GetTrainLikeList);
        str_jsonKey = @"Likes";
    }
    NSLog(@"str_url = %@",str_url);
    NSLog(@"str_jsonKey = %@",str_jsonKey);
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:str_url];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:str_jsonKey]];
    [tb reloadData];
    [self  hideFooterLoadingIfNeeded];
}

#pragma mark - 从父类继承的
-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    BOOL isLoadMore = [[_dic_requestInfo allKeys] containsObject:@"LoadMore"];
    if ([HOST(URL_TRAINING_GetTrainLikeList) isEqualToString:_str_url] || [HOST(URL_LOCATION_GroupParticipant) isEqualToString:_str_url]) {
        if(isLoadMore)
        {
            [self loadMoreData];
        }
        else
        {
            [self bindDataToUI];
        }
        
    }

    
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}
@end



@implementation FGLikesPickupViewController(TableView)

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *_dic_info = [arr_data objectAtIndex:indexPath.row];
    NSString *_str_userID = [_dic_info objectForKey:@"UserId"];
    [self.popupController dismissWithCompletion:^{
        FGControllerManager *manager = [FGControllerManager sharedManager];
        FGFriendProfileViewController *vc_friendProfile = [[FGFriendProfileViewController alloc] initWithNibName:@"FGFriendProfileViewController" bundle:nil withFriendId:_str_userID];
        [manager pushController:vc_friendProfile navigationController:nav_current];
    }];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50 * ratioH;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    cell = [self giveMePickupCellView:tableView];
    ((FGUserPickupTableViewCell *)cell).listType = ListType_User;
    [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMePickupCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGUserPickupTableViewCell";
    FGUserPickupTableViewCell *cell = (FGUserPickupTableViewCell *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGUserPickupTableViewCell *)[nib objectAtIndex:0];
        
    }
    return cell;
}


@end
