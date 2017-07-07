//
//  FGAboutCell.h
//  可展开Cell
//
//  Created by PengLei on 17/1/20.
//  Copyright © 2017年 PengLei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAQFrameModel.h"

@interface FGAboutCell : UITableViewCell
@property (strong,nonatomic) FAQFrameModel * frame_model;

@property (weak, nonatomic) IBOutlet UILabel *lb_question;
@property (weak, nonatomic) IBOutlet UILabel *lb_answer;
@property (weak, nonatomic) IBOutlet UIImageView *imv_arrow;
@property (weak, nonatomic) IBOutlet UIView *vi_line;
@property (weak, nonatomic) IBOutlet UIView *vi_line_bottom;

@property (weak, nonatomic) IBOutlet UIImageView *imv_icon;
@property (copy,nonatomic) NSString * str_imageName;

@property (weak, nonatomic) IBOutlet UILabel *lb_copyright;

@property (copy,nonatomic) NSString *str_copyright;
@end
