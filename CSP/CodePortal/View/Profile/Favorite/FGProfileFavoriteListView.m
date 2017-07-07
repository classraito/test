//
//  FGProfileFavoriteListView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/1.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileFavoriteListView.h"
@interface FGProfileFavoriteListView()
{
    
}
@end

@implementation FGProfileFavoriteListView

-(void)postReqeust
{
    NetworkManager_Training *network_training = [NetworkManager_Training sharedManager];
    [network_training postRequest_GetFavoriteVideoList:YES count:99 userinfo:nil];
}

-(void)bindDataToUI
{
    NSMutableDictionary *_dic_info = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_TRAINING_GetFavoriteVideoList)];
    self.arr_dataInTable = [_dic_info objectForKey:@"Trains"];
    
    if([self.arr_dataInTable count] == 0)
    {
        [self.tb resetNoResultView];
        [self.tb showNoResultWithText:multiLanguage(@"You haven't favorite a workout yet!")];
    }
    
    
    [self.tb reloadData];
    [self.tb.mj_header endRefreshing];
}
    

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
    
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;// 删除cell
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:multiLanguage(@"Delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        id _workoutID = [[self.arr_dataInTable objectAtIndex:indexPath.row] objectForKey:@"TrainingId"];
        [[NetworkManager_Training sharedManager] postRequest_SetTrainFavorite:[NSString stringWithFormat:@"%@",_workoutID] isFavorite:NO userinfo:nil];

        
        [self.arr_dataInTable removeObjectAtIndex:indexPath.row];
        [self.tb beginUpdates];
        [self.tb deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tb endUpdates];
        
    }];

    return @[deleteRowAction];
}
@end
