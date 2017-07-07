//
//  FGTrainingStepByStepView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingStepByStepView.h"
#import "Global.h"
#import "FGTrainingStepByStepCellViewTableViewCell.h"
#import "FGTrainingVideoPreviewViewController.h"
#import "FGVideoModel.h"
@interface FGTrainingStepByStepView()
{
    NSMutableArray *arr_dataInTable;
}
@end

@implementation FGTrainingStepByStepView
@synthesize tb;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:tb];
    
    tb.delegate = self;
    tb.dataSource = self;
    arr_dataInTable = [[NSMutableArray alloc] init];
}

-(void)dealloc
{
    NSLog(@"::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_dataInTable = nil;
}

-(void)go2VideoPreviewViewController
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingVideoPreviewViewController *vc_stepByStepPreviewVideo = [[FGTrainingVideoPreviewViewController alloc] initWithNibName:@"FGTrainingVideoPreviewViewController" bundle:nil];
    [manager pushController:vc_stepByStepPreviewVideo navigationController:nav_current];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 76 * ratioH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FGVideoModel *model_video = [FGVideoModel sharedModel];
    model_video.currentPlayerItemIndex = (int)indexPath.row;
    
    [self go2VideoPreviewViewController];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [arr_dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
    
    cell = [self giveMeStepByStepCellView:tableView];
    [cell updateCellViewWithInfo:[arr_dataInTable objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - 初始化TableViewCell
#pragma mark - 初始化Likes的FGTrainingDetailTopVideoThumbnailCellView
-(UITableViewCell *)giveMeStepByStepCellView:(UITableView *)_tb
{
    NSString *CellIdentifier = @"FGTrainingStepByStepCellViewTableViewCell";
    FGTrainingStepByStepCellViewTableViewCell *cell = (FGTrainingStepByStepCellViewTableViewCell *)[_tb dequeueReusableCellWithIdentifier:CellIdentifier];//从xib初始化tablecell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = (FGTrainingStepByStepCellViewTableViewCell *)[nib objectAtIndex:0];
        
    }
    return cell;
}

-(void)bindDataToUI
{
    [arr_dataInTable removeAllObjects];
    FGVideoModel *model = [FGVideoModel sharedModel];
    [arr_dataInTable addObjectsFromArray:model.arr_urlInfos];
    [tb reloadData];
}

@end
