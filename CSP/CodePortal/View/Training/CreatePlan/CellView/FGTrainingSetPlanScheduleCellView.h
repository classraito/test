//
//  FGTrainingSetPlanScheduleCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGTrainingSetPlanScheduleCellView;
typedef enum
{
    IconType_Black_Plus = 1,
    IconType_Black_Minus = 2,
    IconType_Blue_Dot = 3,
    IconType_Blue_EmptyDot = 4,
    IconType_Blue_Close = 5,
    IconType_Blue_Plus = 6
}IconType;

@protocol FGTrainingSetPlanScheduleCellViewDelegate <NSObject>
-(void)didClickRightButtonActionAtCell:(FGTrainingSetPlanScheduleCellView *)_cell;
@end

@interface FGTrainingSetPlanScheduleCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_weekDay;
@property(nonatomic,weak)IBOutlet UILabel *lb_monthDay;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_duration;
@property(nonatomic,weak)IBOutlet UILabel *lb_calorious;
@property(nonatomic,weak)IBOutlet UIImageView *iv_duration;
@property(nonatomic,weak)IBOutlet UIImageView *iv_calorious;
@property(nonatomic,weak)IBOutlet UIImageView *iv_rightIcon;
@property(nonatomic,weak)IBOutlet UIButton *btn_rightAction;
@property(nonatomic,strong)NSArray *arr_weeksName_EN;
@property(nonatomic,strong)NSArray *arr_weeksName_CN;
@property(nonatomic,strong)NSMutableDictionary *dic_sports_Thumbnail;
@property(nonatomic,strong)NSString *str_workoutId;
@property(nonatomic,weak)id<FGTrainingSetPlanScheduleCellViewDelegate> delegate;
@property NSIndexPath *indexPathInTable;
@property IconType iconType;
-(IBAction)buttonAction_rightAction:(id)_sender;
-(void)updateCellViewWithInfo_EditPlan:(id)_dataInfo;
-(void)updateCellViewWithInfo_MyPlan:(id)_dataInfo;
@end
