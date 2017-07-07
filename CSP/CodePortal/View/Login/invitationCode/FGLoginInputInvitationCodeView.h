//
//  FGLoginInputInvitationCodeView.h
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGUserInputPageBaseView.h"

@interface FGLoginInputInvitationCodeView : FGUserInputPageBaseView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subtitle;
@property(nonatomic,weak)IBOutlet UIView *view_inputCode_BG;
@property(nonatomic,weak)IBOutlet UITextField *tf_inputCode;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;
@property(nonatomic,weak)IBOutlet UIButton *btn_skip;

-(IBAction)buttonAction_done:(id)_sender;
-(IBAction)buttonAction_skip:(id)_sender;
-(void)postRequest_submitInvitationCode;
@end
