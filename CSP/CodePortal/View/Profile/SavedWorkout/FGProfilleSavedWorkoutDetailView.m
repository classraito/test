//
//  FGProfilleSavedWorkoutDetailView.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfilleSavedWorkoutDetailView.h"
#import "Global.h"
@interface FGProfilleSavedWorkoutDetailView()
{
    
}
@end

@implementation FGProfilleSavedWorkoutDetailView
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.isNeedRemoveComments = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

#pragma mark - 工具
-(NSMutableDictionary *)giveWorkOutDetailDataByWorkoutID
{
    FGProfileSavedWorkoutDetailViewController *vc = (FGProfileSavedWorkoutDetailViewController *)[self viewController];
    NSString *str_workoutId = [NSString stringWithFormat:@"%@",vc.workoutID];
    
    NSMutableDictionary *_dic_savedWorkoutDatas = [[commond getUserDefaults:KEY_SAVEDWORKOUT_DATAS] mutableCopy];
    
    NSMutableDictionary *_dic_currentWorkoutData = [_dic_savedWorkoutDatas objectForKey:str_workoutId];
    
    NSLog(@"_dic_currentWorkoutData = %@",_dic_currentWorkoutData);
    return _dic_currentWorkoutData;
}

#pragma mark - 覆盖父类方法
- (id)giveMeResponseContentByResponseName:(NSString *)_str_responseName {
    NSMutableDictionary *_dic_result = [self giveWorkOutDetailDataByWorkoutID];
    NSLog(@"_dic_result = %@",_dic_result);
    return [self giveMeResponseContentByResponseName:_str_responseName fromDatas:_dic_result];
}

- (void)internalInitalDialogView {

}


-(void)addPullToRefresh
{
    
}

-(void)postRequest
{
    
}
@end
