//
//  FGTrainingWorkoutListView.m
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanWorkoutListView.h"
#import "Global.h"
#import "FGTrainingWorkoutCellView.h"
#import "FGTrainingDetailViewController.h"
@interface FGTrainingSetPlanWorkoutListView()
{
    
}
@end

@implementation FGTrainingSetPlanWorkoutListView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSMutableDictionary *_dic_singleData = [self.arr_dataInTable objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WORKOUT_SELECTED object:_dic_singleData];
}
@end
