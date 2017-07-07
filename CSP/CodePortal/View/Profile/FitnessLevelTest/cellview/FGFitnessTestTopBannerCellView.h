//
//  FGFitnessTestTopBannerCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGFitnessTestTopBannerCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_banner;
@property(nonatomic,weak)IBOutlet UIButton *btn_startTest;
-(IBAction)buttonAction_startTest:(id)_sender;
@end
