//
//  FGProfileFitnessTestModel.m
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileFitnessTestModel.h"
#import "Global.h"

static FGProfileFitnessTestModel *fitnessModel;
@implementation FGProfileFitnessTestModel
@synthesize pushupsCount;
@synthesize situpsCount;
@synthesize squatsCount;
@synthesize burpees;
@synthesize plankSecs;
@synthesize totalTime;
@synthesize totalCount;
@synthesize timer;
@synthesize str_fitnessTestID;
@synthesize calorious;
+(FGProfileFitnessTestModel *)sharedModel
{
    @synchronized(self)     {
        if(!fitnessModel)
        {
            fitnessModel=[[FGProfileFitnessTestModel alloc]init];
            
            
            return fitnessModel;
        }
    }
    return fitnessModel;
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
        NSAssert(fitnessModel == nil, @"企圖重复創建一個singleton模式下的FGProfileFitnessTestModel");
        return [super alloc];
    }
    return nil;
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    str_fitnessTestID = nil;
}

-(void)resetData
{
    pushupsCount = 0;
    situpsCount = 0;
    squatsCount = 0;
    burpees = 0;
    plankSecs = 0;
    totalTime = 0;
    totalCount = 0;
    calorious = 0;
}

+(void)clearModel
{
    if(!fitnessModel)
        return;
    fitnessModel = nil;
}

-(void)initalTimer
{
    if(timer)
        return;
    
    plankSecs = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSecs:) userInfo:nil repeats:YES];
    
}

-(void)updateSecs:(id)_sender
{
    plankSecs ++;
}

-(void)invalidateTimer
{
    if(!timer)
        return;
    
    SAFE_INVALIDATE_TIMER(timer);
    timer = nil;
}

@end
