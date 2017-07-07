//
//  FGLocationSelectAddressDefaultAddressCell.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGCustomizableBaseView.h"
#define KEY_DEFAULT_ADDRESS1 @"KEY_DEFAULT_ADDRESS1"
#define KEY_DEFAULT_ADDRESS2 @"KEY_DEFAULT_ADDRESS2"
#define KEY_DEFAULT_ADDRESS1_LAT @"KEY_DEFAULT_ADDRESS1_LAT"
#define KEY_DEFAULT_ADDRESS1_LNG @"KEY_DEFAULT_ADDRESS1_LNG"
#define KEY_DEFAULT_ADDRESS2_LAT @"KEY_DEFAULT_ADDRESS2_LAT"
#define KEY_DEFAULT_ADDRESS2_LNG @"KEY_DEFAULT_ADDRESS2_LNG"
#define NOTIFICATION_UPDATE_DEFAULTADDRESS @"NOTIFICATION_UPDATE_DEFAULTADDRESS"

@interface FGLocationSelectAddressDefaultAddressView : FGCustomizableBaseView
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_address1;
@property(nonatomic,weak)IBOutlet UILabel *lb_address2;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin1;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin2;
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@property(nonatomic,weak)IBOutlet UIButton *btn_address1;
@property(nonatomic,weak)IBOutlet UIButton *btn_address2;
@property(nonatomic,weak)IBOutlet UIView *view_separator_h;
@end
