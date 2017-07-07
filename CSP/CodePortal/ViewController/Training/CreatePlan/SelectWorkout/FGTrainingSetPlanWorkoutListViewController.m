//
//  FGTrainingSetPlanWorkoutListViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanWorkoutListViewController.h"
#import "Global.h"
#import "FGTrainingSetPlanWorkoutListView.h"
@interface FGTrainingSetPlanWorkoutListViewController ()
{
    
}
@end

@implementation FGTrainingSetPlanWorkoutListViewController
@synthesize view_setPlanWorkoutList;
#pragma mark - 初始化FGTrainingWorkoutListView
-(void)internalInitalWorkoutListView
{
    if(view_setPlanWorkoutList)
        return;
    
    view_setPlanWorkoutList = (FGTrainingSetPlanWorkoutListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingSetPlanWorkoutListView" owner:nil options:nil] objectAtIndex:0];
    view_setPlanWorkoutList.workoutType = self.currentWorkoutType;
    [commond useDefaultRatioToScaleView:view_setPlanWorkoutList];
    CGRect _frame = view_setPlanWorkoutList.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_setPlanWorkoutList.frame = _frame;
    [self.view addSubview:view_setPlanWorkoutList];
    
    [view_setPlanWorkoutList postReqeust];
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_setPlanWorkoutList = nil;
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    [commond removeLoading];
    // 验证码请求
    if ([HOST(URL_TRAINING_GetWorkoutVideoList) isEqualToString:_str_url]) {
        if(view_setPlanWorkoutList)
            [view_setPlanWorkoutList bindDataToUI];
    }
}
@end
