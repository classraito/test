//
//  FGProfileSavedWorkoutViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileSavedWorkoutViewController.h"
#import "Global.h"
@interface FGProfileSavedWorkoutViewController ()
{
    
}
@end

@implementation FGProfileSavedWorkoutViewController
@synthesize view_savedWorkoutList;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)_str_title
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        self.str_title = [_str_title mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    if(view_savedWorkoutList)
    {
        view_savedWorkoutList.tb.mj_header = nil;
    }
    view_savedWorkoutList = nil;
}

#pragma mark - 初始化FGTrainingWorkoutListView
-(void)internalInitalWorkoutListView
{
    if(view_savedWorkoutList)
        return;
    
    view_savedWorkoutList = (FGProfileSavedWorkoutListView *)[[[NSBundle mainBundle] loadNibNamed:@"FGProfileSavedWorkoutListView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_savedWorkoutList];
    CGRect _frame = view_savedWorkoutList.frame;
    _frame.origin.y = self.view_topPanel.frame.size.height;
    view_savedWorkoutList.frame = _frame;
    [self.view addSubview:view_savedWorkoutList];
    [view_savedWorkoutList bindDataToUI];
}
@end
