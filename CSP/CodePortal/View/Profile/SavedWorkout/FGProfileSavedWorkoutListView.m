//
//  FGProfileSavedWorkoutListView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileSavedWorkoutListView.h"
#import "Global.h"
#import "FGProfileSavedWorkoutDetailViewController.h"
@implementation FGProfileSavedWorkoutListView
-(void)awakeFromNib
{
    [super awakeFromNib];
    id obj = [commond getUserDefaults:KEY_SAVEDWORKOUT_DATAS];
    if(!obj)
    {
        NSMutableDictionary *_dic_savedWorkouts = [NSMutableDictionary dictionaryWithCapacity:1];
        [commond setUserDefaults:_dic_savedWorkouts forKey:KEY_SAVEDWORKOUT_DATAS];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

- (id)giveMeResponseContentByResponseName:(NSString *)_str_responseName fromDatas:(NSMutableDictionary *)_dic_result {
    NSMutableArray *_arr_datas       = [_dic_result objectForKey:@"Responses"];
    for (NSMutableDictionary *_dic_data in _arr_datas) {
        NSString *str_responseName = [_dic_data objectForKey:@"ResponseName"];
        if ([_str_responseName isEqualToString:str_responseName]) {
            id _obj_responseContent = [_dic_data objectForKey:@"ResponseContent"];
            return _obj_responseContent;
        }
    }
    return nil;
}

#pragma mark - 覆盖父类方法
-(void)bindDataToUI
{
    NSMutableDictionary *_dic_savedWorkouts = [[commond getUserDefaults:KEY_SAVEDWORKOUT_DATAS] mutableCopy];
    NSMutableArray *_arr_savedWorkouts_allKeys = [[_dic_savedWorkouts allKeys] mutableCopy];
    NSMutableArray *_arr_savedWorkouts_allValues = [[_dic_savedWorkouts allValues] mutableCopy];
    NSMutableArray *_arr_savedWorkoutLists = [NSMutableArray arrayWithCapacity:1];
    for(int i=0;i<[_arr_savedWorkouts_allKeys count];i++)
    {
        NSMutableDictionary *_dic_savedWorkout = [NSMutableDictionary dictionaryWithCapacity:1];
        
        NSMutableDictionary *_dic_singleWorkoutData = [_arr_savedWorkouts_allValues objectAtIndex:i];
        _dic_singleWorkoutData = [self giveMeResponseContentByResponseName:@"GetTrainDetail" fromDatas:_dic_singleWorkoutData];
        
        NSString *_str_trainingId = [NSString stringWithFormat:@"%@",[_arr_savedWorkouts_allKeys objectAtIndex:i]];
        
        NSString *_str_screenName = [_dic_singleWorkoutData objectForKey:@"ScreenName"];
        NSString *_str_thumbnail = [_dic_singleWorkoutData objectForKey:@"Thumbnail"];
        NSString *_str_Minutes = [_dic_singleWorkoutData objectForKey:@"Duration"];
        NSString *_str_Intensity = [_dic_singleWorkoutData objectForKey:@"Intensity"];
        NSString *_str_Level = [_dic_singleWorkoutData objectForKey:@"Level"];
        NSString *_str_Consume = [_dic_singleWorkoutData objectForKey:@"Estimated_Calories_Burned"];
        
        
        [_dic_savedWorkout setObject:_str_trainingId forKey:@"TrainingId"];
        [_dic_savedWorkout setObject:_str_screenName forKey:@"ScreenName"];
        [_dic_savedWorkout setObject:_str_thumbnail forKey:@"Thumbnail"];
        [_dic_savedWorkout setObject:_str_Minutes forKey:@"Minutes"];
        [_dic_savedWorkout setObject:_str_Intensity forKey:@"Intensity"];
        [_dic_savedWorkout setObject:_str_Level forKey:@"Level"];
        [_dic_savedWorkout setObject:_str_Consume forKey:@"Consume"];
       
        [_arr_savedWorkoutLists addObject:_dic_savedWorkout];
    }
    
    self.arr_dataInTable = _arr_savedWorkoutLists;
    
    [self.tb resetNoResultView];
    if([self.arr_dataInTable count] == 0)
    {
        [self.tb showNoResultWithText:multiLanguage(@"You haven't saved any workout yet!")];
    }
    
    [self.tb reloadData];
    self.tb.mj_header = nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    id _workoutID = [[self.arr_dataInTable objectAtIndex:indexPath.row] objectForKey:@"TrainingId"];
    NSLog(@"_workoutID = %@",_workoutID);
    FGProfileSavedWorkoutDetailViewController *vc_trainingDetail = [[FGProfileSavedWorkoutDetailViewController alloc] initWithNibName:@"FGProfileSavedWorkoutDetailViewController" bundle:nil workoutID:_workoutID];
    [manager pushController:vc_trainingDetail navigationController:nav_current];
    
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
    NSMutableDictionary *_dic_savedWorkouts = [[commond getUserDefaults:KEY_SAVEDWORKOUT_DATAS] mutableCopy];
    
    NSLog(@"_dic_savedWorkouts = %@",_dic_savedWorkouts);
    
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:multiLanguage(@"Delete") handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            
            id _workoutID = [[self.arr_dataInTable objectAtIndex:indexPath.row] objectForKey:@"TrainingId"];
            [self deleteStepVideos:[_dic_savedWorkouts objectForKey:_workoutID]];//删除这个workout的所有本地文件 包括视频和音频
            
            if([[_dic_savedWorkouts allKeys] containsObject:_workoutID])
            {
                [_dic_savedWorkouts removeObjectForKey:_workoutID];
            }
            [commond setUserDefaults:_dic_savedWorkouts forKey:KEY_SAVEDWORKOUT_DATAS];
            
            [self.arr_dataInTable removeObjectAtIndex:indexPath.row];
            [self.tb beginUpdates];
            [self.tb deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tb endUpdates];
            
    }];
        
    return @[deleteRowAction];
}

-(void)deleteStepVideos:(NSMutableDictionary *)_dic_workout
{

    NSMutableDictionary * _dic_singleWorkoutData = [self giveMeResponseContentByResponseName:@"GetTrainingStep" fromDatas:_dic_workout];
    NSMutableArray *_arr_stepVideos = [_dic_singleWorkoutData objectForKey:@"StepVideos"];
    for(NSMutableDictionary *_dic_singleInfo in _arr_stepVideos)
    {
        NSString *_str_videoUrl = [_dic_singleInfo objectForKey:@"VideoUrl"];
        NSString *_str_audioUrl = [_dic_singleInfo objectForKey:@"AudioUrl"];
        
        if(![_str_videoUrl isEmptyStr])
        {
            NSString *fileAbsolutePath = [self convertUrlToFilePaths:_str_videoUrl];//将视频url转换成 本地实际路径
            if([self isFileExsitAtPath:fileAbsolutePath])
            {
                BOOL isdelete = [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:nil];
                if(isdelete)
                {
                    NSLog(@"删除视频[%@]成功!",fileAbsolutePath);
                }
                else
                {
                    NSLog(@"删除视频[%@]成功!",fileAbsolutePath);
                }
            }
        }
        
        if(![_str_audioUrl isEmptyStr])
        {
            NSString *fileAbsolutePath = [self convertUrlToFilePaths:_str_audioUrl];//将音频url转换成 本地实际路径
            if([self isFileExsitAtPath:fileAbsolutePath])
            {
                BOOL isdelete = [[NSFileManager defaultManager] removeItemAtPath:fileAbsolutePath error:nil];
                if(isdelete)
                {
                    NSLog(@"删除音频[%@]失败!",fileAbsolutePath);
                }
                else
                {
                    NSLog(@"删除音频[%@]失败!",fileAbsolutePath);
                }

            }
        }
        
    }//循环遍历stepvideos
}
    
/*判断是否时http:// 或 https://风格的URL*/
-(BOOL)isUrlsScheme:(NSString *)_str
{
    if([_str hasPrefix:@"http://"] || [_str hasPrefix:@"https://"])
        return YES;
    else
        return NO;
}
    
/*把一个url 转换成文件名*/
-(NSString *)convertUrlToFilePaths:(NSString *)_str_videoUrl
{
    _str_videoUrl = [_str_videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *_str_filename = [_str_videoUrl stringByReplacingOccurrencesOfString:@"://" withString:@"__"];
    _str_filename = [_str_filename stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
       
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    //目的路径，设置一个目的路径用来存储下载下来的文件
    NSString *savePath = [path stringByAppendingPathComponent:_str_filename];

        
    return savePath;
}
    
/*判断一个文件是否存在*/
-(BOOL)isFileExsitAtPath:(NSString *)_str_filePath
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:_str_filePath];
        return  fileExists;
    }
@end







