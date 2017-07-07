//
//  FGTrainingWorkoutListView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingWorkoutListView.h"
#import "Global.h"
#import "FGTrainingWorkoutCellView.h"
#import "FGTrainingDetailViewController.h"
@interface FGTrainingWorkoutListView()
{
    
}
@end

@implementation FGTrainingWorkoutListView
@synthesize tb;
@synthesize workoutType;
@synthesize arr_dataInTable;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    tb.delegate = self;
    tb.dataSource = self;
    [commond useDefaultRatioToScaleView:tb];
    arr_dataInTable = [[NSMutableArray alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf postReqeust];
    }];
}

-(void)beginRefresh
{
    [tb.mj_header beginRefreshing];
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_dataInTable = nil;
    tb.delegate = nil;
    tb.dataSource = nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
   
    return 154 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    id _workoutID = [[arr_dataInTable objectAtIndex:indexPath.row] objectForKey:@"TrainingId"];
    FGTrainingDetailViewController *vc_trainingDetail = [[FGTrainingDetailViewController alloc] initWithNibName:@"FGTrainingDetailViewController" bundle:nil workoutID:_workoutID];
    [manager pushController:vc_trainingDetail navigationController:nav_current];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return [arr_dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    cell = [self giveMeTrainingWorkoutCell:tableView];
    
    [cell updateCellViewWithInfo:[arr_dataInTable objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - 初始化TableViewCell
-(UITableViewCell *)giveMeTrainingWorkoutCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGTrainingWorkoutCellView";
    FGTrainingWorkoutCellView *cell = (FGTrainingWorkoutCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGTrainingWorkoutCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

-(void)postReqeust
{
    NetworkManager_Training *network_training = [NetworkManager_Training sharedManager];
    NSMutableDictionary *_dic_info = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_info setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
    [network_training postReqeust_GetWorkoutVideoList:YES count:10 workoutType:workoutType userinfo:_dic_info];
}

#pragma mark - 把网络来的数据绑定到UI
-(void)bindDataToUI
{
    NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetWorkoutVideoList)];
    arr_dataInTable = [_dic_info objectForKey:@"Trains"];
    
    
    
    [tb reloadData];
    
    [tb.mj_header endRefreshing];
}
@end
