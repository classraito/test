//
//  FGTrainingEditScheduleViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingEditScheduleViewController.h"
#import "Global.h"
#import "FGTrainingSetPlanScheduleCellView.h"
#import "FGTrainingSetPlanModel.h"
@interface FGTrainingEditScheduleViewController ()
{
    NSMutableArray *arr_sectionViews;
    FGTrainingSetPlanModel *setPlanModel;
    NSIndexPath *currentEditedIndexPath;
}
@end



@implementation FGTrainingEditScheduleViewController
@synthesize tb;
@synthesize view_sectionTitle;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    arr_sectionViews = [[NSMutableArray alloc] initWithCapacity:1];
    
    self.view_topPanel.str_title = multiLanguage(@"Edit entire schedule");
    [self hideBottomPanelWithAnimtaion:NO];
    [commond useDefaultRatioToScaleView:tb];
    
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"DONE") forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"DONE") forState:UIControlStateHighlighted];
    self.view_topPanel.btn_right.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateHighlighted];
    
    [self bindDataToUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WORKOUT_SELECTED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify_workoutSelected:) name:NOTIFICATION_WORKOUT_SELECTED object:nil];
}

#pragma mark - NOTIFICATION_WORKOUT_SELECTED 通知
-(void)notify_workoutSelected:(NSNotification *)_obj
{
    NSMutableDictionary *_dic_singleWorkout = _obj.object;
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popToViewControllerInNavigation:&nav_current controller:self animated:NO];
    NSMutableArray *_arr_singleWeek = [setPlanModel.arr_editedWorkout objectAtIndex:currentEditedIndexPath.section];
    NSMutableDictionary *_dic_singleDay = [_arr_singleWeek objectAtIndex:currentEditedIndexPath.row];
    [_dic_singleDay setObject:[NSString stringWithFormat:@"%@",[_dic_singleWorkout objectForKey:@"TrainingId"]] forKey:@"TrainingId"];
    [_dic_singleDay setObject:[_dic_singleWorkout objectForKey:@"Thumbnail"] forKey:@"Thumbnail"];
    [_dic_singleDay setObject:[_dic_singleWorkout objectForKey:@"ScreenName"] forKey:@"ScreenName"];
    if([[_dic_singleWorkout allKeys] containsObject:@"ScreenNameEN"])
        [_dic_singleDay setObject:[_dic_singleWorkout objectForKey:@"ScreenNameEN"] forKey:@"ScreenNameEN"];
    [_dic_singleDay setObject:[NSNumber numberWithInt:NO] forKey:@"IsComplete"];
    if([[_dic_singleWorkout allKeys] containsObject:@"Minutes"])
        [_dic_singleDay setObject:[_dic_singleWorkout objectForKey:@"Minutes"] forKey:@"Minutes"];
    if([[_dic_singleWorkout allKeys] containsObject:@"Consume"])
        [_dic_singleDay setObject:[_dic_singleWorkout objectForKey:@"Consume"] forKey:@"Consume"];
    [tb reloadRowsAtIndexPaths:@[currentEditedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    
}

-(void)buttonAction_right:(id)_sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WORKOUT_SELECTED object:nil];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGTrainingMyPlanViewController" inNavigation:nav_current];
}

-(void)dealloc
{
    NSLog(@":::::>deall %s %d",__FUNCTION__,__LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_WORKOUT_SELECTED object:nil];
    arr_sectionViews = nil;
    view_sectionTitle = nil;
}

-(void)bindDataToUI
{
    NSMutableDictionary *_dic_datas = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetOriginalWorkoutPlan)];
    
    
    NSMutableArray *_arr_WeekDatas = [_dic_datas objectForKey:@"Workouts"];
    NSInteger weeks = [_arr_WeekDatas count] / 7;
    setPlanModel = [FGTrainingSetPlanModel sharedModel];
    
    setPlanModel.weeks = (int)weeks;
    setPlanModel.arr_singleOriginalWorkout = nil;
    setPlanModel.arr_singleOriginalWorkout = [NSMutableArray arrayWithCapacity:1];
    setPlanModel.arr_editedWorkout = nil;
    setPlanModel.arr_editedWorkout = [NSMutableArray arrayWithCapacity:1];
    for(int w=0;w<weeks;w++)
    {
        NSMutableArray *_arr_perWeeksData = [NSMutableArray arrayWithCapacity:1];
        for(int d=0;d<7;d++)
        {
            NSMutableDictionary *_dic_singleDay = [_arr_WeekDatas objectAtIndex:w * 7 + d];
            [_arr_perWeeksData addObject:_dic_singleDay];
        }
        [setPlanModel.arr_singleOriginalWorkout addObject:_arr_perWeeksData];
        [setPlanModel.arr_editedWorkout addObject:_arr_perWeeksData];
    }
    
    for(int i=0;i<[setPlanModel.arr_editedWorkout count];i++)
    {
        FGTrainingSetPlanWeekSectionView *view_weekSection = (FGTrainingSetPlanWeekSectionView *)[self internalInitalSectionView];
        [arr_sectionViews addObject:view_weekSection];
    }
    tb.delegate = self;
    tb.dataSource = self;
    [tb reloadData];
}

-(UIView *)internalInitalSectionView
{
   
    view_sectionTitle = (FGTrainingSetPlanWeekSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingSetPlanWeekSectionView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_sectionTitle];
    return view_sectionTitle;
}

-(void)go2RecoveryDayEditPage
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingRecoveryDayEditViewController *vc = [[FGTrainingRecoveryDayEditViewController alloc] initWithNibName:@"FGTrainingRecoveryDayEditViewController" bundle:nil];
    [manager pushController:vc navigationController:nav_current];
}

#pragma mark - FGTrainingSetPlanScheduleCellViewDelegate
-(void)didClickRightButtonActionAtCell:(FGTrainingSetPlanScheduleCellView *)_cell
{
    IconType iconType = _cell.iconType;
    NSIndexPath *selectedIndexPath = _cell.indexPathInTable;
    if(iconType == IconType_Black_Plus)
    {
        currentEditedIndexPath = _cell.indexPathInTable;
        [self go2RecoveryDayEditPage];
    }
    else if(iconType == IconType_Black_Minus)
    {
        NSMutableArray *_arr_singleWeek = [setPlanModel.arr_editedWorkout objectAtIndex:selectedIndexPath.section];
        NSMutableDictionary *_dic_singleDay = [_arr_singleWeek objectAtIndex:selectedIndexPath.row];
        [_dic_singleDay setObject:@"rest" forKey:@"TrainingId"];
        [tb reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
@end







@implementation FGTrainingEditScheduleViewController(Table)


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 70 * ratioH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    
    return 46 * ratioH;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    FGTrainingSetPlanWeekSectionView *_sectionView = (FGTrainingSetPlanWeekSectionView *)[arr_sectionViews objectAtIndex:section];
    NSString *_str_weekCount = [commond numberCountFormatByCount:section+1];
    long firstDay = [[[[setPlanModel.arr_editedWorkout objectAtIndex:section] firstObject] objectForKey:@"Date"] longValue];
    long lastDay = [[[[setPlanModel.arr_editedWorkout objectAtIndex:section] lastObject] objectForKey:@"Date"] longValue];
    NSDate *date_firstDay = [NSDate dateWithTimeIntervalSince1970:firstDay];
    NSDate *date_lastDay = [NSDate dateWithTimeIntervalSince1970:lastDay];
    NSDateFormatter *datef = [[NSDateFormatter alloc] init];
    [datef setDateFormat:@"MM.dd"];
    NSString *_str_fromDay = [datef stringFromDate:date_firstDay];
    NSString *_str_endDay = [datef stringFromDate:date_lastDay];
    _sectionView.lb_title.text = [NSString stringWithFormat:@"%@ %@(%@-%@)",_str_weekCount,multiLanguage(@"week"),_str_fromDay,_str_endDay];
    
    return _sectionView;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [setPlanModel.arr_editedWorkout count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[setPlanModel.arr_editedWorkout objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
        cell = [self giveMePlanScheduleCellView:tableView];
    ((FGTrainingSetPlanScheduleCellView *)cell).delegate = self;
    ((FGTrainingSetPlanScheduleCellView *)cell).indexPathInTable = indexPath;
    [((FGTrainingSetPlanScheduleCellView *)cell) updateCellViewWithInfo_EditPlan:[[setPlanModel.arr_editedWorkout objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
- (UITableViewCell *)giveMePlanScheduleCellView:(UITableView *)_tb {
    NSString *CellIdentifier                        = @"FGTrainingSetPlanScheduleCellView";
    FGTrainingSetPlanScheduleCellView *cell = (FGTrainingSetPlanScheduleCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingSetPlanScheduleCellView *)[nib objectAtIndex:0];
    }
    return cell;
}

@end
