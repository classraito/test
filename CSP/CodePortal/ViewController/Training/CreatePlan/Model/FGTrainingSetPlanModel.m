//
//  FGTrainingSetPlanModel.m
//  CSP
//
//  Created by Ryan Gong on 16/12/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingSetPlanModel.h"
#import "Global.h"
static FGTrainingSetPlanModel *setPlanModel;
@implementation FGTrainingSetPlanModel
@synthesize weeks;
@synthesize arr_singleOriginalWorkout;
@synthesize arr_editedWorkout;
@synthesize timeStamp;
+(FGTrainingSetPlanModel *)sharedModel
{
    @synchronized(self)     {
        if(!setPlanModel)
        {
            setPlanModel=[[FGTrainingSetPlanModel alloc]init];
            
            
            return setPlanModel;
        }
    }
    return setPlanModel;
}

-(id)init
{
    if(self = [super init])
    {
        
        
    }
    return self;
}

+(id)alloc
{
    @synchronized(self)     {
        NSAssert(setPlanModel == nil, @"企圖重复創建一個singleton模式下的FGTrainingSetPlanModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    arr_singleOriginalWorkout = nil;
    arr_editedWorkout = nil;

}

+(void)clearModel
{
    if(!setPlanModel)
        return;
    setPlanModel = nil;
}
@end
