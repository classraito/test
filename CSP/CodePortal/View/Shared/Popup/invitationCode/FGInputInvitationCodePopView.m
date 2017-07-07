//
//  FGInputInvitationCodePopView.m
//  CSP
//
//  Created by Ryan Gong on 16/11/28.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGInputInvitationCodePopView.h"
#import "Global.h"
@implementation FGInputInvitationCodePopView
@synthesize lb_title;
@synthesize lb_subTitle;
@synthesize lb_warningInfo;
@synthesize tf_invitationCode;
@synthesize btn_done;
@synthesize btn_cancel;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [commond useDefaultRatioToScaleView:lb_title];
    [commond useDefaultRatioToScaleView:lb_subTitle];
    [commond useDefaultRatioToScaleView:lb_warningInfo];
    [commond useDefaultRatioToScaleView:tf_invitationCode];
    [commond useDefaultRatioToScaleView:btn_done];
    [commond useDefaultRatioToScaleView:btn_cancel];
    
    lb_title.font = font(FONT_TEXT_REGULAR, 24);
    lb_subTitle.font = font(FONT_TEXT_REGULAR, 18);
    lb_warningInfo.font = font(FONT_TEXT_REGULAR, 14);
    tf_invitationCode.font = font(FONT_TEXT_REGULAR, 22);
    btn_done.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    btn_cancel.titleLabel.font = font(FONT_TEXT_REGULAR, 18);
    
    lb_subTitle.numberOfLines = 0;
    
    lb_title.text = multiLanguage(@"Input your invitation code.");
    lb_subTitle.text = multiLanguage(@"Lorem ipsum bla bla bla bla blabla bla.");
    lb_warningInfo.text = multiLanguage(@"*wrong code.Please input the right code.");
    lb_warningInfo.hidden = YES;
    tf_invitationCode.text = @"XXXXXXXXXXXXXXXX";
    
    NSString *_str_done = multiLanguage(@"DONE");
    NSString *_str_cancel = multiLanguage(@"CANCEL");
    
    [btn_done setTitle:_str_done forState:UIControlStateNormal];
    [btn_done setTitle:_str_done forState:UIControlStateHighlighted];
    
    [btn_cancel setTitle:_str_cancel forState:UIControlStateNormal];
    [btn_cancel setTitle:_str_cancel forState:UIControlStateHighlighted];
    
    tf_invitationCode.layer.borderWidth = .5;
    tf_invitationCode.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
}

-(void)bindDataToUI
{
    NSMutableDictionary *_dic_result = [[MemoryCache sharedMemoryCache] getDataByUrl:HOST(URL_LOCATION_InvitationExchange)];
    NSLog(@"_dic_result = %@",_dic_result);
    int Code = [[_dic_result objectForKey:@"Code"] intValue];
    if(Code == -110 || Code == -111)
    {
        lb_warningInfo.text = [NSString stringWithFormat:@"* %@",[_dic_result objectForKey:@"Msg"]];
        lb_warningInfo.hidden = NO;
    }
    else if(Code == 0)
    {
        FGPopupViewController *vc = (FGPopupViewController *)[self viewController];
        [vc buttonAction_inputInvitationCode_cancel:nil];
    }
    
}
@end
