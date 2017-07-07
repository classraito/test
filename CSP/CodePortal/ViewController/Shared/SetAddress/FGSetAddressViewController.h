//
//  FGSetAddressViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/12/5.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGSetAddressMapView.h"
@interface FGSetAddressViewController : FGBaseViewController<UITextFieldDelegate>
{
    
}
@property(nonatomic,strong)FGSetAddressMapView *view_setAddressMap;
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,weak)IBOutlet UITextField *tf_search;
@property(nonatomic,weak)IBOutlet UILabel *lb_city;
@property(nonatomic,weak)IBOutlet UIView *view_separator_v;
@property(nonatomic,strong)NSString *str_defaultAddressKEY;
@property(nonatomic,strong)NSString *str_address;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)__str_address setDefaultAddressKEY:(NSString *)_str_setDefaultAddressKEY;
-(void)realodData:(id)_data;
-(void)getCityNameIfHave;
@end
