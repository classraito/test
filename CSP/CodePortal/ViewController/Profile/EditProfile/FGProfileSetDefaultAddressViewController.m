//
//  FGProfileSetDefaultAddressViewController.m
//  CSP
//
//  Created by Ryan Gong on 16/12/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGProfileSetDefaultAddressViewController.h"

@interface FGProfileSetDefaultAddressViewController ()
{
    
}
@end

@implementation FGProfileSetDefaultAddressViewController
@synthesize lb_value_home;
@synthesize lb_value_company;
@synthesize view_container_home;
@synthesize view_container_company;
@synthesize iv_pin_home;
@synthesize iv_pin_company;
@synthesize btn_homeAddress;
@synthesize btn_companyAddress;
@synthesize str_currentAddress;
@synthesize btn_home_setting;
@synthesize btn_company_setting;
@synthesize view_separator1;
@synthesize view_separator2;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)_str_address;
{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        str_currentAddress = _str_address;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [commond useDefaultRatioToScaleView:view_container_company];
    [commond useDefaultRatioToScaleView:view_container_home];
    [commond useDefaultRatioToScaleView:btn_company_setting];
    [commond useDefaultRatioToScaleView:btn_home_setting];
    [commond useDefaultRatioToScaleView:lb_value_home];
    [commond useDefaultRatioToScaleView:lb_value_company];
    [commond useDefaultRatioToScaleView:iv_pin_company];
    [commond useDefaultRatioToScaleView:iv_pin_home];
    [commond useDefaultRatioToScaleView:btn_companyAddress];
    [commond useDefaultRatioToScaleView:btn_homeAddress];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator1];
    [commond useRatio:CGRectMake(ratioW, ratioH, ratioW, 1) toScaleView:view_separator2];
    
    
    self.view_topPanel.str_title = multiLanguage(@"SET ADDRESS");
    [self hideBottomPanelWithAnimtaion:NO];
    
    lb_value_company.font = font(FONT_TEXT_REGULAR, 16);
    lb_value_home.font = font(FONT_TEXT_REGULAR, 16);
    
    
    lb_value_home.text = [NSString stringWithFormat:@"%@\n\n%@",multiLanguage(@"HOME ADDRESS"),multiLanguage(@"SETTING") ];
    lb_value_company.text = [NSString stringWithFormat:@"%@\n\n%@",multiLanguage(@"COMPANY ADDRESS"),multiLanguage(@"SETTING") ];
    
    [lb_value_home setCustomColor:lb_value_home.textColor searchText:multiLanguage(@"SETTING") font:font(FONT_TEXT_REGULAR, 14)];
    [lb_value_company setCustomColor:lb_value_company.textColor searchText:multiLanguage(@"SETTING") font:font(FONT_TEXT_REGULAR, 14)];
    
    [btn_home_setting setTitle:multiLanguage(@"SETTING") forState:UIControlStateNormal];
    [btn_home_setting setTitle:multiLanguage(@"SETTING") forState:UIControlStateHighlighted];
    [btn_company_setting setTitle:multiLanguage(@"SETTING") forState:UIControlStateNormal];
    [btn_company_setting setTitle:multiLanguage(@"SETTING") forState:UIControlStateHighlighted];
    
    btn_home_setting.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    btn_company_setting.titleLabel.font = font(FONT_TEXT_REGULAR, 16);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDefaultAddress) name:NOTIFICATION_UPDATE_DEFAULTADDRESS object:nil];
    
    view_container_home.layer.cornerRadius = 8;
    view_container_home.layer.masksToBounds = YES;
    view_container_company.layer.cornerRadius = 8;
    view_container_company.layer.masksToBounds = YES;
    
    btn_company_setting.layer.cornerRadius = 8;
    btn_company_setting.layer.masksToBounds = YES;
    btn_home_setting.layer.cornerRadius = 8;
    btn_home_setting.layer.masksToBounds = YES;
    
    [self updateDefaultAddress];
    [self initalDefaultAddressHighlight];
    
}

-(void)initalDefaultAddressHighlight
{
    if(!str_currentAddress)
        return;
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    if(_str_address1 && [_str_address1 isEqualToString:str_currentAddress])
    {
        iv_pin_company.highlighted = NO;
        iv_pin_home.highlighted = YES;
    }
    if(_str_address2 && [_str_address2 isEqualToString:str_currentAddress])
    {
        iv_pin_company.highlighted = YES;
        iv_pin_home.highlighted = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setWhiteBGStyle];
}

-(FGProfileDetailView *)giveMeProfileViewInstance
{
    FGProfileEditViewController *vc = nil;
    for(UIViewController *_vc in nav_current.viewControllers)
    {
        if([_vc isKindOfClass:[FGProfileEditViewController class]])
        {
            vc = (FGProfileEditViewController *)_vc;
            return vc.view_profileDetail;
            
        }
    }
    return nil;
}

-(void)buttonAction_left:(id)_sender
{
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    FGProfileDetailView *view_profileDetail = [self giveMeProfileViewInstance];
    if(iv_pin_home.highlighted)
        [view_profileDetail updateLocationAddress:_str_address1];
    else if(iv_pin_company.highlighted)
        [view_profileDetail updateLocationAddress:_str_address2];
    [super buttonAction_left:_sender];
}

-(void)dealloc
{
    NSLog(@":::::>dealloc %s %d",__FUNCTION__,__LINE__);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_UPDATE_DEFAULTADDRESS object:nil];
    str_currentAddress = nil;
}

-(void)updateDefaultAddress
{
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    if(_str_address1 && ![_str_address1 isEmptyStr])
    {
        lb_value_home.text = [NSString stringWithFormat:@"%@\n\n%@",multiLanguage(@"HOME ADDRESS"),_str_address1 ];
        [lb_value_home setCustomColor:lb_value_home.textColor searchText:_str_address1 font:font(FONT_TEXT_REGULAR, 14)];
    }
    
    if(_str_address2 && ![_str_address2 isEmptyStr])
    {
        lb_value_company.text = [NSString stringWithFormat:@"%@\n\n%@",multiLanguage(@"COMPANY ADDRESS"),_str_address2 ];
        [lb_value_company setCustomColor:lb_value_company.textColor searchText:_str_address2 font:font(FONT_TEXT_REGULAR, 14)];
    }
    FGProfileDetailView *view_profileDetail = [self giveMeProfileViewInstance];
    if(iv_pin_home.highlighted)
        [view_profileDetail updateLocationAddress:_str_address1];
    else if(iv_pin_company.highlighted)
        [view_profileDetail updateLocationAddress:_str_address2];
}

-(void)go2SetAddressVC:(NSString *)_str_address key:(NSString *)_str_defaultAddressKey
{
    FGControllerManager *manager = [FGControllerManager sharedManager];
    FGSetAddressViewController *vc_setAddress = [[FGSetAddressViewController alloc] initWithNibName:@"FGSetAddressViewController" bundle:nil address:_str_address setDefaultAddressKEY:_str_defaultAddressKey];
    [manager pushController:vc_setAddress navigationController:nav_current];
}

-(IBAction)buttonAction_homeAddress:(id)_sender;
{
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    
    if([_str_address1 isEmptyStr])
        [self go2SetAddressVC:@"" key:KEY_DEFAULT_ADDRESS1];
    else
    {
        iv_pin_home.highlighted = YES;
        iv_pin_company.highlighted = NO;
        FGProfileDetailView *view_profileDetail = [self giveMeProfileViewInstance];
        [view_profileDetail updateLocationAddress:_str_address1];
        [self buttonAction_left:nil];
    }
}

-(IBAction)buttonAction_companyAddress:(id)_sender;
{
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    if([_str_address2 isEmptyStr])
        [self go2SetAddressVC:@"" key:KEY_DEFAULT_ADDRESS2];
    else
    {
        iv_pin_home.highlighted = NO;
        iv_pin_company.highlighted = YES;
        FGProfileDetailView *view_profileDetail = [self giveMeProfileViewInstance];
        [view_profileDetail updateLocationAddress:_str_address2];
        [self buttonAction_left:nil];
    }
}

-(IBAction)buttonAction_home_setting:(id)_sender;
{
    NSString *_str_address1 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS1];
    
    if([_str_address1 isEmptyStr])
        [self go2SetAddressVC:@"" key:KEY_DEFAULT_ADDRESS1];
    else
        [self go2SetAddressVC:lb_value_home.text key:KEY_DEFAULT_ADDRESS1];
}

-(IBAction)buttonAction_company_setting:(id)_sender;
{
    NSString *_str_address2 = (NSString *)[commond getUserDefaults:KEY_DEFAULT_ADDRESS2];
    
    if([_str_address2 isEmptyStr])
        [self go2SetAddressVC:@"" key:KEY_DEFAULT_ADDRESS2];
    else
        [self go2SetAddressVC:lb_value_company.text key:KEY_DEFAULT_ADDRESS2];
}
@end
