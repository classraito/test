//
//  FGLoginShareYourInvitationViewController.h
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGLoginInputInvitationCodeView.h"
@interface FGLoginShareYourInvitationViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_boxTitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_bottomTip;
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UIView *view_invitation_BG;
@property(nonatomic,weak)IBOutlet UITextView *tv_yourInvitation;
@property(nonatomic,weak)IBOutlet UIButton *btn_shareToFriend;
@property(nonatomic,weak)IBOutlet UIButton *btn_skip;
-(IBAction)buttonAction_shareToFriend:(id)_sender;
-(IBAction)buttonAction_skip:(id)_sender;
@end
