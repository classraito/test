//
//  FGLoginInputInvitationCodeView.m
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLoginInputInvitationCodeView.h"
#import "Global.h"
@implementation FGLoginInputInvitationCodeView
@synthesize lb_title;
@synthesize lb_subtitle;
@synthesize view_inputCode_BG;
@synthesize tf_inputCode;
@synthesize btn_done;
@synthesize btn_skip;
-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subtitle];
    [commond useDefaultRatioToScaleView:view_inputCode_BG];
    [commond useDefaultRatioToScaleView:tf_inputCode];
    [commond useDefaultRatioToScaleView:btn_done];
    [commond useDefaultRatioToScaleView:btn_skip];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 20);
    lb_subtitle.font = font(FONT_TEXT_REGULAR, 16);
    btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_skip.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    tf_inputCode.font = font(FONT_TEXT_REGULAR, 16);
    
    lb_title.text = multiLanguage(@"Do you have other boxer invitation code?");
    lb_subtitle.text = multiLanguage(@"Key in to get discount voucher!\nand earn 50RMB");
    tf_inputCode.placeholder = multiLanguage(@"input code here");
    [commond setTextField:tf_inputCode placeHolderFont:font(FONT_TEXT_REGULAR, 16) placeHolderColor:[UIColor lightGrayColor]];
    
    [btn_done setTitle:multiLanguage(@"DONE") forState:UIControlStateNormal];
    [btn_done setTitle:multiLanguage(@"DONE") forState:UIControlStateHighlighted];
    
    [btn_skip setTitle:multiLanguage(@"SKIP") forState:UIControlStateNormal];
    [btn_skip setTitle:multiLanguage(@"SKIP") forState:UIControlStateHighlighted];
    
    btn_done.layer.cornerRadius = btn_done.frame.size.height / 2;
    btn_done.layer.masksToBounds = YES;
    btn_done.titleLabel.textColor = [UIColor whiteColor];
    btn_done.backgroundColor = color_red_panel;
    
    view_inputCode_BG.layer.cornerRadius = view_inputCode_BG.frame.size.height/2;
    view_inputCode_BG.layer.masksToBounds = YES;
    
    
}

-(void)postRequest_submitInvitationCode
{
    if(!tf_inputCode.text || [tf_inputCode.text isEmptyStr])
    {
        [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"If you don't have invitication code, you can select 'skip' to cotinue") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
            
        }];
        return;
    }
    
    
    NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:nil notifyOnVC:[self viewController]];
    [[NetworkManager_Location sharedManager] postRequest_Locations_invitationExchange:tf_inputCode.text userinfo:_dic_info];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}


-(IBAction)buttonAction_done:(id)_sender;
{
    [self postRequest_submitInvitationCode];
}

-(IBAction)buttonAction_skip:(id)_sender;
{
    FGLoginInputInvitationCodeViewController *vc = (FGLoginInputInvitationCodeViewController *)[self viewController];
    [vc go2ShareYourInvitation];
}
@end
