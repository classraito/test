//
//  FGLocationSelectAddressCellView.h
//  CSP
//
//  Created by Ryan Gong on 16/11/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGLocationSelectAddressCellView : UITableViewCell
{
    
}
@property(nonatomic,weak)IBOutlet UILabel *lb_addressTitle;
@property(nonatomic,weak)IBOutlet UILabel *lb_addressDetail;
@property(nonatomic,weak)IBOutlet UIImageView *iv_pin;
@property(nonatomic,weak)IBOutlet UIView *view_separator;
@end
