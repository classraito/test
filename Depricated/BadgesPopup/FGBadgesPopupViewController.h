//
//  FGBadgesPopupViewController.h
//  CSP
//
//  Created by Ryan Gong on 17/1/11.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGCustomUnderlineButton.h"
@interface FGBadgesPopupViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIImageView *iv_badgeThumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet FGCustomUnderlineButton *cub_shareNow;
@property(nonatomic,weak)IBOutlet UIButton *btn_seeMyBadges;
-(void)updateBadgesPopup:(id)_sender;
@end
