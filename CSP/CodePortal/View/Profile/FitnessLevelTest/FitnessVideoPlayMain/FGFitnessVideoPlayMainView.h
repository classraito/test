//
//  FGFitnessVideoPlayMainView.h
//  CSP
//
//  Created by Ryan Gong on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGTrainingVideoPlayMainView.h"
@protocol FGFitnessVideoPlayMainViewDelegate<NSObject>
-(void)didTapOnPlankExerciseVideo;
@end

@interface FGFitnessVideoPlayMainView : FGTrainingVideoPlayMainView
{
    
}
@property(nonatomic,weak)id<FGFitnessVideoPlayMainViewDelegate>delegate_fitnessVideo;
@property(nonatomic,strong)  NSMutableArray *arr_filepath;
@end
