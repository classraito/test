//
//  FGProfileFavoriteViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileFavoriteViewController.h"

@interface FGProfileFavoriteViewController ()
{
    NSString *str_title;
}
@end

@implementation FGProfileFavoriteViewController
@synthesize view_faroviteList;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)_str_title
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_title = [_str_title mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = str_title;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [view_faroviteList beginRefresh];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    if(view_faroviteList)
    {
        view_faroviteList.tb.mj_header = nil;
    }
    view_faroviteList = nil;
    str_title = nil;
}

#pragma mark - 初始化FGTrainingWorkoutListView
-(void)internalInitalWorkoutListView
{
    if(view_faroviteList)
        return;
    
    view_faroviteList = (FGProfileFavoriteListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGProfileFavoriteListView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_faroviteList];
    CGRect _frame = view_faroviteList.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_faroviteList.frame = _frame;
    [self.view addSubview:view_faroviteList];
    
    
    
}
#pragma mark - 从父类继承的
-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    [commond removeLoading];
    // 验证码请求
    if ([HOST(URL_TRAINING_GetFavoriteVideoList) isEqualToString:_str_url]) {
        if(self.view_faroviteList)
            [self.view_faroviteList bindDataToUI];
    }
}

@end
