//
//  FGFitnessTestGroupCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGFitnessTestGroupCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_date;
@property(nonatomic,weak)IBOutlet UIImageView *iv_time;
@property(nonatomic,weak)IBOutlet UILabel *lb_duration;
@property(nonatomic,weak)IBOutlet UIImageView *iv_calorious;
@property(nonatomic,weak)IBOutlet UILabel *lb_calorious;
@property(nonatomic,weak)IBOutlet UIImageView *iv_photoThumbnail;
@property(nonatomic,weak)IBOutlet UIButton *btn_photoThumbnail;
@property(nonatomic,weak)IBOutlet UIView *view_separatorLine_h;
-(IBAction)buttonAction_openPhoto:(id)_sender;
@end
