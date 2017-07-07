//
//  FGLoginInputInvitationCodeViewController.m
//  CSP
//
//  Created by Ryan Gong on 17/1/9.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLoginInputInvitationCodeViewController.h"
#import "Global.h"
@interface FGLoginInputInvitationCodeViewController ()
{
    
}
@end

@implementation FGLoginInputInvitationCodeViewController
@synthesize view_inputInvitationCode;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SAFE_RemoveSupreView(self.view_topPanel);
    [self hideBottomPanelWithAnimtaion:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self internalInitalInvitationCodeView];
    
    self.iv_bg.image = [UIImage imageNamed:@"fitness_bg.jpg"];
}

-(void)internalInitalInvitationCodeView
{
    if(view_inputInvitationCode)
        return;
    
    view_inputInvitationCode = (FGLoginInputInvitationCodeView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLoginInputInvitationCodeView" owner:nil options:nil] objectAtIndex:0];
    [commond useDefaultRatioToScaleView:view_inputInvitationCode];
    view_inputInvitationCode.frame = CGRectMake(0, 0, W, H);
    [self.view addSubview:view_inputInvitationCode];
    [view_inputInvitationCode setupByOriginalContentSize:view_inputInvitationCode.bounds.size];
}

-(void)go2ShareYourInvitation
{
//    [self dismissViewControllerAnimated:NO completion:^{
//    }];
    
    FGLoginShareYourInvitationViewController *vc_shareInvitationCode = [[FGLoginShareYourInvitationViewController alloc] initWithNibName:@"FGLoginShareYourInvitationViewController" bundle:nil];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushController:vc_shareInvitationCode navigationController:nav_current];
//    [nav_home presentViewController:vc_shareInvitationCode animated:YES completion:^{
//    }];
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
    [super receivedDataFromNetwork:_notification];
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    
    if ([HOST(URL_LOCATION_InvitationExchange) isEqualToString:_str_url]) {
        [self go2ShareYourInvitation];
    }
    
    
}

- (void)requestFailedFromNetwork:(NSNotification *)_notification {
    [super requestFailedFromNetwork:_notification];
    
    NSMutableDictionary *_dic_requestInfo = _notification.object;
    NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
    
    
    if ([HOST(URL_LOCATION_InvitationExchange) isEqualToString:_str_url]) {
        
    }
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    view_inputInvitationCode = nil;
}
@end
