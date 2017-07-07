//
//  FGProfileSetDefaultAddressViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/19.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGProfileSetDefaultAddressViewController : FGBaseViewController
{
    
}
@property(nonatomic,weak)IBOutlet UIView *view_container_home;
@property(nonatomic,weak)IBOutlet UIView *view_container_company;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_home;
@property(nonatomic,weak)IBOutlet UILabel *lb_value_company;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin_home;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin_company;
@property(nonatomic,weak)IBOutlet UIButton *btn_companyAddress;
@property(nonatomic,weak)IBOutlet UIButton *btn_homeAddress;
@property(nonatomic,weak)IBOutlet UIButton *btn_company_setting;
@property(nonatomic,weak)IBOutlet UIButton *btn_home_setting;
@property(nonatomic,weak)IBOutlet UIView *view_separator1;
@property(nonatomic,weak)IBOutlet UIView *view_separator2;

@property(nonatomic,strong)NSString *str_currentAddress;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)_str_address;
-(IBAction)buttonAction_companyAddress:(id)_sender;
-(IBAction)buttonAction_homeAddress:(id)_sender;
-(IBAction)buttonAction_company_setting:(id)_sender;
-(IBAction)buttonAction_home_setting:(id)_sender;
@end
