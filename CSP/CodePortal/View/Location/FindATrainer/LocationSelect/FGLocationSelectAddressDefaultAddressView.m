//
//  FGLocationSelectAddressDefaultAddressCell.m
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGLocationSelectAddressDefaultAddressView.h"
#import "Global.h"

@implementation FGLocationSelectAddressDefaultAddressView
@synthesize lb_address1;
@synthesize lb_address2;
@synthesize iv_pin1;
@synthesize iv_pin2;
@synthesize view_separator;
@synthesize btn_address1;
@synthesize btn_address2;
@synthesize view_separator_h;
#pragma mark - 生命周期
-(void)awakeFromNib
{
    [super awakeFromNib];
    [commond useDefaultRatioToScaleView:lb_address1];
    [commond useDefaultRatioToScaleView:lb_address2];
    [commond useDefaultRatioToScaleView:iv_pin1];
    [commond useDefaultRatioToScaleView:iv_pin2];
    [commond useRatio:CGRectMake(ratioW, ratioH, 1, ratioH) toScaleView:view_separator];
    [commond useDefaultRatioToScaleView:btn_address1];
    [commond useDefaultRatioToScaleView:btn_address2];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator_h];
    
    lb_address1.font = font(FONT_TEXT_REGULAR, 14);
    lb_address2.font = font(FONT_TEXT_REGULAR, 14);
    
    lb_address1.text = [NSString stringWithFormat:@"%@\n%@",multiLanguage(@"HOME ADDRESS"),multiLanguage(@"SETTING") ];
    lb_address2.text = [NSString stringWithFormat:@"%@\n%@",multiLanguage(@"COMPANY ADDRESS"),multiLanguage(@"SETTING") ];
    
    [lb_address1 setCustomColor:lb_address1.textColor searchText:multiLanguage(@"SETTING") font:font(FONT_TEXT_REGULAR, 12)];
    [lb_address2 setCustomColor:lb_address1.textColor searchText:multiLanguage(@"SETTING") font:font(FONT_TEXT_REGULAR, 12)];
    
    [self updateDefaultAddress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDefaultAddress) name:NOTIFICATION_UPDATE_DEFAULTADDRESS object:nil];
}

-(void)updateDefaultAddress
{
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    if(_str_address1 && ![_str_address1 isEmptyStr])
    {
        lb_address1.text = _str_address1;
        lb_address1.font = font(FONT_TEXT_REGULAR, 14);
    }
    
    if(_str_address2 && ![_str_address2 isEmptyStr])
    {
        lb_address2.text = _str_address2;
        lb_address2.font = font(FONT_TEXT_REGULAR, 14);
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATE_DEFAULTADDRESS object:nil];
}
@end
