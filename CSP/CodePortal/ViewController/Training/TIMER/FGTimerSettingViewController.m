//
//  FGTimerSettingViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/3.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTimerSettingViewController.h"
#import "Global.h"
#import "FGRoundTimerLogicModel.h"
@interface FGTimerSettingViewController ()
{
    FGRoundTimerLogicModel *model_roundTimer;
}
@end

@implementation FGTimerSettingViewController
@synthesize view_setting;
#pragma mark - 生命周期
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil model:(FGRoundTimerLogicModel *)_model
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        model_roundTimer = _model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"TIMER SETTING");
    self.view_topPanel.backgroundColor = rgb(38, 38, 38);
    SAFE_RemoveSupreView(self.view_topPanel.btn_right);
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
    [self hideBottomPanelWithAnimtaion:NO];
    
    [self internalInitalSettingView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view_topPanel.backgroundColor = rgb(38, 38, 38);
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [view_setting removeAllInputView];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 初始化settingview
-(void)internalInitalSettingView
{
    if(view_setting)
        return;
    
    
    view_setting = (FGSettingView *)[[[NSBundle mainBundle] loadNibNamed:@"FGSettingView" owner:nil options:nil] objectAtIndex:0];
    [self.view addSubview:view_setting];
    [commond useDefaultRatioToScaleView:view_setting];
    [view_setting setupByOriginalContentSize:view_setting.bounds.size];
    [view_setting loadModel:model_roundTimer];
}

-(void)buttonAction_left:(id)_sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
