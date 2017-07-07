//
//  FGTrainingAllStepByStepViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingAllStepByStepViewController.h"
#import "Global.h"
#import "FGTrainingStepByStepView.h"
@interface FGTrainingAllStepByStepViewController ()
{
    FGVideoModel *model;
    BOOL isFirstPage;
}
@end

@implementation FGTrainingAllStepByStepViewController
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view from its nib.
        self.view_topPanel.str_title = multiLanguage(@"ALL VIDEOS");
    
    isFirstPage = YES;
    
    
    __weak __typeof(self) weakSelf = self;
    self.view_stepByStep.tb.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        isFirstPage = YES;
        [weakSelf postRequest_getAllSteps];
    }];
    
    [self.view_stepByStep.tb addInfiniteScrollingWithActionHandler:^{
        isFirstPage = NO;
        [weakSelf postRequest_getAllSteps];
    }];
    
    [self.view_stepByStep.tb.mj_header beginRefreshing];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)dealloc
{
    
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    self.view_stepByStep = nil;
    [model cancelDownloading];
    [FGVideoModel clearVideoModel ];
}



-(void)createVideoModel
{
    
    
    model = [FGVideoModel sharedModel];
    NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetAllStep)];
    
    int commentCursor                    = [[_dic_info objectForKey:@"Cursor"] intValue];
    if (commentCursor == -1)
        [self.view_stepByStep.tb allowedShowActivityAtFooter:NO];
    else
        [self.view_stepByStep.tb allowedShowActivityAtFooter:YES];
    
    
    NSMutableArray *_arr_tmp_url  = [_dic_info objectForKey:@"StepVideos"];
    for (NSMutableDictionary *_dic_singleInfo in _arr_tmp_url) {
        NSString *str_url = [_dic_singleInfo objectForKey:@"VideoUrl"];
        if(![str_url isEmptyStr])
        {
            [model.arr_urls addObject:str_url];
            [model.arr_urlInfos addObject:_dic_singleInfo];
        }
    }
    [model filteRepeatedUrlAndRecordTheCount];
    
}

-(void)postRequest_getAllSteps
{
    [[NetworkManager_Training sharedManager] postReqeust_GetAllStep:isFirstPage count:100 userinfo:nil];
}

#pragma mark - 从父类继承的
-(void)buttonAction_left:(id)_sender
{
    [super buttonAction_left:_sender];
    [self.view_stepByStep.tb setRefreshFooter:nil];
    self.view_stepByStep.tb.mj_header=nil;
   
}


-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    // 验证码请求
    if ([HOST(URL_TRAINING_GetAllStep) isEqualToString:_str_url]) {
        if(self.view_stepByStep)
        {
            if(isFirstPage)
            {
                [model.arr_urls removeAllObjects];
                [model.arr_urlInfos removeAllObjects];
                [self.view_stepByStep.tb.mj_header endRefreshing];
            }
            else
            {
                [self.view_stepByStep.tb.refreshFooter endRefreshing];
            }
            
            [self createVideoModel];
            [self.view_stepByStep bindDataToUI];
        }
        
    }

}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
    
    
}

#pragma mark- 覆盖父类的
-(void)internalInitalStepByStepView
{
    if(self.view_stepByStep)
        return;
    
    self.view_stepByStep = (FGTrainingStepByStepView *)[[[NSBundle  mainBundle] loadNibNamed:@"FGTrainingStepByStepView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:self.view_stepByStep];
    CGRect _frame = self.view_stepByStep.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    self.view_stepByStep.frame = _frame;
    [self.view addSubview:self.view_stepByStep];
}


@end
