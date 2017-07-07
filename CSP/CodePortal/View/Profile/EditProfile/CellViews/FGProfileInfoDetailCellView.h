//
//  FGProfileInfoDetailCellView.h
//  CSP
//
//  Created by JasonLu on 16/10/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDHTMLLabel;
@interface FGProfileInfoDetailCellView : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lb_leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *lb_rightTitle;
@property (weak, nonatomic) IBOutlet UIImageView *iv_icon;
@property (weak, nonatomic) IBOutlet UITextField *tf_content;
- (void)setupCellInfoWithHidden:(BOOL)hidden;
- (void)setupCellInfoWithLeftFont:(UIFont *)lfont leftColor:(UIColor *)lcolor rightFont:(UIFont *)rfont rightColor:(UIColor *)rcolor;
@end
