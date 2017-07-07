//
//  FGWorkingLogView.h
//  CSP
//
//  Created by JasonLu on 16/12/6.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGWorkoutLogSectionView.h"
#import "FGWorkingLogSectionView.h"
@interface FGWorkingLogView : UIView < UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) int int_cursor;
@property (nonatomic, strong) FGWorkingLogSectionView *view_section;
@property (nonatomic, strong) NSDictionary *dic_oneWorkoutLog;
@property (nonatomic, strong) NSMutableArray *marr_data_oneWorkoutLog;
@property (nonatomic, strong) NSMutableArray *marr_data_workoutLogsTotal;

@property (nonatomic, strong, readonly) NSMutableArray *marr_data_originWorkoutLogsForWeek;
@property (nonatomic, strong, readonly) NSMutableArray *marr_data_originWorkoutLogsForMonth;



@property (strong, nonatomic) IBOutlet UITableView *tb_workoutWeekDetail;
@property (strong, nonatomic) IBOutlet UITableView *tb_workoutMonthDetail;
@property (strong, nonatomic) IBOutlet UITableView *tb_workoutTotalDetail;

@property (nonatomic, assign) BOOL bool_reloadSections;

- (void)beginToRefresh;

- (void)bindDataToUI;
- (void)bindDataToUIForWeekAtIndex:(NSInteger)index;
- (void)bindDataToUIForMonthAtIndex:(NSInteger)index;

- (void)loadMoreWorkoutLogsForWeek;
- (void)loadMoreWorkoutLogsForMonth;

- (void)bindDataToUIForTotal;
- (void)loadMoreWorkoutLogsForTotal;

- (void)runRequest_workoutForWeek;
- (void)runRequest_workoutForMonth;

- (void)runRequest_workoutForTotal;
- (void)loadMore_workoutForTotal;
@end
