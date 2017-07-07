//
//  FGLocationJoinAGroupListView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationJoinAGroupListView.h"
#import "Global.h"
#import "FGLocationListCellView.h"
#import "FGLocationFindAGroupDetailViewController.h"
@interface FGLocationJoinAGroupListView()
{
    NSMutableArray *arr_data;
}
@end

@implementation FGLocationJoinAGroupListView
@synthesize tb;
@synthesize commentCursor;
@synthesize totalComment;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    [commond useDefaultRatioToScaleView:tb];
    
    __weak __typeof(self) weakSelf = self;
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        commentCursor = 0;
        [weakSelf postRequst_getGroupList];
    }];
    
    //TODO: 获取更多评论
    [tb addInfiniteScrollingWithActionHandler:^{
        [self postRequst_getMoreGroupList];
    }];

}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 100 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationFindAGroupDetailViewController *vc_group_detail = [[FGLocationFindAGroupDetailViewController alloc] initWithNibName:@"FGLocationFindAGroupDetailViewController" bundle:nil datas:[arr_data objectAtIndex:indexPath.row]];
    [manager pushController:vc_group_detail navigationController:nav_current];
    
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
    
    cell = [self giveMeLocationGroupListCell:tableView];
    [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
-(UITableViewCell *)giveMeLocationGroupListCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGLocationListCellView";
    FGLocationListCellView *cell = (FGLocationListCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGLocationListCellView *)[nib objectAtIndex:0];
    }
    return cell;
    
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

#pragma mark - loadData
-(void)bindDataToUI
{
    [arr_data removeAllObjects];
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_GroupList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    arr_data = [_dic_result objectForKey:@"Groups"];
    [tb resetNoResultView];
    if([arr_data count] == 0)
    {
        [tb showNoResultWithText:multiLanguage(@"No group yet!")];
    }
    
    tb.delegate = self;
    tb.dataSource = self;
    [tb reloadData];
    
    [tb.mj_header endRefreshing];
    [self  hideFooterLoadingIfNeeded];
    [self updateMapViewAnnotation];
}

-(void)loadMoreGroupList
{
    
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_GroupList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:@"Groups"]];
    [tb reloadData];
    [self  hideFooterLoadingIfNeeded];
    [self updateMapViewAnnotation];
    
}

-(void)updateMapViewAnnotation
{
    FGLocationFindAGroupViewController *vc = (FGLocationFindAGroupViewController *)[self viewController];
    [vc updateMapViewAnnotationByData:arr_data];
}

#pragma mark - post
-(void)postRequst_getGroupList
{
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {
        if(_lat != DEFAULT_LATITUDE && _lng != DEFAULT_LONTITUDE)
        {
            long lat = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLatitude];
            long lng = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLontitude];
            NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
            [manager postRequest_Locations_groupList:YES count:10 lat:lat lng:lng userinfo:nil];
        }
    }];
    
    
}

-(void)postRequst_getMoreGroupList
{
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {
        if(_lat != DEFAULT_LATITUDE && _lng != DEFAULT_LONTITUDE)
        {
            NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
            [_dic_info setObject:@"GetGroupList_loadMore" forKey:@"GetGroupList_loadMore"];
            NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
            long lat = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLatitude];
            long lng = [commond EnCodeCoordinate:[FGLocationManagerWrapper sharedManager].currentLontitude];
            [manager postRequest_Locations_groupList:NO count:10 lat:lat lng:lng userinfo:_dic_info];
        }
        
    }];
   
}
@end
