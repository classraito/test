//
//  FGLoginInputNicknameView.m
//  CSP
//
//  Created by JasonLu on 17/2/10.
//  Copyright © 2017年 Fugumobile. All rights reserved.
//

#import "FGLoginInputNicknameView.h"

@implementation FGLoginInputNicknameView
@synthesize lb_title;
@synthesize view_inputCode_BG;
@synthesize tf_inputCode;
@synthesize btn_done;
-(void)awakeFromNib
{
  [super awakeFromNib];
  self.backgroundColor = [UIColor clearColor];
  [commond useDefaultRatioToScaleView:lb_title];
  [commond useDefaultRatioToScaleView:view_inputCode_BG];
  [commond useDefaultRatioToScaleView:tf_inputCode];
  [commond useDefaultRatioToScaleView:btn_done];
  
  lb_title.font = font(FONT_TEXT_REGULAR, 20);
  btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
  tf_inputCode.font = font(FONT_TEXT_REGULAR, 16);
  
  lb_title.text = multiLanguage(@"Please key in your nickname");
  tf_inputCode.placeholder = multiLanguage(@"input nickname here");
  [commond setTextField:tf_inputCode placeHolderFont:font(FONT_TEXT_REGULAR, 16) placeHolderColor:[UIColor lightGrayColor]];
  
  [btn_done setTitle:multiLanguage(@"NEXT") forState:UIControlStateNormal];
  [btn_done setTitle:multiLanguage(@"NEXT") forState:UIControlStateHighlighted];
  
  btn_done.layer.cornerRadius = btn_done.frame.size.height / 2;
  btn_done.layer.masksToBounds = YES;
  btn_done.titleLabel.textColor = [UIColor whiteColor];
  btn_done.backgroundColor = color_red_panel;
  
  view_inputCode_BG.layer.cornerRadius = view_inputCode_BG.frame.size.height/2;
  view_inputCode_BG.layer.masksToBounds = YES;
}

-(void)postRequest_submitNickname
{
  if(!tf_inputCode.text || [tf_inputCode.text isEmptyStr])
  {
    [commond alert:multiLanguage(@"ALERT") message:multiLanguage(@"Please fill in your nick name") callback:^(FGCustomAlertView *alertView, NSInteger buttonIndex) {
      
    }];
    return;
  }
  
  NetworkRequestInfo *_dic_info = [NetworkRequestInfo infoWithURLAlias:nil notifyOnVC:[self viewController]];
  NSMutableArray *arr_needUpdateData = [NSMutableArray arrayWithCapacity:1];
  [arr_needUpdateData addObject:@{
                                  @"ActionType": @"UserName",
                                  @"Value":  [tf_inputCode.text trimmingWhitespace]
                                  }];
  
  [[NetworkManager_User sharedManager] postRequest_SetUserProfile:arr_needUpdateData userinfo:_dic_info];
  
}

-(void)dealloc
{
  NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}


-(IBAction)buttonAction_done:(id)_sender;
{
  [self postRequest_submitNickname];
}

@end
