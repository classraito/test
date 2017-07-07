//
//  FGManageBookingPendingForPayCellView.h
//  CSP
//
//  Created by JasonLu on 16/12/14.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGManageBookingPendingCellView.h"

@interface FGManageBookingPendingForPayCellView : FGManageBookingPendingCellView
@property (weak, nonatomic) IBOutlet UILabel *lb_timeCountForPay;
@property (weak, nonatomic) IBOutlet UILabel *lb_payDesc;
@property (assign, nonatomic) NSInteger int_index;
@end
