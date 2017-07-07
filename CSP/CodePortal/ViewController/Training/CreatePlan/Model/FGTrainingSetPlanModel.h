//
//  FGTrainingSetPlanModel.h
//  CSP
//
//  Created by Ryan Gong on 16/12/16.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGTrainingSetPlanModel : NSObject
{
    
}
@property int weeks;//服务器推荐的课程周数
@property(nonatomic,strong)NSMutableArray *arr_singleOriginalWorkout;//服务器推荐的没修改过的单周数据
@property(nonatomic,strong)NSMutableArray *arr_editedWorkout;//客户端编辑后的数据
@property long timeStamp;
+(FGTrainingSetPlanModel *)sharedModel;
+(void)clearModel;
@end
