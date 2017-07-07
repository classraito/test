//
//  FGWorkoutLogTitleCellView.h
//  CSP
//
//  Created by JasonLu on 16/12/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGWorkoutLogTitleCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_workout;
@property (weak, nonatomic) IBOutlet UILabel *lb_hour;
@property (weak, nonatomic) IBOutlet UILabel *lb_caloria;
- (void)updateCellViewWithInfo:(id)_dataInfo;
@end
