//
//  FGTrainingSetPlanMyPlanTopBannerView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FGTrainingSetPlanMyPlanTopBannerView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_infoContainer;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_date;
@property(nonatomic,weak)IBOutlet UIButton *btn_doWorkout;
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,strong)NSString *str_workoutId;
-(void)initalCellWithInfo:(id)_dataInfo;
-(IBAction)buttonAction_doWorkout:(id)_sender;
@end
