//
//  FGLocationViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/9/13.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationViewController.h"
#import "Global.h"
#import "FGLocationHomePageCellView.h"
@interface FGLocationViewController ()
{
    
}
@end

@implementation FGLocationViewController
@synthesize tb;
@synthesize arr_data;
#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.view_topPanel.str_title = multiLanguage(@"Location_Booking");
    SAFE_RemoveSupreView(self.view_topPanel.iv_left);
    SAFE_RemoveSupreView(self.view_topPanel.btn_left);
    SAFE_RemoveSupreView(self.view_topPanel.iv_right);
    SAFE_RemoveSupreView(self.view_topPanel.btn_right);
    
    NSString *_str_findTrainer = multiLanguage( @"FIND A TRAINER");
    if(![commond isUser])
        _str_findTrainer = multiLanguage(@"MANAGE BOOKING");
    
    
    
    arr_data = (NSMutableArray *)
    @[
      @{@"thumbnail" : @"LocationBookATrainerSession.jpg",@"title" :_str_findTrainer},
      //@{@"thumbnail" : @"slider2.jpg",@"title" : multiLanguage(@"FIND A GYM")},
      @{@"thumbnail" : @"LocationBookAGroupSession_.jpg",@"title" :multiLanguage( @"FIND A GROUP\nSESSION")},
      ];
    
    [commond useDefaultRatioToScaleView:tb];
    tb.delegate = self;
    tb.dataSource = self;
    [tb reloadData];
   
    tb.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [self.view_bottomPanel setButtonHighlightedByStatus:NavigationStatus_Location];
}

-(void)manullyFixSize
{
    [super manullyFixSize];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_data = nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 228 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    NSString *_str_vcName = nil;
    
    if(![appDelegate isLoggedIn])
    {
        [commond showAskForLogin];
        return;
    }

    
    switch (indexPath.row) {
        case 0:
            _str_vcName = @"FGLocationFindATrainerViewController";
            
            if(![commond isUser])
            {
                [self buttonAction_profile:nil];//切换到profile
                FGProfileViewController *vc_profileHome = (FGProfileViewController *)nav_current.topViewController;
                [vc_profileHome buttonActoin_gotoMyBooking:nil];//到my booking
                return;
            }

            break;
      /*  case 1:
            _str_vcName = @"FGLocationFindAGYMViewController";
            break;*/
        case 1:
            
            _str_vcName = @"FGLocationFindAGroupViewController";
            
            break;
        default:
            break;
    }
    
    
    [[FGLocationManagerWrapper sharedManager] startUpdatingLocation:^(CLLocationDegrees _lat, CLLocationDegrees _lng) {
        if(_lat != DEFAULT_LATITUDE && _lng != DEFAULT_LONTITUDE)
        {
            [manager pushControllerByName:_str_vcName inNavigation:nav_current];
            return ;
        }
    }];
   
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return [arr_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    cell = [self giveMeLocationHomePageCell:tableView];
    [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - 初始化TableViewCell
-(UITableViewCell *)giveMeLocationHomePageCell:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGLocationHomePageCellView";
    FGLocationHomePageCellView *cell = (FGLocationHomePageCellView *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGLocationHomePageCellView *)[nib objectAtIndex:0];
    }
    return cell;
    
}

#pragma mark - 从父类继承的

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
}

-(void)requestFailedFromNetwork:(NSNotification *)_notification
{
    [super requestFailedFromNetwork:_notification];
}
@end
