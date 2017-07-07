//
//  FGTrainingHomePageTopBannerView.h
//  CSP
//
//  Created by Ryan Gong on 16/9/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGTrainingHomePageTopBannerCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_banner;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIImageView *iv_shadow;
@property(nonatomic,weak)IBOutlet UIButton *btn;
-(IBAction)buttonAction_go2SetPlan:(id)_sender;
@end
