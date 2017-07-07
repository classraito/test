//
//  FGProfileFitnessLevelTestHomeViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileFitnessLevelTestHomeViewController.h"

@interface FGProfileFitnessLevelTestHomeViewController ()
{
    NSMutableArray *arr_subTitleNames;
    NSMutableArray *arr_keyNames;
}
@property(nonatomic,strong)NSMutableArray *arr_data;
@end

#pragma mark - FGProfileFitnessLevelTestHomeViewController
@implementation FGProfileFitnessLevelTestHomeViewController
@synthesize arr_data;
@synthesize tb;
@synthesize commentCursor;
@synthesize totalComment;
- (void)viewDidLoad {
    [super viewDidLoad];
    [commond useDefaultRatioToScaleView:tb];
    
    self.view_topPanel.str_title = multiLanguage(@"FITNESS LEVEL TEST");
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_right.hidden = YES;
    [self hideBottomPanelWithAnimtaion:NO];
    
    arr_data = [[NSMutableArray alloc] initWithCapacity:1];

    
    arr_subTitleNames = [@[multiLanguage(@"Push-ups"),multiLanguage(@"Situps"),
                          multiLanguage(@"Squats"),
                          multiLanguage(@"Plank")] mutableCopy];
    arr_keyNames = [@[@"PushUp",@"Situps",@"Squats",@"Plank"]mutableCopy];
    
    __weak __typeof(self) weakSelf = self;
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        commentCursor = 0;
        [weakSelf postRequest_getFitnessList];
    }];
    
    //TODO: 获取更多评论
    [tb addInfiniteScrollingWithActionHandler:^{
        [self postRequest_getMoreFitnessList];
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
    [tb.mj_header beginRefreshing];

}

-(void)buttonAction_left:(id)_sender
{
    tb.mj_header = nil;
    [tb setRefreshFooter:nil];
    
    [super buttonAction_left:_sender];
    
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
    arr_subTitleNames = nil;
    arr_keyNames = nil;
}

-(void)hideFooterLoadingIfNeeded
{
    
    [tb.refreshFooter endRefreshing];
    if (commentCursor == -1 || totalComment == 0)
        [tb allowedShowActivityAtFooter:NO];
    else
        [tb allowedShowActivityAtFooter:YES];
}

-(void)bindDataToUI
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_FitnessTestList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    tb.delegate = self;
    tb.dataSource = self;
    
    arr_data = [_dic_result objectForKey:@"FitnessTests"];
    for(NSMutableDictionary *_dic_singleData in arr_data)
    {
        [_dic_singleData setObject:[NSNumber numberWithBool:NO] forKey:@"isGroupOpen"];
    }
    [tb reloadData];
    
    [tb.mj_header endRefreshing];
    [self  hideFooterLoadingIfNeeded];
}

-(void)loadMoreFitness
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_PROFILE_FitnessTestList)];
    commentCursor = [[_dic_result objectForKey:@"Cursor"] intValue];
    totalComment = [[_dic_result objectForKey:@"TotalCount"] intValue];
    
    [arr_data addObjectsFromArray:[_dic_result objectForKey:@"FitnessTests"]];
    for(NSMutableDictionary *_dic_singleData in arr_data)
    {
        [_dic_singleData setObject:[NSNumber numberWithBool:NO] forKey:@"isGroupOpen"];
    }
    [tb reloadData];
    [self  hideFooterLoadingIfNeeded];
}

-(void)postRequest_getFitnessList
{
   
    [[NetworkManager_Profile sharedManager] postRequest_Profile_FitnessTestList:YES count:10 userinfo:nil];
}

-(void)postRequest_getMoreFitnessList
{
    NSMutableDictionary *_dic_userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_userinfo setObject:@"LoadMoreFitness" forKey:@"LoadMoreFitness"];
    [[NetworkManager_Profile sharedManager] postRequest_Profile_FitnessTestList:NO count:10 userinfo:_dic_userinfo];
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    
    if ([HOST(URL_PROFILE_FitnessTestList) isEqualToString:_str_url]) {
        if([[_dic_requestInfo allKeys] containsObject:@"LoadMoreFitness"])
        {
            [self loadMoreFitness];
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


#pragma mark - FGProfileFitnessLevelTestHomeViewController(TableView)
@implementation FGProfileFitnessLevelTestHomeViewController(TableView)
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0)
    {
        return 160 * ratioH;
    }
    else
    {
        return 44 * ratioH;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
        return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];

    
    if([curCell isKindOfClass:[FGFitnessTestGroupCellView class]])
    {
        NSMutableDictionary *_dic_singleOriginalData = [arr_data objectAtIndex:indexPath.row];
        BOOL isGroupOpen = [[_dic_singleOriginalData objectForKey:@"isGroupOpen"] boolValue];
        if(isGroupOpen)//已经打开过问题
        {
            [_dic_singleOriginalData setObject:[NSNumber numberWithBool:NO] forKey:@"isGroupOpen"];
            
            NSMutableArray *arrInsertRows = [NSMutableArray arrayWithCapacity:1];
            for(int i=0;i<[arr_subTitleNames count];i++)
            {
                NSIndexPath *selectedAnswerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:indexPath.section];
                
                [arr_data removeObjectAtIndex:indexPath.row + 1];
                
                [arrInsertRows addObject:selectedAnswerIndexPath];
            }
            
            [tb beginUpdates];
            [tb deleteRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationNone];
            [tb endUpdates];
        }
        else//没有打开过问题
        {
            
            [_dic_singleOriginalData setObject:[NSNumber numberWithBool:YES] forKey:@"isGroupOpen"];
            
            NSMutableArray *arrInsertRows = [NSMutableArray arrayWithCapacity:1];
            for(int i=0;i<[arr_subTitleNames count];i++)
            {
                NSString *_str_subTitle = [arr_subTitleNames objectAtIndex:i];
                NSString *_str_keyName = [arr_keyNames objectAtIndex:i];
                NSIndexPath *selectedAnswerIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:indexPath.section];
                
                NSMutableDictionary *_dic_inserted = [_dic_singleOriginalData mutableCopy];
                [_dic_inserted setObject:[NSNumber numberWithBool:YES] forKey:@"isSubCell"];
                [_dic_inserted setObject:_str_subTitle forKey:@"key"];
                [_dic_inserted setObject:[_dic_singleOriginalData objectForKey:_str_keyName] forKey:@"value"];
                
                [arr_data insertObject:_dic_inserted atIndex:selectedAnswerIndexPath.row];
                [arrInsertRows addObject:selectedAnswerIndexPath];
                _dic_inserted = nil;
            }
            
            [tb beginUpdates];
            [tb insertRowsAtIndexPaths:arrInsertRows withRowAnimation:UITableViewRowAnimationNone];
            [tb endUpdates];
            
        }
    }

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
        return 1;
    }
    else if(section == 1)
    {
         return [arr_data count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
    {
        cell = [self giveMeFitnessTopBannerCellView:tableView];
    }
    else if(indexPath.section == 1)
    {
        NSMutableDictionary *_dic_singleData = [arr_data objectAtIndex:indexPath.row];
        if([[_dic_singleData allKeys] containsObject:@"isSubCell"])
        {
            cell = [self giveMeFitnessCellView:tableView];
            [(FGFitnessCellView *)cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
        }
        else
        {
            cell = [self giveMeFitnessTestGroupCellView:tableView];
            [(FGFitnessTestGroupCellView *)cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
        }
        [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    }
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMeFitnessTestGroupCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGFitnessTestGroupCellView";
    FGFitnessTestGroupCellView *cell = (FGFitnessTestGroupCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGFitnessTestGroupCellView *)[nib objectAtIndex:0];
//        NSLog(@"::::::::>init FGFitnessTestGroupCellView %@",cell);
        
    }
    return cell;
}

-(UITableViewCell *)giveMeFitnessCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGFitnessCellView";
    FGFitnessCellView *cell = (FGFitnessCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGFitnessCellView *)[nib objectAtIndex:0];
        
    }
    
    return cell;
}

-(UITableViewCell *)giveMeFitnessTopBannerCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGFitnessTestTopBannerCellView";
    FGFitnessTestTopBannerCellView *cell = (FGFitnessTestTopBannerCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGFitnessTestTopBannerCellView *)[nib objectAtIndex:0];
        
    }
    return cell;
}


-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}
@end
