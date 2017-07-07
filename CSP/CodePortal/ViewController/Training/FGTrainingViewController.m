//
//  FGTrainingViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingViewController.h"
#import "Global.h"
#import "FGTimerViewController.h"
#import "FGTrainingSetPlanModel.h"
@interface FGTrainingViewController ()
{
    
}
@end

@implementation FGTrainingViewController
@synthesize view_training_homepage;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"TRAINING");
    self.view_topPanel.iv_left.image = [UIImage imageNamed:@"timer.png"];
    self.view_topPanel.iv_right.image = [UIImage imageNamed:@"faverite.png"];
    self.view_topPanel.iv_right_indise1.image = [UIImage imageNamed:@"dictionary.png"];
    self.view_topPanel.iv_right_indise1.hidden = NO;
    self.view_topPanel.btn_right_inside1.hidden = NO;//隐藏所有视频 按钮
    
    [self internalInitalHomePage];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    if(view_training_homepage)
//    {
//        [view_training_homepage.tb triggerRecoveryAnimationIfNeeded];
//    }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
//    [view_training_homepage.tb setPullToRefreshWindowsStyleView:nil];
    if(view_training_homepage)
    {
        view_training_homepage.tb.mj_header = nil;
        view_training_homepage = nil;
    }
}

#pragma mark - 初始化
-(void)internalInitalHomePage
{
    if(view_training_homepage)
        return;
    
    view_training_homepage = (FGTrainingHomePageView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingHomePageView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_training_homepage];
    CGRect _frame = view_training_homepage.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_training_homepage.frame = _frame;
    [self.view addSubview:view_training_homepage];
}

#pragma mark - 从父类继承的
-(void)buttonAction_left:(id)_sender
{
    FGTimerViewController *vc_timer = [[FGTimerViewController alloc] initWithNibName:@"FGTimerViewController" bundle:nil];
    [self presentViewController:vc_timer animated:YES completion:nil];
}

-(void)buttonAction_right:(id)_sender
{
    FGProfileFavoriteViewController *vc_profile_favorite = [[FGProfileFavoriteViewController alloc] initWithNibName:@"FGProfileFavoriteViewController" bundle:nil title:multiLanguage(@"Favorite")];
    [nav_current pushViewController:vc_profile_favorite animated:YES];
}//跳转到favorite页面

-(void)buttonAction_right_inside1:(id)_sender
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingAllStepByStepViewController *vc_allVideos = [[FGTrainingAllStepByStepViewController alloc] initWithNibName:@"FGTrainingAllStepByStepViewController" bundle:nil];
    [manager pushController:vc_allVideos navigationController:nav_current];
    
}

-(void)go2NextPageOfWorkoutPlan
{
    NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetWorkoutPlan)];
    NSMutableArray *_arr_WeekDatas = [_dic_info objectForKey:@"Workouts"];
    NSInteger workoutCount = [_arr_WeekDatas count];
    
    if(workoutCount <= 0)
    {
        [self go2SetWorkoutPlan];
    }
    else
    {
        NSInteger weeks = workoutCount / 7;
        FGTrainingSetPlanModel *setPlanModel = [FGTrainingSetPlanModel sharedModel];
            
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
        
        [self go2MyWorkoutPlan];
    }
    
    
}

-(void)go2SetWorkoutPlan
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGTrainingSetPlanViewController" inNavigation:nav_current];
}

-(void)go2MyWorkoutPlan
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushControllerByName:@"FGTrainingMyPlanViewController" inNavigation:nav_current];
}

#pragma mark - network norification
-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSLog(@"_dic_requestInfo = %@",_dic_requestInfo);
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    
    if ([HOST(URL_TRAINING_GetFeaturedVideoList) isEqualToString:_str_url]||
        [HOST(URL_TRAINING_GetVIPVideoList) isEqualToString:_str_url]) {
        if(view_training_homepage)
        {
            int sectionType = [[_dic_requestInfo objectForKey:KEY_USERINFO_TRAINING_SECTIONTYPE] intValue];
            [view_training_homepage bindDataToUIByStatus:sectionType];
        }
    }
    
    if([HOST(URL_TRAINING_GetWorkoutPlan) isEqualToString:_str_url])
    {
        [self go2NextPageOfWorkoutPlan];
    }

}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    if(view_training_homepage)
    {
        [view_training_homepage.tb triggerStopRefresh];
    }
    
    if([HOST(URL_TRAINING_GetWorkoutPlan) isEqualToString:_str_url])
    {
        [self go2MyWorkoutPlan];
    }
}



@end
