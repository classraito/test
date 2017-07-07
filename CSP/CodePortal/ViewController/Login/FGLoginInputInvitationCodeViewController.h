//
//  FGLoginInputInvitationCodeViewController.h
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGLoginInputInvitationCodeView.h"
@interface FGLoginInputInvitationCodeViewController : FGBaseViewController
{
    
}
@property(nonatomic,strong)FGLoginInputInvitationCodeView *view_inputInvitationCode;
-(void)go2ShareYourInvitation;
@end
