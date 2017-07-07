//
//  FGTrainingSetPlanSelectWorkoutHomeViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanSelectWorkoutHomeViewController.h"

@interface FGTrainingSetPlanSelectWorkoutHomeViewController ()

@end

@implementation FGTrainingSetPlanSelectWorkoutHomeViewController
@synthesize view_selectWorkoutHome;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"TRAINING");
    
    [self internalInitalHomePage];
    [self hideBottomPanelWithAnimtaion:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
     [self setWhiteBGStyle];
   
}

#pragma mark - 初始化
-(void)internalInitalHomePage
{
    if(view_selectWorkoutHome)
        return;
    
    view_selectWorkoutHome = (FGTrainingSetPlanSelectWorkoutHomeView *)[[[NSBundle mainBundle] loadNibNamed:@"FGTrainingSetPlanSelectWorkoutHomeView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_selectWorkoutHome];
    CGRect _frame = view_selectWorkoutHome.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_selectWorkoutHome.frame = _frame;
    [self.view addSubview:view_selectWorkoutHome];
}

-(void)buttonAction_left:(id)_sender
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager popViewControllerInNavigation:&nav_current animated:YES];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_selectWorkoutHome = nil;
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSLog(@"_dic_requestInfo = %@",_dic_requestInfo);
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    // 验证码请求
    if ([HOST(URL_TRAINING_GetFeaturedVideoList) isEqualToString:_str_url]||
        [HOST(URL_TRAINING_GetVIPVideoList) isEqualToString:_str_url]) {
        if(view_selectWorkoutHome)
        {
            int sectionType = [[_dic_requestInfo objectForKey:KEY_USERINFO_TRAINING_SECTIONTYPE] intValue];
            [view_selectWorkoutHome bindDataToUIByStatus:sectionType];
        }
        
    }
    
}
@end
