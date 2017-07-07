//
//  FGLocationListCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGLocationListCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_date;
@property(nonatomic,weak)IBOutlet UILabel *lb_time;
@property(nonatomic,weak)IBOutlet UILabel *lb_location;
@property(nonatomic,weak)IBOutlet UILabel *lb_distance;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin;
@property(nonatomic,weak)IBOutlet UIView *view_whiteBG;
@property(nonatomic,strong)NSString *str_groupId;
-(IBAction)buttonAction_checkIn:(id)_sender;
-(IBAction)buttonAction_leave:(id)_sender;
@end
