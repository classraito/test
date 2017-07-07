//
//  FGWorkoutLogSectionView.h
//  CSP
//
//  Created by JasonLu on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGWorkoutLogSectionView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iv_time;
@property (weak, nonatomic) IBOutlet UIImageView *iv_fireEmpty;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_caloria;
- (void)updateSectionViewWithInfo:(id)_dataInfo;
@end
