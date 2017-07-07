//
//  FGTrainingWorkoutListView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTrainingWorkoutListView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    
}
@property(nonatomic,strong)NSMutableArray *arr_dataInTable;
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property WorkoutType workoutType;
-(void)bindDataToUI;
-(void)postReqeust;
-(void)beginRefresh;
@end
