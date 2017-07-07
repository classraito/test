//
//  FGLoginInputNicknameViewController.m
//  CSP
//
//  Created by JasonLu on 17/2/10.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLoginInputNicknameViewController.h"
#import "FGLoginInputNicknameView.h"

@interface FGLoginInputNicknameViewController ()

@end

@implementation FGLoginInputNicknameViewController

@synthesize view_inputNickname;
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  SAFE_RemoveSupreView(self.view_topPanel);
  [self hideBottomPanelWithAnimtaion:NO];
  [[UIApplication sharedApplication] setStatusBarHidden:YES];
  [self internalInitalView];
  
  self.iv_bg.image = [UIImage imageNamed:@"fitness_bg.jpg"];
}

-(void)internalInitalView
{
  if(view_inputNickname)
    return;
  
  view_inputNickname = (FGLoginInputNicknameView *)[[[NSBundle mainBundle] loadNibNamed:@"FGLoginInputNicknameView" owner:nil options:nil] objectAtIndex:0];
  [commond useDefaultRatioToScaleView:view_inputNickname];
  view_inputNickname.frame = CGRectMake(0, 0, W, H);
  [self.view addSubview:view_inputNickname];
  [view_inputNickname setupByOriginalContentSize:view_inputNickname.bounds.size];
}

-(void)receivedDataFromNetwork:(NSNotification *)_notification
{
  [super receivedDataFromNetwork:_notification];
  NSMutableDictionary *_dic_requestInfo = _notification.object;
  NSString *_str_url                    = [_dic_requestInfo objectForKey:@"url"];
  
  
  if ([HOST(URL_USER_SetUserProfile) isEqualToString:_str_url]) {
    FGLoginInputInvitationCodeViewController *vc_inputInvitation = [[FGLoginInputInvitationCodeViewController alloc] initWithNibName:@"FGLoginInputInvitationCodeViewController" bundle:nil];
    FGControllerManager *manager = [FGControllerManager sharedManager];
    [manager pushController:vc_inputInvitation navigationController:nav_current];
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
  view_inputNickname = nil;
}

@end
