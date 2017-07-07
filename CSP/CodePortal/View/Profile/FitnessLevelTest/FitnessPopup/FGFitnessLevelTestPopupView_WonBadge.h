//
//  FGFitnessLevelTestPopupView_WonBadge.h
//  CSP
//
//  Created by Ryan Gong on 16/12/7.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGFitnessLevelTestPopupView_WonBadge : FGPopupView
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_badgeBG;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIImageView *iv_badge;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIButton *btn_share;
@property(nonatomic,weak)IBOutlet UIButton *btn_close;
@property(nonatomic,weak)IBOutlet UIImageView *iv_close;
@end
