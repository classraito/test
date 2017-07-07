//
//  FGLocationSelectViewController.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseViewController.h"
#import "FGLocationSelectAddressDefaultAddressView.h"
@interface FGLocationSelectViewController : FGBaseViewController<UITextFieldDelegate>
{
    
}
@property(nonatomic,weak)IBOutlet UITableView *tb;
@property(nonatomic,weak)IBOutlet UITextField *tf_search;
@property(nonatomic,weak)IBOutlet UILabel *lb_city;
@property(nonatomic,weak)IBOutlet UIView *view_separator_v;
@property(nonatomic,weak)IBOutlet UIView *view_separator_h;
@property(nonatomic,weak)IBOutlet FGLocationSelectAddressDefaultAddressView *view_selectDefaultAddress;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil address:(NSString *)__str_address;
@end
