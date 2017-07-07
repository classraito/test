//
//  FGTrainingWorkOutListView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGTrainingTableSectionView.h"
#import "FGTrainingHomePageTopBannerCellView.h"
#import "FGTrainingBrowserByTypeCellView.h"
@interface FGTrainingHomePageView : UIView<UITableViewDelegate,UITableViewDataSource,FGTrainingBrowserByTypeCellViewDelegate,FGTrainingTableSectionViewDelegate>
{
    
}
@property TraingHomePage_SectionType currentSectionType;
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,strong)FGTrainingTableSectionView *view_trainingSection;
@property(nonatomic,strong)NSMutableArray *arr_dataInTable;
-(void)bindDataToUIByStatus:(TraingHomePage_SectionType)_sectionType;
-(void)postRequestByStatus:(TraingHomePage_SectionType)_secionTypeNeedReqeust;
-(void)fillWorkoutSectionDatasManully;
-(void)internalInital;
-(void)internalInitalTrainingSectionView;
-(UITableViewCell *)giveMeTrainingWorkoutCell:(UITableView *)_tb;
-(UITableViewCell *)giveMeBrowserByTypeCell:(UITableView *)_tb;
-(UITableViewCell *)giveMeWorkoutTypeCell:(UITableView *)_tb;
#pragma mark - 进入到FGTrainingWorkOutListViewController
-(void)go2TrainingWorkoutListViewController:(NSString *)_str_title workoutType:(WorkoutType)_workoutType;
@end
