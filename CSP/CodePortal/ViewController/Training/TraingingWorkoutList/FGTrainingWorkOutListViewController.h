//
//  FGTrainingWorkOutListViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingWorkoutListView.h"
@interface FGTrainingWorkOutListViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong) NSString *str_title;
@property WorkoutType currentWorkoutType;
@property(nonatomic,strong)FGTrainingWorkoutListView *view_workoutList;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)_str_title workoutType:(WorkoutType)_workoutType;

@end
