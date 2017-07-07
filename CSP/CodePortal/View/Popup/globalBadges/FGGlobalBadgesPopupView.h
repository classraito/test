//
//  FGGlobalBadgesPopupView.h
//  CSP
//
//  Created by Ryan Gong on 17/1/19.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"
#import "FGCustomUnderlineButton.h"
@interface FGGlobalBadgesPopupView : FGPopupView
{
    
}

@property(nonatomic,weak)IBOutlet UIImageView *iv_badgeThumbnail;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet FGCustomUnderlineButton *cub_shareNow;
@property(nonatomic,weak)IBOutlet UIButton *btn_seeMyBadges;
@property(nonatomic,weak)IBOutlet UIImageView *iv_close;
@property(nonatomic,weak)IBOutlet UIButton *btn_close;
@property(nonatomic,weak)IBOutlet UIView *view_badgesBG;
-(void)updateBadgesPopup:(id)_sender;
-(IBAction)buttonAction_close:(id)_sender;
-(void)buttonAction_seeMyBadges:(id)_sender;
@end
