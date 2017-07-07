//
//  FGTrainingWorkoutCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/18.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "FGViewsQueueCustomView.h"
@interface FGTrainingWorkoutCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,weak)IBOutlet UIImageView *iv_shadow;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_minutes;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_minutes;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_level;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_level;
@property(nonatomic,weak)IBOutlet UILabel *lb_key_intensity;
@property(nonatomic,weak)IBOutlet FGViewsQueueCustomView *qv_intensity;
@end
