//
//  FGManageBookingPendingCellView.h
//  CSP
//
//  Created by JasonLu on 16/11/9.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import "FGBaseBookingCellView.h"
@protocol FGManageBookingPendingCellViewDelegate <NSObject>

@optional
- (void)didSelectedAcceptedWithButtonView:(UIView *)_view;
- (void)didSelectedContactWithButtonView:(UIView *)_view;
- (void)didSelectedCancelWithButtonView:(UIView *)_view;
- (void)didSelectedUserIconWithButtonView:(UIView *)_view;

@end


@interface FGManageBookingPendingCellView : FGBaseBookingCellView

@property (assign, nonatomic) id<FGManageBookingPendingCellViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_rebook;
@property (weak, nonatomic) IBOutlet UILabel *lb_date;
@property (weak, nonatomic) IBOutlet UILabel *lb_dateTime;
@property (weak, nonatomic) IBOutlet UILabel *lb_location;
@property (weak, nonatomic) IBOutlet UILabel *lb_locationDetail;
- (void)updateCellViewWithInfo:(NSDictionary *)_dataInfo;
- (void)buttonAction_gotoTrainerDetailInfo:(UIButton *)_btn;
@end
