//
//  FGManageBookingViewForTrainer.h
//  CSP
//
//  Created by JasonLu on 16/11/8.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGManageBookingView.h"
@protocol FGManageBookingViewForTrainerDelegate <NSObject>
- (void)didGotoUserInfoWithUserId:(NSString *)_str_userId;
@end

@interface FGManageBookingViewForTrainer : FGManageBookingView <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *view_titleBg;
@property (strong, nonatomic) NSTimer *timer_payCount;
@property (assign, nonatomic) id<FGManageBookingViewForTrainerDelegate> delegate;

- (void)loadUIFromPendingToPay;
@end
