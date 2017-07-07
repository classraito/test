//
//  FGTrainingStepByStepCellViewTableViewCell.h
//  CSP
//
//  Created by Ryan Gong on 16/9/20.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTrainingStepByStepCellViewTableViewCell : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_duration;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIImageView *iv_arr_right;
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@end
