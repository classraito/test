//
//  FGTrainingSetPlanViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanViewController.h"
#import "Global.h"
@interface FGTrainingSetPlanViewController ()
{
    NSMutableArray *arr_data;
}
@end

@implementation FGTrainingSetPlanViewController
@synthesize view_setPlan;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self internalInital_setPlanView];
    self.view_topPanel.str_title = multiLanguage(@"SET WORKOUT PLAN");
    [self hideBottomPanelWithAnimtaion:NO];
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
    NSLog(@":::::>deall %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
    view_setPlan = nil;
    
}

-(void)buttonAction_left:(id)_sender
{
    [super buttonAction_left:_sender];
    [view_setPlan removeAllInputView];
}

-(void)internalInital_setPlanView
{
    if(view_setPlan)
        return;
    
    view_setPlan = (FGTrainingSetplanView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingSetplanView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_setPlan];
    [view_setPlan setupByOriginalContentSize:view_setPlan.bounds.size];
    [self.view addSubview:view_setPlan];
}

#pragma mark - 网络相关
/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)receivedDataFromNetwork:(NSNotification *)_notification {
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    if ([HOST(URL_TRAINING_GetOriginalWorkoutPlan) isEqualToString:_str_url])
    {
        FGControllerManager *manager = [FGControllerManager sharedManager];
        FGTrainingEditScheduleViewController *vc_editSchedule = [[FGTrainingEditScheduleViewController alloc] initWithNibName:@"FGTrainingEditScheduleViewController" bundle:nil];
        [manager pushController:vc_editSchedule navigationController:nav_current];
    }

}

/* 子类实现此方法来自定义收到网络数据后的行为*/
- (void)requestFailedFromNetwork:(NSNotification *)_notification {
    [super requestFailedFromNetwork:_notification];
}
@end


