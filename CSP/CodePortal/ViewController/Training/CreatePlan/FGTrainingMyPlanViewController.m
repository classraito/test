//
//  FGTrainingMyPlanViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingMyPlanViewController.h"
#import "Global.h"
#import "FGTrainingSetPlanScheduleCellView.h"
#import "FGTrainingSetPlanModel.h"
@interface FGTrainingMyPlanViewController ()
{
    NSMutableArray *arr_sectionViews;
    FGTrainingSetPlanModel *setPlanModel;
    NSIndexPath *currentEditedIndexPath;
    NSIndexPath *currentSelectedIndexPath;
}
@end

@implementation FGTrainingMyPlanViewController
@synthesize tb;
@synthesize view_sectionTitle;
@synthesize view_morePopup;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify_workoutSelected:) name:NOTIFICATION_WORKOUT_SELECTED object:nil];
    
    self.view_topPanel.str_title = multiLanguage(@"MY PLAN");
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"More") forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitle:multiLanguage(@"More") forState:UIControlStateHighlighted];
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_right.hidden = NO;
    
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateNormal];
    [self.view_topPanel.btn_right setTitleColor:color_red_panel forState:UIControlStateHighlighted];
    self.view_topPanel.btn_right.titleLabel.font = font(FONT_TEXT_BOLD, 16);
    
    [self hideBottomPanelWithAnimtaion:NO];
    [commond useDefaultRatioToScaleView:tb];
    
    arr_sectionViews = [[NSMutableArray alloc] initWithCapacity:1];
    
    tb.delegate = self;
    tb.dataSource = self;
    [self bindDataToUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
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
    setPlanModel = [FGTrainingSetPlanModel sharedModel];
    for(int i=0;i<[setPlanModel.arr_editedWorkout count];i++)
    {
        FGTrainingSetPlanWeekSectionView *view_weekSection = (FGTrainingSetPlanWeekSectionView *)[self internalInitalSectionView];
        [arr_sectionViews addObject:view_weekSection];
    }
    
    [tb reloadData];
    FGTrainingSetPlanMyPlanTopBannerView *cell_topBanner = (FGTrainingSetPlanMyPlanTopBannerView *)[tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell_topBanner initalCellWithInfo:setPlanModel.arr_editedWorkout];
    FGTrainingSetPlanMyPlanTopBannerView *cell = [tb cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell updateCellViewWithInfo:[[setPlanModel.arr_editedWorkout objectAtIndex:0] objectAtIndex:0]];
}

#pragma mark - FGTrainingSetPlanScheduleCellViewDelegate
-(void)didClickRightButtonActionAtCell:(FGTrainingSetPlanScheduleCellView *)_cell
{
    IconType iconType = _cell.iconType;
    NSIndexPath *selectedIndexPath = _cell.indexPathInTable;
    if(iconType == IconType_Blue_Plus)
    {
        currentEditedIndexPath =  [NSIndexPath indexPathForRow:selectedIndexPath.row inSection:selectedIndexPath.section] ;
        [self go2RecoveryDayEditPage];
    }
}

-(void)go2RecoveryDayEditPage
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingRecoveryDayEditViewController *vc = [[FGTrainingRecoveryDayEditViewController alloc] initWithNibName:@"FGTrainingRecoveryDayEditViewController" bundle:nil];
    [manager pushController:vc navigationController:nav_current];
}

#pragma mark - NOTIFICATION_WORKOUT_SELECTED 通知
-(void)notify_workoutSelected:(NSNotification *)_obj
{
    NSMutableDictionary *_dic_singleWorkout = _obj.object;
    [nav_current popToViewController:self animated:NO];
    NSMutableArray *_arr_singleWeek = [setPlanModel.arr_editedWorkout objectAtIndex:currentEditedIndexPath.section-1];
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

-(UIView *)internalInitalSectionView
{
    view_sectionTitle = (FGTrainingSetPlanWeekSectionView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingSetPlanWeekSectionView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_sectionTitle];
    return view_sectionTitle;
}

-(void)internalInitalMorePopup
{
    if(view_morePopup)
        return;
    view_morePopup = (FGTrainingMyPlanMorePopupView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingMyPlanMorePopupView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_morePopup];
    [self.view addSubview:view_morePopup];
    [view_morePopup.cb_download.button addTarget:self action:@selector(buttonAction_downloadAllVideos:) forControlEvents:UIControlEventTouchUpInside];
    [view_morePopup.cb_cancel.button addTarget:self action:@selector(buttonAction_cancelPlan:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMyPlanMorePopupView)];
    _tap.cancelsTouchesInView = NO;
    [view_morePopup.view_bg addGestureRecognizer:_tap];
    _tap = nil;
}

-(void)buttonAction_left:(id)_sender
{
    [self postRequest_setWorkoutPlan];
}

-(void)buttonAction_right:(id)_sender
{
    [super buttonAction_right:_sender];
    [self internalInitalMorePopup];
}

-(void)removeMyPlanMorePopupView
{
    SAFE_RemoveSupreView(view_morePopup);
    view_morePopup = nil;
}

-(void)buttonAction_cancelPlan:(id)_sender
{
    [self removeMyPlanMorePopupView];
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_Training sharedManager] postRequest_SetWorkoutPlan:0 workouts:(NSMutableArray *)@[] userinfo:_dic_info];
}

-(void)buttonAction_downloadAllVideos:(id)_sender
{
    [self removeMyPlanMorePopupView];
}

-(void)postRequest_setWorkoutPlan
{
    setPlanModel = [FGTrainingSetPlanModel sharedModel];
    NSMutableArray *_arr_workouts = [NSMutableArray arrayWithCapacity:1];
    for(int w=0;w<setPlanModel.weeks;w++)
    {
        for(int d=0;d<7;d++)
        {
            NSMutableDictionary *_dic_singleDay = [[setPlanModel.arr_editedWorkout objectAtIndex:w] objectAtIndex:d];
            NSString *_str_trainingId = [_dic_singleDay objectForKey:@"TrainingId"];
            if(![@"sport" isEqualToString:_str_trainingId])
            {
                [_dic_singleDay setObject:@"" forKey:@"ScreenNameEN"];
                
            }
            else
            {
                [_dic_singleDay setObject:@"" forKey:@"Minutes"];
            }
            
            if([@"rest" isEqualToString:_str_trainingId])
            {
                [_dic_singleDay setObject:@"" forKey:@"Thumbnail"];
                [_dic_singleDay setObject:@"" forKey:@"Minutes"];
            }
            [_arr_workouts addObject:_dic_singleDay];
        }
    }
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:@"" notifyOnVC:self];
    [[NetworkManager_Training sharedManager] postRequest_SetWorkoutPlan:setPlanModel.timeStamp workouts:_arr_workouts userinfo:_dic_info];
}

#pragma mark - 利用scrollView 实现顶部的一个缩放特效
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        NSIndexPath *indexPath   = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *curCell = [tb cellForRowAtIndexPath:indexPath];
        if ([curCell isKindOfClass:[FGTrainingSetPlanMyPlanTopBannerView class]]) {
            FGTrainingSetPlanMyPlanTopBannerView *cell = (FGTrainingSetPlanMyPlanTopBannerView *)curCell;
            CGFloat scalePercent                            = fabs(scrollView.contentOffset.y) / scrollView.frame.size.height;
            cell.iv_thumbnail.transform                = CGAffineTransformMakeScale(1 + scalePercent * 2.4, 1 + scalePercent * 2.4);
            CGRect _frame                                   = cell.iv_thumbnail.frame;
            _frame.origin.y                                 = scrollView.contentOffset.y;
            cell.iv_thumbnail.frame                    = _frame;
        }
    }
}

#pragma mark - 网络相关
/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)receivedDataFromNetwork:(NSNotification *)_notification {
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_TRAINING_SetWorkoutPlan) isEqualToString:_str_url])
    {
        [nav_current popToRootViewControllerAnimated:YES];
    }
    
}

/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)requestFailedFromNetwork:(NSNotification *)_notification {
    [super requestFailedFromNetwork:_notification];
}
@end







@implementation FGTrainingMyPlanViewController(Table)
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.section == 0)
    {
        return 200 * ratioH;
    }
    else
    {
        return 70 * ratioH;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    if(section == 0)
        return 0;
    else
        return 46 * ratioH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return;
    
    currentSelectedIndexPath = indexPath;
    FGTrainingSetPlanMyPlanTopBannerView *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell updateCellViewWithInfo:[[setPlanModel.arr_editedWorkout objectAtIndex:currentSelectedIndexPath.section-1] objectAtIndex:currentSelectedIndexPath.row]];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
    if(section == 0)
        return nil;
    else
    {
        FGTrainingSetPlanWeekSectionView *_sectionView = (FGTrainingSetPlanWeekSectionView *)[arr_sectionViews objectAtIndex:section-1];
        NSString *_str_weekCount = [commond numberCountFormatByCount:section];
        long firstDay = [[[[setPlanModel.arr_editedWorkout objectAtIndex:section-1] firstObject] objectForKey:@"Date"] longValue];
        long lastDay = [[[[setPlanModel.arr_editedWorkout objectAtIndex:section-1] lastObject] objectForKey:@"Date"] longValue];
        NSDate *date_firstDay = [NSDate dateWithTimeIntervalSince1970:firstDay];
        NSDate *date_lastDay = [NSDate dateWithTimeIntervalSince1970:lastDay];
        NSDateFormatter *datef = [[NSDateFormatter alloc] init];
        [datef setDateFormat:@"MM.dd"];
        NSString *_str_fromDay = [datef stringFromDate:date_firstDay];
        NSString *_str_endDay = [datef stringFromDate:date_lastDay];
        _sectionView.lb_title.text = [NSString stringWithFormat:@"%@ %@(%@-%@)",_str_weekCount,multiLanguage(@"week"),_str_fromDay,_str_endDay];
        return _sectionView;
    }
    return nil;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [setPlanModel.arr_editedWorkout count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if(section == 0)
        return 1;
    else
        return [[setPlanModel.arr_editedWorkout objectAtIndex:section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    if(indexPath.section == 0)
    {
        cell = [self giveMePlanTopBannerCellView:tableView];
        if(currentSelectedIndexPath)
        [cell updateCellViewWithInfo:[[setPlanModel.arr_editedWorkout objectAtIndex:currentSelectedIndexPath.section-1] objectAtIndex:currentSelectedIndexPath.row]];
    }
    else
    {
        cell = [self giveMePlanScheduleCellView:tableView];
        ((FGTrainingSetPlanScheduleCellView *)cell).delegate = self;
        ((FGTrainingSetPlanScheduleCellView *)cell).indexPathInTable = indexPath;
        [((FGTrainingSetPlanScheduleCellView *)cell) updateCellViewWithInfo_MyPlan:[[setPlanModel.arr_editedWorkout objectAtIndex:indexPath.section-1] objectAtIndex:indexPath.row]];
    }
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

- (UITableViewCell *)giveMePlanTopBannerCellView:(UITableView *)_tb {
    NSString *CellIdentifier                        = @"FGTrainingSetPlanMyPlanTopBannerView";
    FGTrainingSetPlanMyPlanTopBannerView *cell = (FGTrainingSetPlanMyPlanTopBannerView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier]; //从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell         = (FGTrainingSetPlanMyPlanTopBannerView *)[nib objectAtIndex:0];
    }
    return cell;
}

@end
