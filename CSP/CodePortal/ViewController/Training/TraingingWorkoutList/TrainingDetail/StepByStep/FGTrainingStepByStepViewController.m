//
//  FGTrainingStepByStepViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingStepByStepViewController.h"
#import "Global.h"
@interface FGTrainingStepByStepViewController ()
{
    
}
@end

@implementation FGTrainingStepByStepViewController
@synthesize view_stepByStep;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"Workout breakdown");
    self.view_topPanel.iv_right.hidden = YES;
    self.view_topPanel.btn_right.hidden = YES;
    [self hideBottomPanelWithAnimtaion:NO];
    [self internalInitalStepByStepView];
    
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_stepByStep = nil;
}

#pragma mark - 初始化
-(void)internalInitalStepByStepView
{
    if(view_stepByStep)
        return;
    
    view_stepByStep = (FGTrainingStepByStepView *)[[[NSBundle  mainBundle] loadNibNamed:@"FGTrainingStepByStepView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_stepByStep];
    CGRect _frame = view_stepByStep.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_stepByStep.frame = _frame;
    [self.view addSubview:view_stepByStep];
    [view_stepByStep bindDataToUI];
    
}

#pragma mark - 从父类继承的

-(void)buttonAction_right:(id)_sender
{
    
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}
@end
