//
//  FGHomepageTrendingWorkoutCellView.h
//  CSP
//
//  Created by JasonLu on 16/9/17.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGHomepageTrendingWorkoutCellViewDelegate <NSObject>
@optional
-(void)didClickButton:(UIButton *)button;
-(void)didClickInfoButtonWithType:(NSString *)type objAtIndex:(NSInteger)_idx;
@end

@interface FGHomepageTrendingWorkoutCellView : UITableViewCell
@property (nonatomic, assign) id<FGHomepageTrendingWorkoutCellViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *view_content;
@property (weak, nonatomic) IBOutlet UIView *view_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_select;

@end
