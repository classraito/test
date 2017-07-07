//
//  FGMyBookingPendingCellView.h
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseBookingCellView.h"
#import "FGManageBookingPendingCellView.h"

@interface FGMyBookingPendingCellView : FGManageBookingPendingCellView
@property (weak, nonatomic) IBOutlet UIButton *btn_contact;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@end
