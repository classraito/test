//
//  FGInputInvitationCodePopView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGPopupView.h"

@interface FGInputInvitationCodePopView : FGUserInputPageBaseView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_title;
@property(nonatomic,weak)IBOutlet UILabel *lb_subTitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_warningInfo;
@property(nonatomic,weak)IBOutlet UITextField *tf_invitationCode;
@property(nonatomic,weak)IBOutlet UIButton *btn_done;
@property(nonatomic,weak)IBOutlet UIButton *btn_cancel;
-(void)bindDataToUI;
@end
