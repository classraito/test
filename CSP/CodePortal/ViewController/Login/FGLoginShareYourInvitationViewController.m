//
//  FGLoginShareYourInvitationViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//
#import "FGLoginShareYourInvitationViewController.h"
#import "Global.h"
@interface FGLoginShareYourInvitationViewController ()
{
    
}
@end

@implementation FGLoginShareYourInvitationViewController
@synthesize lb_boxTitle;
@synthesize lb_bottomTip;
@synthesize lb_title;
@synthesize view_invitation_BG;
@synthesize tv_yourInvitation;
@synthesize btn_shareToFriend;
@synthesize btn_skip;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    SAFE_RemoveSupreView(self.view_topPanel);
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self hideBottomPanelWithAnimtaion:NO];
    self.iv_bg.image = [UIImage imageNamed:@"fitness_bg.jpg"];
    
    [self internalInitalize];
}

-(void)internalInitalize
{
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:view_invitation_BG];
    [commond useDefaultRatioToScaleView:tv_yourInvitation];
    [commond useDefaultRatioToScaleView:btn_shareToFriend];
    [commond useDefaultRatioToScaleView:btn_skip];
    [commond useDefaultRatioToScaleView:lb_boxTitle];
    [commond useDefaultRatioToScaleView:lb_bottomTip];
    
    lb_boxTitle.font = font(FONT_TEXT_BOLD, 32);
    lb_title.font = font(FONT_TEXT_REGULAR, 22);
    lb_bottomTip.font = font(FONT_TEXT_REGULAR, 12);
    tv_yourInvitation.font = font(FONT_TEXT_REGULAR, 16);
    btn_skip.titleLabel.font = font(FONT_TEXT_REGULAR, 14);
    btn_shareToFriend.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    lb_boxTitle.text = multiLanguage(@"Earn 50RMB");
    NSString *_str_title = multiLanguage(@"refer a friend and earn 50RMB!");
    NSString *_str_subtitle = multiLanguage(@"Share your code and earn 50RMB credit per person that you refer*");
    lb_title.text = [NSString stringWithFormat:@"%@\n\n%@",_str_title,_str_subtitle];
    [lb_title setCustomColor:[UIColor lightGrayColor] searchText:_str_subtitle font:font(FONT_TEXT_REGULAR, 20)];
    
    lb_bottomTip.text = multiLanguage(@"*50RMB credit is earned once the user downloads and uses the personal trainer booking engine.");
    
    lb_boxTitle.backgroundColor = color_red_panel;
    lb_boxTitle.layer.cornerRadius = 10;
    lb_boxTitle.layer.masksToBounds = YES;
    
    [btn_skip setTitle:multiLanguage(@"SKIP") forState:UIControlStateNormal];
    [btn_skip setTitle:multiLanguage(@"SKIP") forState:UIControlStateHighlighted];
    
    [btn_shareToFriend setTitle:multiLanguage(@"SHARE TO FRIENDS") forState:UIControlStateNormal];
    [btn_shareToFriend setTitle:multiLanguage(@"SHARE TO FRIENDS") forState:UIControlStateHighlighted];
    
    view_invitation_BG.layer.cornerRadius = view_invitation_BG.frame.size.height / 2;
    view_invitation_BG.layer.masksToBounds = YES;
    
    btn_shareToFriend.layer.cornerRadius = btn_shareToFriend.frame.size.height / 2;
    btn_shareToFriend.layer.masksToBounds = YES;
    btn_shareToFriend.backgroundColor = color_red_panel;
    
//    FGLoginViewController *vc = [self giveMeLoginVC];
  tv_yourInvitation.text = [NSString stringWithFormat:@"%@",[commond getUserDefaults:USERINVITATIONCODE] ];//vc.str_myInvitationCode;
}

-(FGLoginViewController *)giveMeLoginVC
{
    for(UIViewController *vc in nav_current.viewControllers)
    {
        if([vc isKindOfClass:[FGLoginViewController class]])
        {
            FGLoginViewController *vc_login = (FGLoginViewController *)vc;
            return vc_login;
        }
    }
    return nil;
}


-(void)go2HomeViewControllerFromLogin
{
//    [self dismissViewControllerAnimated:NO completion:^{ }];
    FGLoginViewController *vc_login = [self giveMeLoginVC];
    [nav_current popToViewController:vc_login animated:NO];
   [vc_login go2HomeViewController];
}

-(IBAction)buttonAction_shareToFriend:(id)_sender;
{
//#define share_inviationCode_content1 multiLanguage(@" I am giving you 50RMB off of your first personal training session with WEBOX. To enjoy it, please use my")
//#define share_inviationCode_content2 multiLanguage(@"Happy training!")
//#define share_inviationCode_link @"http://weboxapp.com"
  // FIXME: share
  // tv_yourInvitation.text
  [[FGSNSManager shareInstance] actionToShareInviateCodeOnView:self.view title:share_inviationCode_title text:[NSString stringWithFormat:@"%@ %@;%@.%@",share_inviationCode_content1,multiLanguage(@"Invitation code:"), tv_yourInvitation.text,share_inviationCode_content2] url:share_inviationCode_link inviateCode:tv_yourInvitation.text];
}

-(IBAction)buttonAction_skip:(id)_sender;
{
    [self go2HomeViewControllerFromLogin];
}


-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
  
}
@end
