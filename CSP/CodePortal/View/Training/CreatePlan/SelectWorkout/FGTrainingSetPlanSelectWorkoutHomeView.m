//
//  FGTrainingWorkOutListView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanSelectWorkoutHomeView.h"
#import "Global.h"
#import "FGTrainingWorkoutCellView.h"
#import "FGTrainingBrowserByTypeCellView.h"
#import "FGTrainingWorkoutTypeCellView.h"
#import "FGTrainingWorkOutListViewController.h"
#import "FGTrainingDetailViewController.h"

@interface FGTrainingSetPlanSelectWorkoutHomeView()
{
    
}
@end

@implementation FGTrainingSetPlanSelectWorkoutHomeView
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
}

-(void)internalInital
{
    self.currentSectionType = TraingHomePage_SectionType_WorkOuts;
    self.arr_dataInTable = [[NSMutableArray alloc] init];
    self.tb.delegate = self;
    self.tb.dataSource = self;
    [commond useDefaultRatioToScaleView:self.tb];
    [self internalInitalTrainingSectionView];
    
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)go2TrainingWorkoutListViewController:(NSString *)_str_title workoutType:(WorkoutType)_workoutType
{
    _str_title = [_str_title stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGTrainingSetPlanWorkoutListViewController *vc_setPlanworkoutList = [[FGTrainingSetPlanWorkoutListViewController alloc] initWithNibName:@"FGTrainingSetPlanWorkoutListViewController" bundle:nil title:_str_title workoutType:_workoutType];
    [manager pushController:vc_setPlanworkoutList navigationController:nav_current];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
   
        if(self.currentSectionType == TraingHomePage_SectionType_Featured)
        {
            return 152 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
        }
        else if(self.currentSectionType == TraingHomePage_SectionType_VIP)
        {
            return 152 * ratioH;//FGTrainingWorkoutCellView的高度,这个数字是在xib中定义的原始高度
        }
        else if(self.currentSectionType == TraingHomePage_SectionType_WorkOuts)
        {
            
            if(indexPath.row == [self.arr_dataInTable count] - 1)
            {
                return 174 * ratioH; //FGTrainingBrowserByTypeCellView的高度,这个数字是在xib中定义的原始高度
            }
            else
            {
                return 102 * ratioH; //FGTrainingWorkoutTypeCellView的高度,这个数字是在xib中定义的原始高度
            }
        }

    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
   
    return self.view_trainingSection.frame.size.height;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
{
  
    return self.view_trainingSection;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if(self.currentSectionType == TraingHomePage_SectionType_WorkOuts)
    {
        if(indexPath.row != [self.arr_dataInTable count] - 1)
        {
            WorkoutType _currentWorkoutType = (int)indexPath.row;
            [self go2TrainingWorkoutListViewController:[self.arr_dataInTable objectAtIndex:indexPath.row] workoutType:_currentWorkoutType];
        }
    }
    else
    {
        NSMutableDictionary *_dic_singleData = [self.arr_dataInTable objectAtIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WORKOUT_SELECTED object:_dic_singleData];
            //TODO: do select workout
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [self.arr_dataInTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = nil;
  
        if (self.currentSectionType == TraingHomePage_SectionType_Featured||
            self.currentSectionType == TraingHomePage_SectionType_VIP)
        {
            
            cell = [self giveMeTrainingWorkoutCell:tableView];
            [cell updateCellViewWithInfo:[self.arr_dataInTable objectAtIndex:indexPath.row]];
            
        } else if (self.currentSectionType == TraingHomePage_SectionType_WorkOuts) {
            
            if(indexPath.row == [self.arr_dataInTable count] - 1)
            {
                cell = [self giveMeBrowserByTypeCell:tableView];
            }
            else
            {
                cell = [self giveMeWorkoutTypeCell:tableView];
                [cell updateCellViewWithInfo:[self.arr_dataInTable objectAtIndex:indexPath.row]];
            }
        }
    
    return cell;
}
@end
