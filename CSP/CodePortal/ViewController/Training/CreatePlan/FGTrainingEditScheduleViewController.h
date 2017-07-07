//
//  FGTrainingEditScheduleViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGTrainingSetPlanWeekSectionView.h"
#import "FGTrainingSetPlanScheduleCellView.h"
#define NOTIFICATION_WORKOUT_SELECTED @"NOTIFICATION_WORKOUT_SELECTED"

@interface FGTrainingEditScheduleViewController : FGBaseViewController<FGTrainingSetPlanScheduleCellViewDelegate>{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)FGTrainingSetPlanWeekSectionView  *view_sectionTitle;
@end


@interface FGTrainingEditScheduleViewController(Table)<UITableViewDelegate,UITableViewDataSource>
{
    
}
-(void)bindDataToUI;
@end
