//
//  FGCitiesPickupViewController.m
//  CSP
//
//  Created by JasonLu on 17/1/3.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGCitiesPickupViewController.h"
#import "FGUserPickupTableViewCell.h"
#import "FGCityTableViewCell.h"
@interface FGCitiesPickupViewController ()

@end

@implementation FGCitiesPickupViewController
@synthesize tb;
@synthesize arr_data;

- (void)viewDidLoad {
  [super viewDidLoad];
  SAFE_RemoveSupreView(self.view_topPanel);
  [self hideBottomPanelWithAnimtaion:NO];
  
  [commond useDefaultRatioToScaleView:tb];
  
  [self bindDataToUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
  self.arr_data = nil;
  self.tb.mj_header=nil;
}

-(void)bindDataToUI
{
  [arr_data removeAllObjects];
  
  NSString *_str_path = [[NSBundle mainBundle] pathForResource:@"countrylist" ofType:@"json"];
//  NSData *_data = [NSData dataWithContentsOfFile:_str_path];
  NSError *error = nil;
  NSString* _str_tmp = [NSString stringWithContentsOfFile:_str_path encoding:NSUTF8StringEncoding error:&error];
  NSArray *_arr_tmp = [_str_tmp objectFromJSONString];
  
  self.arr_data = [NSMutableArray arrayWithArray:_arr_tmp];
  tb.delegate = self;
  tb.dataSource = self;
  [tb reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  return 50 * ratioH;
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
  
  cell = [self giveMePickupCellView:tableView];
  [cell updateCellViewWithInfo:[arr_data objectAtIndex:indexPath.row]];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *_str_cityAll = [arr_data objectAtIndex:indexPath.row];
  NSString *_str_cityCode = [_str_cityAll componentsSeparatedByString:@"-"][1];
  _str_cityCode = [_str_cityCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTCITY object:
   @{
     @"cityId":_str_cityCode,
     @"cityAll":_str_cityAll
     }];
  [self.popupController dismissWithCompletion:^{
    
  }];
  
}

#pragma mark - 初始化TableViewCell
-(UITableViewCell *)giveMePickupCellView:(UITableView *)_tb
{
  NSString *CellIdentifier = @"FGCityTableViewCell";
  FGCityTableViewCell *cell = (FGCityTableViewCell *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
    cell = (FGCityTableViewCell *)[nib objectAtIndex:0];
    
  }
  return cell;
}

@end
