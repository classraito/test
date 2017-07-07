//
//  FGBaseBookingCellView.h
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGBaseBookingCellView : UITableViewCell
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@property(nonatomic,weak)IBOutlet UIImageView *iv_thumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_username;
@property(nonatomic,weak)IBOutlet UILabel *lb_time;
@property(nonatomic,weak)IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UIButton *btn_userIcon;
@end
