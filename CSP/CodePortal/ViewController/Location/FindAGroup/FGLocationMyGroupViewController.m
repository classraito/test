//
//  FGLocationMyGroupViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationMyGroupViewController.h"
#import "Global.h"
#import "FGLocationListCellView.h"
#import "FGLocationMyGroupCellView.h"
#import "FGLocationFindAGroupDetailViewController.h"
@interface FGLocationMyGroupViewController ()
{
    NSMutableArray *arr_data;
}
@end

@interface FGLocationMyGroupViewController(TableView)<UITableViewDelegate,UITableViewDataSource>
{
    
}

@end

#pragma mark - FGLocationMyGroupViewController
@implementation FGLocationMyGroupViewController
@synthesize view_section;
@synthesize view_separator_v;
@synthesize btn_comingSoon;
@synthesize btn_history;
@synthesize sectionType;
@synthesize tb;
@synthesize commentCursor;
@synthesize totalComment;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    sectionType = -1;
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];
    // Do any additional setup after loading the view from its nib.
    [commond useDefaultRatioToScaleView:tb];
    [commond useDefaultRatioToScaleView:view_section];
    [commond useDefaultRatioToScaleView:view_separator_v];
    [commond useDefaultRatioToScaleView:btn_comingSoon];
    [commond useDefaultRatioToScaleView:btn_history];
    
    [btn_comingSoon setTitle:multiLanguage(@"UPCOMING") forState:UIControlStateNormal];
    [btn_comingSoon setTitle:multiLanguage(@"UPCOMING") forState:UIControlStateHighlighted];
    [btn_history setTitle:multiLanguage(@"HISTORY") forState:UIControlStateNormal];
    [btn_history setTitle:multiLanguage(@"HISTORY") forState:UIControlStateHighlighted];
    
    btn_comingSoon.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_history.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    tb.delegate = self;
    tb.dataSource = self;
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"MY GROUP");
    [self hideBottomPanelWithAnimtaion:NO];
    
   
    
    
    __weak __typeof(self) weakSelf = self;
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        commentCursor = 0;
        if(sectionType == LocationMyGroupSectionType_COMINGSOON)
        {
            [weakSelf postReqeust_myGroup_comingSoon];
        }
        else if(sectionType == LocationMyGroupSectionType_HISTORY)
        {
            [weakSelf postReqeust_myGroup_history];
        }
    }];
    
    //TODO: 获取更多评论
    [tb addInfiniteScrollingWithActionHandler:^{
        if(sectionType == LocationMyGroupSectionType_COMINGSOON)
        {
            [weakSelf postReqeust_myGroup_comingSoon_getMore];
        }
        else if(sectionType == LocationMyGroupSectionType_HISTORY)
        {
            [weakSelf postReqeust_myGroup_history_getMore];
        }
    }];
    
     [self switchUIBySectionType:LocationMyGroupSectionType_COMINGSOON];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [self.tb setRefreshFooter:nil];
    self.tb.mj_header=nil;
    arr_data = nil;
}


-(void)hideFooterLoadingIfNeeded
{
    [tb.refreshFooter endRefreshing];
    if (commentCursor == -1 || totalComment == 0)
        [tb allowedShowActivityAtFooter:NO];
    else
        [tb allowedShowActivityAtFooter:YES];
}

#pragma mark - 数据绑定
-(void)bindDataToUI_comingSoon
{
    [arr_data removeAllObjects];
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_MyGroupList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    arr_data = [_dic_result objectForKey:@"Groups"];
    
    if([arr_data count] == 0)
    {
        [tb showNoResultWithText:multiLanguage(@"You have't joined any group yet!")];
    }
    
    [tb reloadData];
    
    [tb.mj_header endRefreshing];
    [self  hideFooterLoadingIfNeeded];
    sectionType = LocationMyGroupSectionType_COMINGSOON;
    
}

-(void)bindDataToUI_history
{
    [arr_data removeAllObjects];
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_MyGroupList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    arr_data = [_dic_result objectForKey:@"Groups"];
    if([arr_data count] == 0)
    {
        [tb showNoResultWithText:multiLanguage(@"You have't joined any group yet!")];
    }
    
    [tb reloadData];
    
    [tb.mj_header endRefreshing];
    [self  hideFooterLoadingIfNeeded];
    sectionType = LocationMyGroupSectionType_HISTORY;
}

-(void)loadMoreCommingSoon
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_MyGroupList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:@"Groups"]];
    
    [tb reloadData];
    
    [self  hideFooterLoadingIfNeeded];

}

-(void)loadMoreHistory
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_MyGroupList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:@"Groups"]];
    
    [tb reloadData];
    
    [self  hideFooterLoadingIfNeeded];

}

#pragma mark - 发送请求
-(void)beginRefreshBySectionType:(LocationMyGroupSectionType )__sectionType
{
    commentCursor = 0;
    [tb.mj_header beginRefreshing];
    
}

-(void)postReqeust_myGroup_comingSoon
{
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:@"comingsoon" forKey:@"Filter"];
    
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_myGroupList:MyGroupListType_CommingSoon isFirstPage:YES count:10 userinfo:_dic_info];
}

-(void)postReqeust_myGroup_history
{
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:@"history" forKey:@"Filter"];
   
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_myGroupList:MyGroupListType_History isFirstPage:YES count:10 userinfo:_dic_info];
}

-(void)postReqeust_myGroup_comingSoon_getMore
{
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:@"comingsoon" forKey:@"Filter"];
    [_dic_info setObject:@"GetMyGroup_loadMore" forKey:@"GetMyGroup_loadMore"];
    
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_myGroupList:MyGroupListType_CommingSoon isFirstPage:NO count:10 userinfo:_dic_info];
}

-(void)postReqeust_myGroup_history_getMore
{
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:@"history" forKey:@"Filter"];
    [_dic_info setObject:@"GetMyGroup_loadMore" forKey:@"GetMyGroup_loadMore"];
    
    NetworkManager_Location *manager = [NetworkManager_Location sharedManager];
    [manager postRequest_Locations_myGroupList:MyGroupListType_History isFirstPage:NO count:10 userinfo:_dic_info];
}

#pragma mark - 从父类继承的


-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSLog(@"_dic_requestInfo = %@",_dic_requestInfo);
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    NSString *_str_filter                 = [_dic_requestInfo objectForKey:@"Filter"];
    if ([HOST(URL_LOCATION_MyGroupList) isEqualToString:_str_url]) {
        
        if([@"comingsoon" isEqualToString:_str_filter])
        {
            if([[_dic_requestInfo allKeys] containsObject:@"GetMyGroup_loadMore"])
            {
                [self loadMoreCommingSoon];
            }
            else
            {
                [self bindDataToUI_comingSoon];
            }
        }
        else if([@"history" isEqualToString:_str_filter])
        {
            if([[_dic_requestInfo allKeys] containsObject:@"GetMyGroup_loadMore"])
            {
                [self loadMoreHistory];
            }
            else
            {
                [self bindDataToUI_history];
            }
        }
    }
    
    if ([HOST(URL_LOCATION_LeaveGroup) isEqualToString:_str_url])
    {
        [self beginRefreshBySectionType:LocationMyGroupSectionType_COMINGSOON];
    }
    
    
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}

-(IBAction)buttonAction_commingSoon:(id)_sender
{
    [self switchUIBySectionType:LocationMyGroupSectionType_COMINGSOON];
}

-(IBAction)buttonAction_history:(id)_sender
{
    [self switchUIBySectionType:LocationMyGroupSectionType_HISTORY];
}

#pragma mark - 切换标签
-(void)switchUIBySectionType:(LocationMyGroupSectionType)_sectionType
{
    if(sectionType == _sectionType)
        return;
    
    if(_sectionType == LocationMyGroupSectionType_COMINGSOON)
    {
        [btn_comingSoon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_comingSoon setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btn_history setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn_history setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
    }
    else if(_sectionType == LocationMyGroupSectionType_HISTORY)
    {
        [btn_comingSoon setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn_comingSoon setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn_history setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_history setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    sectionType = _sectionType;
    [tb resetNoResultView];
    [self beginRefreshBySectionType:_sectionType];
}
@end

#pragma mark - FGLocationMyGroupViewController(TableView)
@implementation FGLocationMyGroupViewController(TableView)
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(sectionType == LocationMyGroupSectionType_HISTORY)
    {
        return 100 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    }
    else if(sectionType == LocationMyGroupSectionType_COMINGSOON)
    {
        return 140 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGLocationFindAGroupDetailViewController *vc_group_detail = [[FGLocationFindAGroupDetailViewController alloc] initWithNibName:@"FGLocationFindAGroupDetailViewController" bundle:nil datas:[arr_data objectAtIndex:indexPath.row] isMyGroup:YES];
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
    if(sectionType == LocationMyGroupSectionType_COMINGSOON)
    {
       cell = [self giveMeLocationGroupComingSoonListCell:tableView];
    }
    else if(sectionType == LocationMyGroupSectionType_HISTORY)
    {
        cell = [self giveMeLocationListCell:tableView];
    }
    [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
-(UITableViewCell *)giveMeLocationGroupComingSoonListCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGLocationMyGroupCellView";
    FGLocationMyGroupCellView *cell = (FGLocationMyGroupCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGLocationMyGroupCellView *)[nib objectAtIndex:0];
    }
    return cell;
    
}

-(UITableViewCell *)giveMeLocationListCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGLocationListCellView";
    FGLocationListCellView *cell = (FGLocationListCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGLocationListCellView *)[nib objectAtIndex:0];
    }
    return cell;
    
}


@end
