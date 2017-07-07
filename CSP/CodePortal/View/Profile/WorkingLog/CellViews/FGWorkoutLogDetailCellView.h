//
//  FGWorkoutLogDetailCellView.h
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGWorkoutLogDetailCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_detail;
@property (weak, nonatomic) IBOutlet UIView *view_separator;

- (void)updateCellViewWithInfo:(id)_dataInfo;
@end
