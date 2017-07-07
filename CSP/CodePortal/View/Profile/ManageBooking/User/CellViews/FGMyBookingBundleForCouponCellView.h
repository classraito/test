//
//  FGMyBookingBundleForCouponCellView.h
//  CSP
//
//  Created by JasonLu on 16/12/24.
//  Copyright © 2016年 Fugumobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FGMyBookingBundleForCouponCellViewDelegate <NSObject>

@optional
- (void)action_didClickToUseCoupon:(id)sender;

@end

@interface FGMyBookingBundleForCouponCellView : UITableViewCell
@property (assign, nonatomic) id<FGMyBookingBundleForCouponCellViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *view_sepeator;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UIView *view_blackBg;
@property (weak, nonatomic) IBOutlet UIView *view_whiteBg;
@property (weak, nonatomic) IBOutlet UIButton *btn_useNow;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UIImageView *iv_gift;


@end
