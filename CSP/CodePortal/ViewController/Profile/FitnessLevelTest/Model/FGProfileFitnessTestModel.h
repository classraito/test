//
//  FGProfileFitnessTestModel.h
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FGProfileFitnessTestModel : NSObject
{
    
}
@property int pushupsCount;
@property int situpsCount;
@property int squatsCount;
@property int burpees;
@property long plankSecs;
@property int totalCount;
@property long totalTime;
@property int calorious;
@property(nonatomic,strong)NSString *str_fitnessTestID;
@property(nonatomic,strong)NSTimer *timer;
+(FGProfileFitnessTestModel *)sharedModel;
+(void)clearModel;
-(void)resetData;
-(void)initalTimer;
-(void)invalidateTimer;
@end
