//
//  FGBookingHistroyView.h
//  CSP
//
//  Created by JasonLu on 16/11/15.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGTrainerBookingHistoryFirstCellView.h"
#import "FGBookingCancelCoursePopView.h"

@interface FGBookingHistroyView : UIView
<UITableViewDelegate, UITableViewDataSource, FGManageBookingPendingCellViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tb_booking;
@property (nonatomic, strong) NSMutableArray *marr_data;
@property (nonatomic, copy) NSString *str_orderId;
@property (nonatomic, strong) FGBookingCancelCoursePopView * view_bookingCancelPopup;

- (void)loadData;
- (void)bindDataToUI;
- (void)bindDataToUIForCancelOrder;
@end
