//
//  FGWorkoutLogChartTableViewCell.h
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
  Chart_week = 0,
  Chart_month= 1,
  Chart_total= 2
} enum_ChartType;

@protocol FGWorkoutLogChartTableViewCellDelegate <NSObject>
-(void)didSelectedChartAtIndex:(NSInteger)index;
-(void)didLoadMoreData;
@end


@interface FGWorkoutLogChartTableViewCell : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_line;
@property (nonatomic, assign) NSInteger int_indexSelected;
@property (nonatomic, copy) NSString *str_cursor;
@property (nonatomic, assign) id<FGWorkoutLogChartTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *marr_data_workoutChart;
- (void)scrollviewToLastest;
- (void)updateCellViewWithInfo:(id)_dataInfo;
- (void)internalInitalCollectionViewWithStyle:(enum_ChartType)charType withIndex:(NSInteger)_int_idx;

- (void)bindDataToUIForWeek_loadMore;
- (void)bindDataToUIForMonth_loadMore;
- (void)hideLoadingIfNeeded:(BOOL)isHidden;
- (void)refreshChart;
- (UICollectionView *)getCurrentCollectionView;
- (void)updateCellViewWithInfo:(id)_dataInfo isMove:(BOOL)_bool_isMove;
@end
