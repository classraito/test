//
//  FGTrainingWorkOutListView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingHomePageView.h"
#import "Global.h"
#import "FGTrainingWorkoutCellView.h"
#import "FGTrainingBrowserByTypeCellView.h"
#import "FGTrainingWorkoutTypeCellView.h"
#import "FGTrainingWorkOutListViewController.h"
#import "FGTrainingDetailViewController.h"

@interface FGTrainingHomePageView()
{
    NSMutableArray *arr_workoutTypeImgs;
}
@end

@implementation FGTrainingHomePageView
@synthesize tb;
@synthesize currentSectionType;
@synthesize view_trainingSection;
@synthesize arr_dataInTable;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self internalInital];
    
}

-(void)internalInital
{
    tb.delegate = self;
    tb.dataSource = self;
    [commond useDefaultRatioToScaleView:tb];
    arr_dataInTable = [[NSMutableArray alloc] init];
    arr_workoutTypeImgs = [[NSMutableArray alloc] initWithCapacity:1];
    [self internalInitalTrainingSectionView];
    
    __weak FGTrainingHomePageView *weakSelf = self;
//    [tb addPullToRefreshWindowsStyleWithActionHandler:^{
//        [weakSelf postRequestByStatus:currentSectionType];
//    }];
//    [tb triggerSetProgressTintColor:[UIColor blackColor]];
    tb.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf postRequestByStatus:currentSectionType];
    }];
}

-(void)beginRefresh
{
    [tb.mj_header beginRefreshing];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_trainingSection.delegate = nil;
    view_trainingSection = nil;
    arr_dataInTable = nil;
    arr_workoutTypeImgs = nil;
    tb.delegate = nil;
    tb.dataSource = nil;
}


#pragma mark - 初始化FGTrainingTableSectionView
-(void)internalInitalTrainingSectionView
{
    if(view_trainingSection)
        return;
    view_trainingSection = (FGTrainingTableSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingTableSectionView" owner:nil options:nil] objectAtIndex:0];
    [view_trainingSection buttonAction_workouts:nil];
    view_trainingSection.delegate = self;
    [commond useDefaultRatioToScaleView:view_trainingSection];
    currentSectionType = TraingHomePage_SectionType_WorkOuts;
    [self fillWorkoutSectionDatasManully];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    if(indexPath.section == 0)
//    {
//        return 154 * ratioH;//FGTrainingHomePageTopBannerCellView的高度,这个数字是在xib中定义的原始高度
//    }
//    else
//    {
        if(currentSectionType == TraingHomePage_SectionType_Featured)
        {
            return 154 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
        }
        else if(currentSectionType == TraingHomePage_SectionType_VIP)
        {
            return 154 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
        }
        else if(currentSectionType == TraingHomePage_SectionType_WorkOuts)
        {
            
                return 102 * ratioH; //FGTrainingWorkoutTypeCellView的高度,这个数字是在xib中定义的原始高度
        }

//    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
//    if(section == 0)
//        return 0;
//    else
        return view_trainingSection.frame.size.height;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
//    if(section == 0)
//        return nil;
//    else
        return view_trainingSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
        if(currentSectionType == TraingHomePage_SectionType_WorkOuts)
        {
                WorkoutType _currentWorkoutType = (int)indexPath.row;
                [self go2TrainingWorkoutListViewController:[arr_dataInTable objectAtIndex:indexPath.row] workoutType:_currentWorkoutType];
            
        }
        else
        {
            id workoutId = [[arr_dataInTable objectAtIndex:indexPath.row] objectForKey:@"TrainingId"];
            FGControllerManager *manager = [FGControllerManager sharedManager];
            FGTrainingDetailViewController *vc_trainingDetail = [[FGTrainingDetailViewController alloc] initWithNibName:@"FGTrainingDetailViewController" bundle:nil workoutID:workoutId];
            [manager pushController:vc_trainingDetail navigationController:nav_current];
        }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
//    if(section == 0)
//        return 1;
//    else
        return [arr_dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
//    if(indexPath.section == 0)
//    {
//        cell = [self giveMeTrainingHomePageTopBannerCell:tableView];
//    }
//    else
//    {
        if (currentSectionType == TraingHomePage_SectionType_Featured||
            currentSectionType == TraingHomePage_SectionType_VIP)
        {
            
            cell = [self giveMeTrainingWorkoutCell:tableView];
            [cell updateCellViewWithInfo:[arr_dataInTable objectAtIndex:indexPath.row]];
            
        } else if (currentSectionType == TraingHomePage_SectionType_WorkOuts) {
            
                cell = [self giveMeWorkoutTypeCell:tableView];
                [cell updateCellViewWithInfo:[arr_dataInTable objectAtIndex:indexPath.row]];
            NSString *_str_url = [arr_workoutTypeImgs objectAtIndex:indexPath.row];
            NSLog(@"_str_url = %@",_str_url);
            FGTrainingWorkoutTypeCellView *cell_workoutType = (FGTrainingWorkoutTypeCellView *)cell;
            cell_workoutType.iv_thumbnail.image = [UIImage imageNamed:_str_url];
        }
//    }
    return cell;
}

#pragma mark - 利用scrollView 实现顶部的一个缩放特效
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*if(scrollView.contentOffset.y < 0 )
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0  inSection:0];
        UITableViewCell *curCell = [tb cellForRowAtIndexPath:indexPath];
        if([curCell isKindOfClass:[FGTrainingHomePageTopBannerCellView class]])
        {
            FGTrainingHomePageTopBannerCellView *cell = (FGTrainingHomePageTopBannerCellView *)curCell;
            CGFloat scalePercent = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
            cell.iv_banner.transform = CGAffineTransformMakeScale(1 + scalePercent * 3, 1 + scalePercent * 3);
            CGRect _frame = cell.iv_banner.frame;
            _frame.origin.y = scrollView.contentOffset.y;
            cell.iv_banner.frame = _frame;
        }
    }*/
   
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

-(UITableViewCell *)giveMeBrowserByTypeCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGTrainingBrowserByTypeCellView";
    FGTrainingBrowserByTypeCellView *cell = (FGTrainingBrowserByTypeCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGTrainingBrowserByTypeCellView *)[nib objectAtIndex:0];
        cell.delegate = self;
    }
    return cell;
}

-(UITableViewCell *)giveMeWorkoutTypeCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGTrainingWorkoutTypeCellView";
    FGTrainingWorkoutTypeCellView *cell = (FGTrainingWorkoutTypeCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGTrainingWorkoutTypeCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

-(UITableViewCell *)giveMeTrainingHomePageTopBannerCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGTrainingHomePageTopBannerCellView";
    FGTrainingHomePageTopBannerCellView *cell = (FGTrainingHomePageTopBannerCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGTrainingHomePageTopBannerCellView *)[nib objectAtIndex:0];
    }
    return cell;
}


#pragma mark - FGTrainingTableSectionViewDelegate
#pragma mark - FGTrainingTableSectionViewDelegate
-(void)didSelectedSection:(TraingHomePage_SectionType)_currentSectionType
{
    [tb resetNoResultView];
//    currentSectionType = _currentSectionType;
    [self postRequestByStatus:_currentSectionType];
//    [self beginRefresh];
}

#pragma mark - 进入到FGTrainingWorkOutListViewController
-(void)go2TrainingWorkoutListViewController:(NSString *)_str_title workoutType:(WorkoutType)_workoutType
{
    _str_title = [_str_title stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingWorkOutListViewController *vc_workoutList = [[FGTrainingWorkOutListViewController alloc] initWithNibName:@"FGTrainingWorkOutListViewController" bundle:nil title:_str_title workoutType:_workoutType];
    [manager pushController:vc_workoutList navigationController:nav_current];
}

#pragma mark - 填充workouts状态下的table数据
-(void)fillWorkoutSectionDatasManully
{
    [arr_dataInTable removeAllObjects];
    [arr_dataInTable addObject:multiLanguage(@"SINGLE WITH\nEQUIPMENT")];
    [arr_dataInTable addObject:multiLanguage(@"SINGLE WITH NO\nEQUIPMENT")];
    [arr_dataInTable addObject:multiLanguage(@"INTERMEDIATE WITH\nEQUIPMENT")];
    [arr_dataInTable addObject:multiLanguage(@"INTERMEDIATE WITH\nNO EQUIPMENT")];
    [arr_dataInTable addObject:multiLanguage(@"ADVANCED WITH\nEQUIPMENT")];
    [arr_dataInTable addObject:multiLanguage(@"ADVANCED WITH\nNO EQUIPMENT")];
    
    [arr_workoutTypeImgs removeAllObjects];
    [arr_workoutTypeImgs addObject:@"WorkoutSelection_Equipment_Beginner.jpg"];
    [arr_workoutTypeImgs addObject:@"WorkoutSelection_NoEquipment_Beginner.jpg"];
    [arr_workoutTypeImgs addObject:@"WorkoutSelection_Equipment_Intermediate.jpg"];
    [arr_workoutTypeImgs addObject:@"WorkoutSelection_NoEquipment_Intermediate.jpg"];
    [arr_workoutTypeImgs addObject:@"WorkoutSelection_Equipment_Advanced.jpg"];
    [arr_workoutTypeImgs addObject:@"WorkoutSelection_NoEquipment_Advanced.jpg"];
   
    
    [tb reloadData];
    [self scrollViewDidScroll:tb];
}

#pragma mark - 把网络来的数据绑定到UI
-(void)bindDataToUIByStatus:(TraingHomePage_SectionType)_sectionType
{
    [arr_dataInTable removeAllObjects];
    
    currentSectionType = _sectionType;
    if(currentSectionType == TraingHomePage_SectionType_Featured)
    {
        NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetFeaturedVideoList)];
        arr_dataInTable = [_dic_info objectForKey:@"Trains"];
        
    }
    else if(currentSectionType == TraingHomePage_SectionType_VIP)
    {
        NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetVIPVideoList)];
        arr_dataInTable = [_dic_info objectForKey:@"Trains"];
    }
    
    if([arr_dataInTable count] == 0)
    {
        [tb showNoResultWithText:multiLanguage(@"The VIP workout is comming soon...")];
    }
    
    
//    [tb triggerStopRefresh];
    [tb.mj_header endRefreshing];
    [tb reloadData];
    [self scrollViewDidScroll:tb];
}

-(void)postRequestByStatus:(TraingHomePage_SectionType)_secionTypeNeedReqeust
{

    NSMutableDictionary *_dic_userinfo = [NSMutableDictionary dictionaryWithCapacity:1];
    [_dic_userinfo setObject:[NSNumber numberWithInteger:_secionTypeNeedReqeust ] forKey:KEY_USERINFO_TRAINING_SECTIONTYPE];
    [_dic_userinfo setObject:[NetworkManager giveHashCodeByObj:[self viewController]] forKey:KEY_NOTIFY_IDENTIFIER];
    
    if(_secionTypeNeedReqeust == TraingHomePage_SectionType_Featured)
    {
//        [tb triggerStartRefresh];
        [[NetworkManager_Training sharedManager] postRequest_GetFeaturedVideoList:YES count:10 userinfo:_dic_userinfo];
    }
    else if(_secionTypeNeedReqeust == TraingHomePage_SectionType_VIP)
    {
//        [tb triggerStartRefresh];
        [[NetworkManager_Training sharedManager] postReqeust_GetVIPVideoList:YES count:10 userinfo:_dic_userinfo];
    }
    else if(_secionTypeNeedReqeust == TraingHomePage_SectionType_WorkOuts)
    {
        currentSectionType = _secionTypeNeedReqeust;
        [self fillWorkoutSectionDatasManully];
//        [tb triggerStopRefresh];
        [tb.mj_header endRefreshing];
    }
}

#pragma mark - FGTrainingBrowserByTypeCellViewDelegate
-(void)browserByTypeDidSelected:(NSString *)_str_typename workoutType:(WorkoutType)_currentWorkOutType
{
    [self go2TrainingWorkoutListViewController:_str_typename workoutType:_currentWorkOutType];
}
@end
