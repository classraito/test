//
//  FGTrainingWorkOutListViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingWorkOutListViewController.h"
#import "Global.h"

@interface FGTrainingWorkOutListViewController ()
{
    
}
@end

@implementation FGTrainingWorkOutListViewController
@synthesize view_workoutList;
@synthesize str_title;
@synthesize currentWorkoutType;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)_str_title workoutType:(WorkoutType)_workoutType
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        currentWorkoutType = _workoutType;
        str_title = [_str_title mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = str_title;
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_right.hidden = YES;
    
    [self internalInitalWorkoutListView];
    [self hideBottomPanelWithAnimtaion:NO];
    [view_workoutList beginRefresh];
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
    if(view_workoutList)
    {
        view_workoutList.tb.mj_header = nil;
    }
    view_workoutList = nil;
    str_title = nil;
}

#pragma mark - 初始化FGTrainingWorkoutListView
-(void)internalInitalWorkoutListView
{
    if(view_workoutList)
        return;
    
    view_workoutList = (FGTrainingWorkoutListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingWorkoutListView" owner:nil options:nil] objectAtIndex:0];
    view_workoutList.workoutType = currentWorkoutType;
    [commond useDefaultRatioToScaleView:view_workoutList];
    CGRect _frame = view_workoutList.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_workoutList.frame = _frame;
    [self.view addSubview:view_workoutList];
    
    
    
}
#pragma mark - 从父类继承的

-(void)buttonAction_right:(id)_sender
{
    
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    [commond removeLoading];
    // 验证码请求
    if ([HOST(URL_TRAINING_GetWorkoutVideoList) isEqualToString:_str_url]) {
        if(view_workoutList)
            [view_workoutList bindDataToUI];
    }
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}
@end
